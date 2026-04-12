class Accountant24 < Formula
  desc "Your personal AI accountant — plain-text bookkeeping with any LLM"
  homepage "https://github.com/machulav/accountant24"
  version "0.1.1"
  license "MIT"

  # Auto-installed when the user runs `brew install machulav/tap/accountant24`.
  # This is the whole point of having a brew formula: no separate prereq step.
  depends_on "hledger"

  on_macos do
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.1/accountant24-darwin-arm64.tar.gz"
      sha256 "b394cf720ab71a46edd4bf4970b53b88a52769808a8d007dd93030ba237a139d"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.1/accountant24-darwin-x64.tar.gz"
      sha256 "22474b359e169952dbcece5a63267e3ac6f92bd4de0dbfaef674bad9b8ec1949"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.1/accountant24-linux-x64.tar.gz"
      sha256 "ae88b53cefa4b962374b7c081209daf41a0f2cee282562c3f2a73ac7bed5891e"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.1/accountant24-linux-arm64.tar.gz"
      sha256 "52a2235ac45200be8ada25fb3249946d12470abd679132b1f4f37c43f2c42c45"
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
