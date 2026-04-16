class Accountant24 < Formula
  desc "Your personal AI accountant — plain-text bookkeeping with any LLM"
  homepage "https://github.com/machulav/accountant24"
  version "0.1.3"
  license "MIT"

  # Auto-installed when the user runs `brew install machulav/tap/accountant24`.
  # This is the whole point of having a brew formula: no separate prereq step.
  depends_on "hledger"

  on_macos do
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.3/accountant24-darwin-arm64.tar.gz"
      sha256 "1c45b6e2707885851df7c0f5f752c942516323a0fc97bbda1130ff2469c89d78"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.3/accountant24-darwin-x64.tar.gz"
      sha256 "36acbe0981a4ea62f4a0907e2aaed81db46788c638c6aea7c5232a3d9f152784"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.3/accountant24-linux-x64.tar.gz"
      sha256 "53f95d7b0edcb24614f28d83d964caed53afc91aa2072e8eb11422d6c7a171a3"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.3/accountant24-linux-arm64.tar.gz"
      sha256 "37b223a89da4b9b7ffc27d5e805ae71aa6d4f677f3e22cdd67ae0d291cb06f8d"
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
