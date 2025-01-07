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
    # Check for existing node installation in multiple locations
    node_path = nil
    
    # Check in Homebrew
    brew_node = "/usr/local/bin/node"
    if File.exist?(brew_node)
      node_path = brew_node
    end
    
    # Check in system bin folder
    bin_node = "/usr/bin/node"
    if node_path.nil? && File.exist?(bin_node)
      node_path = bin_node
    end
    
    # Check in PATH as fallback
    if node_path.nil? && ENV["PATH"].split(File::PATH_SEPARATOR).any? { |path| File.exist?(File.join(path, "node")) }
      node_path = `which node`.chomp
    end
    
    # Verify we found node
    if node_path.nil?
      odie "Node.js is required but not found. Please install Node.js first."
    end
    
    # Verify minimum node version
    node_version = `"#{node_path}" --version`.chomp.delete_prefix("v")
    if Gem::Version.new(node_version) < Gem::Version.new("14.0.0")
      odie "Node.js version 14.0.0 or higher is required. Current version: #{node_version}"
    end
    
    # Extract the package contents
    system "tar", "xf", cached_download, "-C", buildpath
    
    # Create package.json if it doesn't exist
    system "npm", "init", "-y" unless File.exist? "package.json"
    
    # Install dependencies
    system "npm", "install", "commander@12.1.0"
    system "npm", "install", "chalk@4.1.2"
    system "npm", "install", "figlet@1.8.0"
    
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