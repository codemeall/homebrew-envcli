class Envcli < Formula
  desc "A CLI tool for managing environment variables"
  homepage "https://github.com/codemeall/envcli"
  url "https://github.com/codemeall/irootcli/releases/download/v1.0.1/envcli-1.0.7.tgz"
  sha256 "3c72acfcf3578c38b73234758cbd779ec9345ffe5eb8412f1de96f51c55ea824"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # Remove direct node dependency
  # depends_on "node"

  def install
    # Use system node directly
    node_path = `which node`.chomp
    
    # Extract the package contents
    system "tar", "xf", cached_download, "-C", buildpath
    
    # Create package.json if it doesn't exist
    system "npm", "init", "-y" unless File.exist? "package.json"
    
    # Install dependencies with more verbose output and error handling
    system "npm", "install", "--verbose", "commander@12.1.0" or raise "Failed to install commander"
    system "npm", "install", "--verbose", "chalk@4.1.2" or raise "Failed to install chalk"
    system "npm", "install", "--verbose", "figlet@1.8.0" or raise "Failed to install figlet"
    
    # Move package contents to libexec
    libexec.install Dir["*"]
    libexec.install Dir["node_modules"]
    
    # Create bin stubs using system node
    (bin/"envcli").write <<~EOS
      #!/bin/bash
      export NODE_PATH="#{libexec}/node_modules"
      exec "#{node_path}" "#{libexec}/index.js" "$@"
    EOS
    
    # Make the bin stub executable
    chmod 0755, bin/"envcli"
  end
  test do
    assert_match "envcli", shell_output("#{bin}/envcli about")
    assert_match version.to_s, shell_output("#{bin}/envcli version")
  end
end