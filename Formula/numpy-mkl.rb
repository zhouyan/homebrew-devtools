class NumpyMkl < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://github.com/numpy/numpy/releases/download/v1.17.0/numpy-1.17.0.tar.gz"
  sha256 "47b7b6145e7ba5918ce26be25999b6d4b35cf9fbfdf46b7da50090ffdb020445"
  head "https://github.com/numpy/numpy.git"

  depends_on "gcc" => :build # for gfortran
  depends_on "python"

  def install
    config = <<~EOS
      [mkl]
      library_dirs = /opt/intel/mkl/lib
      include_dirs = /opt/intel/mkl/include
      mkl_libs = mkl_rt
      lapack_libs =
    EOS

    Pathname("site.cfg").write config

    python = "python3"
    version = Language::Python.major_minor_version python
    dest_path = lib/"python#{version}/site-packages"
    dest_path.mkpath

    ENV.prepend_create_path "PYTHONPATH", buildpath/"tools/lib/python#{version}/site-packages"

    system python, "setup.py",
      "config",
      "build_clib",
      "--parallel=#{ENV.make_jobs}",
      "install",
      "--prefix=#{prefix}",
      "--single-version-externally-managed",
      "--record=installed.txt"
  end
end
