class Accountant24 < Formula
  desc "Your personal AI accountant — plain-text bookkeeping with any LLM"
  homepage "https://github.com/machulav/accountant24"
  version "0.1.2"
  license "MIT"

  # Auto-installed when the user runs `brew install machulav/tap/accountant24`.
  # This is the whole point of having a brew formula: no separate prereq step.
  depends_on "hledger"

  on_macos do
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.2/accountant24-darwin-arm64.tar.gz"
      sha256 "20a01d320ae59dd60baea3bb78da5ee1771c397a6290ad20fbdb36a73a759113"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.2/accountant24-darwin-x64.tar.gz"
      sha256 "891d74c3323f7d282c44ff48d15167d57b2149ae9d069d8a5bc6cffe5a39d3c8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.2/accountant24-linux-x64.tar.gz"
      sha256 "3fecfd368361b39946731e24b52d1732aed6c0e942fd8c768b9dea24f70d9b58"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.2/accountant24-linux-arm64.tar.gz"
      sha256 "c379f839f5392f2588be39592d0daa7bd7d12c3df84d7e7866a8b2c0106630bc"
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
