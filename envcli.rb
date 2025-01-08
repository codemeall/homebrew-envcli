class Envcli < Formula
  desc "A CLI tool for managing environment variables"
  homepage "https://github.com/codemeall/envcli"
  url "https://github.com/codemeall/envcli/releases/download/v1.0.8/envcli-1.0.8.tgz"
  sha256 "a9d4b90f714b57bf4e07f0504cdef06f4f805849cc9e40b742ae982bf09e35f9"
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
    
    # Create bin stubs with environment variables
    (bin/"envcli").write <<~EOS
      #!/bin/bash
      export NODE_PATH="#{libexec}/node_modules"
      export ENVCLI_CONFIG_DIR="#{var}/envcli"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/index.js" ""
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
  end
end
