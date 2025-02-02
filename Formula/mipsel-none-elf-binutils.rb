class MipselNoneElfBinutils < Formula
  desc "FSF Binutils for mipsel cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.gz"
  sha256 "025c436d15049076ebe511d29651cc4785ee502965a8839936a65518582bdd64"

  def install
    system "./configure", "--target=mipsel-none-elf",
                          # "--disable-multilib",
                          "--enable-multilib",
                          "--enable-interwork",
                          "--disable-nls",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
  test do
    assert_match "f()", shell_output("#{bin}/mipsel-none-elf-c++filt _Z1fv")
  end
end
