class Cctz < Formula
  desc "C++ library for translating between absolute and civil times using the rules of a time zone"
  homepage "https://github.com/google/cctz"
  url "https://github.com/google/cctz/archive/v2.2.tar.gz"
  sha256 "ab315d5beb18a65ace57f6ea91f9ea298ec163fee89f84a44e81732af4d07348"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "." << "-DBUILD_EXAMPLES=OFF" << "-DBUILD_TESTING=OFF"
    system "cmake", *args
    system "make"
    prefix.install "include"
    lib.install "libcctz.a"
  end
end
