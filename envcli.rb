class Envcli < Formula
  desc "A CLI tool for managing environment variables"
  homepage "https://github.com/codemeall/envcli"
  url "https://github.com/codemeall/envcli/releases/download/v1.0.6/envcli-1.0.6.tgz"
  sha256 "68de682f26c7bf195637f93be338dba81e78a897c5fc075959fbf4ccc043ee6d"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # Remove direct node dependency
  # depends_on "node"

  def install
    # Check for existing node installation
    if ENV["PATH"].split(File::PATH_SEPARATOR).any? { |path| File.exist?(File.join(path, "node")) }
      node_path = `which node`.chomp
    else
      odie "Node.js is required but not found. Please install Node.js first."
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