class RMkl < Formula
  desc "Software environment for statistical computing"
  homepage "https://www.r-project.org/"
  url "https://cran.r-project.org/src/base/R-3/R-3.6.1.tar.gz"
  sha256 "5baa9ebd3e71acecdcc3da31d9042fb174d55a42829f8315f2457080978b1389"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "pcre"
  depends_on "readline"
  depends_on "xz"

  # needed to preserve executable permissions on files without shebangs
  skip_clean "lib/R/bin"

  def install
    # Fix dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    if MacOS.version == "10.11" && MacOS::Xcode.installed? &&
       MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_have_decl_clock_gettime"] = "no"
    end

    args = [
      "--prefix=#{prefix}",
      "--enable-memory-profiling",
      "--without-cairo",
      "--without-x",
      "--with-aqua",
      "--with-lapack",
      "--enable-R-shlib",
      "SED=/usr/bin/sed", # don't remember Homebrew's sed shim
      "--disable-java",
      "--with-blas=-lmkl_rt",
    ]

    # Help CRAN packages find gettext and readline
    ["gettext", "readline"].each do |f|
      ENV.append "CPPFLAGS", "-I#{Formula[f].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula[f].opt_lib}"
    end

    # Intel specfic

    ENV.append "LDFLAGS", "-L/opt/intel/mkl/lib"
    ENV.append "DYLD_LIBRARY_PATH", "/opt/intel/mkl/lib"

    ["FC", "F77"].each do |f|
      ENV[f] = "/opt/intel/bin/ifort"
    end

    ["FFLAGS", "FCFLAGS"].each do |f|
      ENV.append f, "-xHost -g -O2"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize do
      system "make", "install"
    end

    r_home = lib/"R"

    # make Homebrew packages discoverable for R CMD INSTALL
    inreplace r_home/"etc/Makeconf" do |s|
      s.gsub!(/^CPPFLAGS =.*/, "\\0 -I#{HOMEBREW_PREFIX}/include")
      s.gsub!(/^LDFLAGS =.*/, "\\0 -L#{HOMEBREW_PREFIX}/lib")
      s.gsub!(/.LDFLAGS =.*/, "\\0 $(LDFLAGS)")
    end

    include.install_symlink Dir[r_home/"include/*"]
    lib.install_symlink Dir[r_home/"lib/*"]
  end

  def post_install
    short_version =
      `DYLD_LIBRARY_PATH=/opt/intel/mkl/lib #{bin}/Rscript -e 'cat(as.character(getRversion()[1,1:2]))'`.strip
    site_library = HOMEBREW_PREFIX/"lib/R/#{short_version}/site-library"
    site_library.mkpath
    ln_s site_library, lib/"R/site-library"
  end
end
