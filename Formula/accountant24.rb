class Accountant24 < Formula
  desc "Your personal AI accountant — plain-text bookkeeping with any LLM"
  homepage "https://github.com/machulav/accountant24"
  version "0.1.7"
  license "MIT"

  # Auto-installed when the user runs `brew install machulav/tap/accountant24`.
  # This is the whole point of having a brew formula: no separate prereq step.
  depends_on "hledger"
  depends_on "poppler"
  depends_on "tesseract"

  on_macos do
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.7/accountant24-darwin-arm64.tar.gz"
      sha256 "938b9726b321bb12f15205800812e03c2755406bbbe6757de9153c83a894067a"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.7/accountant24-darwin-x64.tar.gz"
      sha256 "d7c372939b2b0526cb2cfb79ff3d7cc0179bfc27133f147e62dd45d67c44b105"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.7/accountant24-linux-x64.tar.gz"
      sha256 "8c58bdd65827ff3d7a29ef4dde80da6d2b1338095205c03a32f10bd30b41c1e7"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.7/accountant24-linux-arm64.tar.gz"
      sha256 "ba57ad23b399a7613ff28df65abf5d74e6c11d8ff58607cf43e17261d21acb0e"
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
