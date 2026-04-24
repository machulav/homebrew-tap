class Accountant24 < Formula
  desc "Your personal AI accountant — plain-text bookkeeping with any LLM"
  homepage "https://github.com/machulav/accountant24"
  version "0.1.8"
  license "MIT"

  # Auto-installed when the user runs `brew install machulav/tap/accountant24`.
  # This is the whole point of having a brew formula: no separate prereq step.
  depends_on "hledger"
  depends_on "poppler"
  depends_on "tesseract"

  on_macos do
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.8/accountant24-darwin-arm64.tar.gz"
      sha256 "be29067c65a9b4d5725e272bc2a8aad492c38f77a10181dbe8fb71ed8c59aa4b"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.8/accountant24-darwin-x64.tar.gz"
      sha256 "462f05bd34a51baeadbc0a1e42bcc295c0edb2f384df49a419e2fc2cfe4780eb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.8/accountant24-linux-x64.tar.gz"
      sha256 "d7602af342f188a3bd11ba0bcd8ebb20272f51eb924c180f4148d1c648ab7b1f"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.8/accountant24-linux-arm64.tar.gz"
      sha256 "31e708e73f62ab4cd2af9da0459b6b73bdb693ee56fa11f385a8f487dd24a854"
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
