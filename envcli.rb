class Envcli < Formula
  desc "A CLI tool for managing environment variables"
  homepage "https://github.com/codemeall/envcli"
  url "https://github.com/codemeall/envcli/releases/download/v1.0.3/envcli-1.0.3.tgz"
  sha256 "1bf3311ddc595da5ff2f211cdc9b8cfeb97dc5b8d55ffe6f16539959c9ca4748"
  license "ISC"
  depends_on "node"
  def install
    # Extract the package contents
    system "tar", "xf", cached_download, "-C", buildpath
    
    # Move package contents to libexec
    libexec.install Dir["*"]
    
    # Create bin stubs
    (bin/"envcli").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/index.js" "$@"
    EOS
    
    # Make the bin stub executable
    chmod 0755, bin/"envcli"
  end
  test do
    assert_match "envcli", shell_output("#{bin}/envcli about")
  end
end