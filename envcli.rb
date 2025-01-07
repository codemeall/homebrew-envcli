class Envcli < Formula
  desc "A CLI tool for managing environment variables"
  homepage "https://github.com/codemeall/envcli"
  url "https://github.com/codemeall/irootcli/releases/download/v1.0.1/envcli-1.0.8.tgz"
  sha256 "4ee9d0867a668b54e2cbb222f6a59769812a67d13d072a53e30844adbe2b68d9"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "node"

  def install
    # Extract the package contents
    system "tar", "xf", cached_download, "-C", buildpath
    
    # Move package contents to libexec
    libexec.install Dir["*"]
    
    # Ensure config directory exists
    (var/"envcli").mkpath
    
    # Create bin stubs with environment variables
    (bin/"envcli").write <<~EOS
      #!/bin/bash
      export NODE_PATH="#{libexec}/node_modules"
      export ENVCLI_CONFIG_DIR="#{var}/envcli"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/index.js" "$@"
    EOS
    
    # Make the bin stub executable
    chmod 0755, bin/"envcli"
  end

  def post_install
    # Ensure config directory has correct permissions
    (var/"envcli").mkpath
    chmod 0755, var/"envcli"
  end

  test do
    assert_match "envcli", shell_output("#{bin}/envcli about")
    assert_match version.to_s, shell_output("#{bin}/envcli version")
  end
end