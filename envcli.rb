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

  def install
    # Check if Node.js is installed
    node_executable = which("node")
    odie "Node.js is not installed. Please install it and try again." unless node_executable

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

    # Create bin stubs
    (bin/"envcli").write <<~EOS
      #!/bin/bash
      export NODE_PATH="#{libexec}/node_modules"
      exec "#{node_executable}" "#{libexec}/index.js" "$@"
    EOS

    # Make the bin stub executable
    chmod 0755, bin/"envcli"
  end

  def caveats
    <<~EOS
      envcli requires Node.js. Please ensure Node.js is installed on your system.
      You can install it with:
        brew install node
    EOS
  end

  test do
    assert_match "envcli", shell_output("#{bin}/envcli about")
    assert_match version.to_s, shell_output("#{bin}/envcli version")
  end
end