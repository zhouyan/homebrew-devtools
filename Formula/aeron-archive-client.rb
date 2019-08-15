class AeronArchiveClient < Formula
  desc "C++ implementation of Aeron Archive client"
  homepage "https://github.com/fairtide/aeron-archive-client"
  url "https://github.com/fairtide/aeron-archive-client/archive/0.2.9.tar.gz"
  sha256 "066bae267d14c2532ae5c3409bb52998fa64a6a914b54898e6b674a59b5fc00d"

  depends_on "cmake" => :build
  depends_on "aeron"
  depends_on "boost"

  def install
    args = std_cmake_args
    args << "."
    system "cmake", *args
    system "make", "install"
  end
end
