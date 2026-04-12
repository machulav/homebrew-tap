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
      sha256 "2a3c73d762e6b1442aa48278c9b331cd2812df4ddc65373540a407bd1dc18c40"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.2.0/accountant24-darwin-x64.tar.gz"
      sha256 "f249a67c02a5accf14b8a39181b9e97ae9fd4e292b9fef4c740354e57d055288"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.2.0/accountant24-linux-x64.tar.gz"
      sha256 "b28f855711c7227146cac3958feafeef3825047ac55b81ed2b848afbcf9fff1d"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.2.0/accountant24-linux-arm64.tar.gz"
      sha256 "755187da498b2dfbed74cb87a1ccd293712ba3efd83614012eec9e09b8dad1ff"
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
