class Accountant24 < Formula
  desc "Your personal AI accountant — plain-text bookkeeping with any LLM"
  homepage "https://github.com/machulav/accountant24"
  version "0.1.10"
  license "MIT"

  # The CLI distribution is retired; Accountant24 now ships as a macOS app.
  # NOTE: update the date to the actual push date when publishing this commit.
  disable! date: "2026-07-01", because: "is replaced by the Accountant24 macOS app: https://github.com/machulav/accountant24/releases"

  # Auto-installed when the user runs `brew install machulav/tap/accountant24`.
  # This is the whole point of having a brew formula: no separate prereq step.
  depends_on "hledger"
  depends_on "poppler"
  depends_on "tesseract"

  on_macos do
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.10/accountant24-darwin-arm64.tar.gz"
      sha256 "fb5ea2eeb0f1f9ad4e2eb0d4f3014d4af381ceb4658a0529345cbb1d3de8ea05"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.10/accountant24-darwin-x64.tar.gz"
      sha256 "576ebda23ab59a258c0aecef3e6c05c2799beaa16f820e72616c345ec20c02fa"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.10/accountant24-linux-x64.tar.gz"
      sha256 "da90626abda9745da6c1523a8d5b7d572bc22ef64e31ad412be2e0e3ab17b9e1"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.10/accountant24-linux-arm64.tar.gz"
      sha256 "9f4dffffcbec6578127059b9c345a671728c6691f8cf6d80b0105bf30e299aed"
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
    assert_match(/./, shell_output("#{bin}/accountant24 --version"))
    assert_match(/./, shell_output("#{bin}/a24 --version"))
  end
end
