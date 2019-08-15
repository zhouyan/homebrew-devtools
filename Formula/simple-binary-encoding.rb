class SimpleBinaryEncoding < Formula
  desc "Simple Binary Encoding (SBE) - High Performance Message Codec"
  homepage "https://github.com/real-logic/simple-binary-encoding"
  url "https://github.com/real-logic/simple-binary-encoding/archive/1.11.0.tar.gz"
  sha256 "03bfcba38a1a1d0c068c32ab6f2d17e5f477e617ae45a786b88bea6424617206"

  depends_on "cmake" => :build

  def install
    system "./gradlew", "build", "-x", "test"
    mkdir "build" do
      args = std_cmake_args
      args << ".."
      system "cmake", *args
      system "make", "all"
      lib.install Dir["lib/*"]
    end
    lib.install Dir["sbe-all/libs/*"]
    include.install "sbe-tool/src/main/cpp/otf"
    include.install "sbe-tool/src/main/cpp/sbe"
  end
end
