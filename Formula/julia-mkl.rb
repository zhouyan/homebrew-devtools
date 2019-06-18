class JuliaMkl < Formula
  desc "The Julia Programming Language"
  homepage "https://julialang.org"
  url "https://github.com/JuliaLang/julia/releases/download/v1.1.1/julia-1.1.1-full.tar.gz"
  sha256 "3c5395dd3419ebb82d57bcc49dc729df3b225b9094e74376f8c649ee35ed79c2"

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "curl"
  depends_on "gmp"
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "mbedtls"
  depends_on "pcre2"
  depends_on "suite-sparse"

  def install
    File.open("Make.user", "w") do |f|
      f << "prefix=#{prefix}\n"
      f << "USE_BLAS64=0\n"
      f << "USE_INTEL_MKL=1\n"
      f << "USE_INTEL_MKL_FFT=1\n"
      f << "USE_SYSTEM_ARPACK=1\n"
      f << "USE_SYSTEM_CURL=1\n"
      f << "USE_SYSTEM_GMP=1\n"
      f << "USE_SYSTEM_LIBGIT2=1\n"
      f << "USE_SYSTEM_LIBM=1\n"
      f << "USE_SYSTEM_LIBSSH2=1\n"
      f << "USE_SYSTEM_LIBUNWIND=1\n"
      f << "USE_SYSTEM_MBEDTLS=1\n"
      f << "USE_SYSTEM_MPFR=1\n"
      f << "USE_SYSTEM_PCRE=1\n"
      f << "USE_SYSTEM_SUITESPARSE=1\n"
    end

    ENV.append "LDFLAGS", "-L/opt/intel/mkl/lib"
    ENV.append "DYLD_LIBRARY_PATH", "/opt/intel/mkl/lib"

    system "make", "install"
  end

  def post_install
    short_version =
      `#{bin}/Rscript -e 'cat(as.character(getRversion()[1,1:2]))'`.strip
    site_library = HOMEBREW_PREFIX/"lib/R/#{short_version}/site-library"
    site_library.mkpath
    ln_s site_library, lib/"R/site-library"
  end
end
