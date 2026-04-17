class Accountant24 < Formula
  desc "Your personal AI accountant — plain-text bookkeeping with any LLM"
  homepage "https://github.com/machulav/accountant24"
  version "0.1.4"
  license "MIT"

  # Auto-installed when the user runs `brew install machulav/tap/accountant24`.
  # This is the whole point of having a brew formula: no separate prereq step.
  depends_on "hledger"

  on_macos do
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.4/accountant24-darwin-arm64.tar.gz"
      sha256 "65e4eaa7cdb95472c3187dd9c18346a8654eb252d28f821c8d0385d7d460e2f9"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.4/accountant24-darwin-x64.tar.gz"
      sha256 "19005a5cefc7dc85aa03c72da96d8782fb63c66e8ff10e618b9f5cd9d49c9aac"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.4/accountant24-linux-x64.tar.gz"
      sha256 "8ca8f7e9810012b496bf099302e30b6cbd4d0a9f526c8f111c311bcc4523fcbc"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.4/accountant24-linux-arm64.tar.gz"
      sha256 "1cbb9660f105d39a29fd9b887bc375043b0b074c53da475a54ecc7642c8eefe2"
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
