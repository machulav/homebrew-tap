class Accountant24 < Formula
  desc "Your personal AI accountant — plain-text bookkeeping with any LLM"
  homepage "https://github.com/machulav/accountant24"
  version "0.1.9"
  license "MIT"

  # Auto-installed when the user runs `brew install machulav/tap/accountant24`.
  # This is the whole point of having a brew formula: no separate prereq step.
  depends_on "hledger"
  depends_on "poppler"
  depends_on "tesseract"

  on_macos do
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.9/accountant24-darwin-arm64.tar.gz"
      sha256 "5d7e893d84eabe71f2324e58dd25245362e5613a1d171b98476c207a774cf899"
    end
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.9/accountant24-darwin-x64.tar.gz"
      sha256 "8f9d2073a1754706afa0f0908dab00574f48e2ef9b6bcf312c1f8f1718d883cc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.9/accountant24-linux-x64.tar.gz"
      sha256 "e29315dd09b1db14b7c51330714d07a3ca43cfc7e524092d0e7c7a5f47d777d7"
    end
    on_arm do
      url "https://github.com/machulav/accountant24/releases/download/v0.1.9/accountant24-linux-arm64.tar.gz"
      sha256 "fc452ac5a2b2a073e3945c35c54b1593d42e5f48442b4c06cb0c953e41f6b095"
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
