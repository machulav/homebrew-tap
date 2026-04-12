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
      sha256 "c2718ba40fcf9ffccd1905e22c48cce98013a5039d6c2071577a9d77d91cdc63"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.2.0/accountant24-darwin-x64.tar.gz"
      sha256 "1d5d7c1091c7b291803b6f0582ff090de363296b230ecdefbd7a28e8ff0675c4"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.2.0/accountant24-linux-x64.tar.gz"
      sha256 "5ca5727f3515c6e2f160bf30d1ee3221488ef53e7d0172c8f21a3ffb6e9b0a27"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.2.0/accountant24-linux-arm64.tar.gz"
      sha256 "cb8fee9c7472b97932224194eda533c47a8b9cba1c5f7d8106af72cb5727ba44"
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
