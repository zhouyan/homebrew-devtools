class Rxcpp < Formula
  desc "Reactive Extensions for C++"
  homepage "https://github.com/ReactiveX/RxCpp"
  url "https://github.com/ReactiveX/RxCpp/archive/4.1.0.tar.gz"
  sha256 "d3bb49c7ac6b5c43235df710510fce87d827bb88a1b78242017f190d2acbbdea"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "."
    system "cmake", *args
    system "make", "install"
  end
end
