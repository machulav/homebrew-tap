class Accountant24 < Formula
  desc "Your personal AI accountant — plain-text bookkeeping with any LLM"
  homepage "https://github.com/machulav/accountant24"
  version "0.1.6"
  license "MIT"

  # Auto-installed when the user runs `brew install machulav/tap/accountant24`.
  # This is the whole point of having a brew formula: no separate prereq step.
  depends_on "hledger"
  depends_on "poppler"
  depends_on "tesseract"

  on_macos do
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.6/accountant24-darwin-arm64.tar.gz"
      sha256 "d00c322c1bf9ae8a0842062dd2a1f6ec2e30231fddff423432a6ec6f66d28c9a"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.6/accountant24-darwin-x64.tar.gz"
      sha256 "e76dde700d484be6be512e91563cd66d5857b5281bcf0c0e43fd6d0987b62932"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.6/accountant24-linux-x64.tar.gz"
      sha256 "88265bcc577d75cfe5e013170b913e076de4663e7fb839241fec053eba622164"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.6/accountant24-linux-arm64.tar.gz"
      sha256 "16a79282a8948e1ee7de0ef40b9c24fe57e105edf2e0f598c39352351b3f7e76"
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
