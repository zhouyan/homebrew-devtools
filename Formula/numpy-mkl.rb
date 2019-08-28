class NumpyMkl < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://github.com/numpy/numpy/releases/download/v1.17.1/numpy-1.17.1.tar.gz"
  sha256 "24d479ebc92f2d1c739622568f0e4d1382c6bf9778505146a370c8e2f5749839"

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

    ["FC", "F77"].each do |f|
      ENV[f] = "/opt/intel/bin/ifort"
    end

    ["FFLAGS", "FCFLAGS"].each do |f|
      ENV.append f, "-xHost -g -O2"
    end

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
