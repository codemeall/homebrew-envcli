class Envcli < Formula
    desc "A CLI tool for managing environment variables"
    homepage "https://github.com/codemeall/envcli"
    url "https://github.com/codemeall/envcli/archive/refs/tags/v1.0.1.tar.gz"
    sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5" # You'll need to calculate this
    license "ISC"
  
    depends_on "node"
  
    def install
      system "npm", "install", *Language::Node.std_npm_install_args(libexec)
      bin.install_symlink Dir["#{libexec}/bin/*"]
    end
  
    test do
      system "#{bin}/envcli", "about"
    end
  end 