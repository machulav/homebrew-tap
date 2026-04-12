class Accountant24 < Formula
  desc "Your personal AI accountant — plain-text bookkeeping with any LLM"
  homepage "https://github.com/machulav/accountant24"
  version "0.2.0"
  license "MIT"

  # Auto-installed when the user runs `brew install machulav/tap/accountant24`.
  # This is the whole point of having a brew formula: no separate prereq step.
  depends_on "hledger"

  on_macos do
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.2.0/accountant24-darwin-arm64.tar.gz"
      sha256 "82397deef570340441ea7aa7c2372fd4332f16c84d1329c13601f4b971df20a6"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.2.0/accountant24-darwin-x64.tar.gz"
      sha256 "87915b6d2d29fc1a0afd07dbf705c5af434d0a88775f927dd3f8d445da17ed70"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.2.0/accountant24-linux-x64.tar.gz"
      sha256 "2e6c77888d99eafec750f4b6d2a6541e9ed531e8bf4ecad34b8a97037d54ce21"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.2.0/accountant24-linux-arm64.tar.gz"
      sha256 "2e9d72edd3af55808cb04237bdbf1e861894ade9baa515b7745eed743b8a37f3"
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
