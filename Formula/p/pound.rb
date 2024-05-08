class Pound < Formula
  desc "Reverse proxy, load balancer and HTTPS front-end for web servers"
  homepage "https://github.com/graygnuorg/pound"
  url "https://github.com/graygnuorg/pound/releases/download/v4.12/pound-4.12.tar.gz"
  sha256 "3276463b3faacfa5c7f16daac2c3d7f9d5946b4505c12923c32e017b7229a1f2"
  license "GPL-3.0-or-later"

  depends_on "openssl@3"
  depends_on "gperftools"
  depends_on "pcre"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"pound.cfg").write <<~EOS
      ListenHTTP
        Address 1.2.3.4
        Port    80
        Service
          HeadRequire "Host: .*www.server0.com.*"
          BackEnd
            Address 192.168.0.10
            Port    80
          End
        End
      End
    EOS

    system "#{sbin}/pound", "-f", "#{testpath}/pound.cfg", "-c"
  end
end
