class Envcli < Formula
  desc "A CLI tool for managing environment variables"
  homepage "https://github.com/codemeall/envcli"
  url "https://github.com/codemeall/envcli/releases/download/v1.0.8/envcli-1.0.8.tgz"
  sha256 "9a2f4fde7827512836900a2c7c27d13c68c8f1b4fe4c35329b01f8d699d15e2f"
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
    
    # Create bin stubs
    (bin/"envcli").write <<~EOS
      #!/bin/bash
      exec "\#{Formula["node"].opt_bin}/node" "\#{libexec}/index.js" "$@"
    EOS
    
    # Make the bin stub executable
    chmod 0755, bin/"envcli"
  end

  test do
    assert_match "envcli", shell_output("\#{bin}/envcli about")
  end
end
