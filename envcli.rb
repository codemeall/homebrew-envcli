class Envcli < Formula
    desc "A CLI tool for managing environment variables"
    homepage "https://github.com/codemeall/envcli"
    url "https://github.com/codemeall/envcli/releases/download/v1.0.3/envcli-1.0.3.tgz"
    sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
    license "ISC"
  
    depends_on "node"
  
    def install
      bin.install "envcli"
    end
  
    test do
      assert_match "envcli version", shell_output("#{bin}/envcli --version")
    end
  end