class MipselNoneElfGcc < Formula
  desc "GNU compiler collection for mipsel-none-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz"
  sha256 "7d376d445f93126dc545e2c0086d0f647c3094aae081cdb78f42ce2bc25e7293"

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mipsel-none-elf-binutils"
  depends_on "mpfr"

  # Branch from the Darwin maintainer of GCC, with a few generic fixes and
  # Apple Silicon support, located at https://github.com/iains/gcc-14-branch
  # Taken from the `gcc` Formula code: https://formulae.brew.sh/formula/gcc
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f30c309442a60cfb926e780eae5d70571f8ab2cb/gcc/gcc-14.2.0-r2.diff"
    sha256 "6c0a4708f35ccf2275e6401197a491e3ad77f9f0f9ef5761860768fa6da14d3d"
  end

  def install
    mkdir "mipsel-none-elf-gcc-build" do
      system "../configure", "--target=mipsel-none-elf", # cpu-company-system
                             "--prefix=#{prefix}",
                             "--enable-interwork",
                             "--enable-multilib",
                             "--without-isl",
                             "--disable-nls",
                             "--disable-threads",
                             "--disable-shared",
                             "--disable-libssp",
                             "--disable-libstdcxx-pch",
                             "--disable-libgomp",
                             "--disable-werror",
                             "--without-headers",
                             "--with-as=#{Formula["mipsel-none-elf-binutils"].bin}/mipsel-none-elf-as", # assembler
                             "--with-ld=#{Formula["mipsel-none-elf-binutils"].bin}/mipsel-none-elf-ld", # linker
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"
    end
  end

  test do
    (testpath/"test-c.c").write <<~EOS
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    EOS
    system "#{bin}/mipsel-none-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
  end
end
