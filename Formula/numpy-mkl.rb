class NumpyMkl < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/ac/36/325b27ef698684c38b1fe2e546e2e7ef9cecd7037bcdb35c87efec4356af/numpy-1.17.2.zip"
  sha256 "73615d3edc84dd7c4aeb212fa3748fb83217e00d201875a47327f55363cef2df"
  head "https://github.com/numpy/numpy.git"

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
