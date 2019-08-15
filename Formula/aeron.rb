class Aeron < Formula
  desc "Efficient reliable UDP unicast, UDP multicast, and IPC message transport"
  homepage "https://github.com/real-logic/Aeron"
  url "https://github.com/real-logic/aeron/archive/1.15.0.tar.gz"
  sha256 "7237eff6ed1f4182cccdf6af52e705d232a81407a273dfb00b8160a92f5949d0"

  depends_on "cmake" => :build
  depends_on "simple-binary-encoding"

  def install
    system "./gradlew", "build", "-x", "test"
    mkdir "build" do
      args = std_cmake_args
      args << ".."
      args << "-DBUILD_AERON_DRIVER=ON"
      args << "-DBUILD_AERON_ARCHIVE_API=ON"
      args << "-DAERON_TESTS=OFF"
      args << "-DAERON_BUILD_SAMPLES=ON"
      system "cmake", *args
      system "make", "install"
    end
    lib.install Dir["aeron-all/build/libs/*"]
  end
end
