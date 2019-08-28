class JuliaMkl < Formula
  desc "The Julia Programming Language"
  homepage "https://julialang.org"
  url "https://github.com/JuliaLang/julia/releases/download/v1.2.0/julia-1.2.0-full.tar.gz"
  sha256 "2419b268fc5c3666dd9aeb554815fe7cf9e0e7265bc9b94a43957c31a68d9184"

  depends_on "cmake" => :build
  depends_on "curl"
  depends_on "gcc"
  depends_on "gmp"
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "mbedtls"
  depends_on "mpfr"
  depends_on "pcre2"

  def install
    File.open("Make.user", "w") do |f|
      f << "prefix=#{prefix}\n"
      f << "USE_BLAS64=0\n"
      f << "USE_INTEL_MKL=1\n"
      f << "USE_INTEL_MKL_FFT=1\n"
      f << "USE_SYSTEM_CURL=1\n"
      f << "USE_SYSTEM_GMP=1\n"
      f << "USE_SYSTEM_LIBGIT2=1\n"
      f << "USE_SYSTEM_LIBM=1\n"
      f << "USE_SYSTEM_LIBSSH2=1\n"
      f << "USE_SYSTEM_LIBUNWIND=1\n"
      f << "USE_SYSTEM_MBEDTLS=1\n"
      f << "USE_SYSTEM_MPFR=1\n"
      f << "USE_SYSTEM_PCRE=1\n"
    end

    ENV.append "LDFLAGS", "-L/opt/intel/mkl/lib"
    ENV.append "DYLD_LIBRARY_PATH", "/opt/intel/mkl/lib"

    system "make", "install"
  end
end
