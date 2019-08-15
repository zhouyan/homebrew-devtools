class Quickfix < Formula
  desc "QuickFIX C++ Fix Engine Library"
  homepage "https://github.com/quickfix/quickfix"
  url "https://github.com/quickfix/quickfix/archive/v1.15.1.tar.gz"
  sha256 "1c4322a68704526ca3d1f213e7b0dcd30e067a8815be2a79b2ab1197ef70dcf7"

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    args = std_cmake_args
    args << "."
    args << "-DHAVE_SSL=ON"
    system "cmake", *args
    system "make", "install"
  end
end
