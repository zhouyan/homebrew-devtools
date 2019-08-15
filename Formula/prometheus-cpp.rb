class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp/archive/v0.6.0.tar.gz"
  sha256 "2486b4e2daf36d6c9da5f683938757d0774ca8c3fef587d20e7ffdd14d36f276"

   resource "civetweb" do
     url "https://github.com/civetweb/civetweb/archive/v1.11.tar.gz"
     sha256 "de7d5e7a2d9551d325898c71e41d437d5f7b51e754b242af897f7be96e713a42"
   end

  depends_on "cmake" => :build

  def install
    (buildpath/"3rdparty/civetweb").install resource("civetweb")
    args = std_cmake_args
    args << "."
    args << "-DENABLE_TESTING=OFF"
    system "cmake", *args
    system "make", "install"
  end
end
