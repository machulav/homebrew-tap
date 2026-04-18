class Accountant24 < Formula
  desc "Your personal AI accountant — plain-text bookkeeping with any LLM"
  homepage "https://github.com/machulav/accountant24"
  version "0.1.5"
  license "MIT"

  # Auto-installed when the user runs `brew install machulav/tap/accountant24`.
  # This is the whole point of having a brew formula: no separate prereq step.
  depends_on "hledger"
  depends_on "poppler"
  depends_on "tesseract"

  on_macos do
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.5/accountant24-darwin-arm64.tar.gz"
      sha256 "d53ee5f408ecb58bb4a618a09f82c5cfc75251a66cdf77f579428b201e5a36b6"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.5/accountant24-darwin-x64.tar.gz"
      sha256 "096e70390ee9ed44bd3bd5f4663c6eb5b46ac5aa7ffd7ae08e7da41e1fcec4b3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.5/accountant24-linux-x64.tar.gz"
      sha256 "222a4e33dc3992a1c8e2c121d44d2c5bcd76e343db18c6c6e415742afe5bb0fa"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.5/accountant24-linux-arm64.tar.gz"
      sha256 "ac6f9cb8ce1eea8f05c9124edb0253b948897fd8bedb59563f2fe6cad06b155a"
    end
  end

  def install
    # Binary `accountant24` and its sidecars live together in libexec/ —
    # pi-coding-agent resolves sidecars via dirname(process.execPath), so
    # they must be next to the real binary, not in bin/.
    libexec.install "accountant24", "package.json", "theme", "export-html"

    # Primary command `accountant24` — shell shim that exec's
    # libexec/accountant24, so process.execPath ends up as
    # libexec/accountant24 and sidecars resolve.
    bin.write_exec_script libexec/"accountant24"

    # Short alias `a24` → symlink to the primary shim. Following this
    # resolves to bin/accountant24, which execs libexec/accountant24 —
    # process.execPath is still libexec/accountant24 regardless of which
    # name the user typed.
    (bin/"a24").make_symlink(bin/"accountant24")
  end

  test do
    assert_match(/./, shell_output("#{bin}/accountant24 --version", 0))
    assert_match(/./, shell_output("#{bin}/a24 --version", 0))
  end
end
