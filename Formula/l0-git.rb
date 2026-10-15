# Homebrew formula for l0-git: deterministic project-hygiene gates.
#
# Installs the pre-built release binary as `lgit`. On macOS the binary is
# signed with a Developer ID and notarized. The url and sha256 lines are
# bumped by the l0-git release workflow on every stable tag: do not edit them
# by hand.
class L0Git < Formula
  desc "Deterministic project-hygiene gates for the shell, the editor and MCP"
  homepage "https://fabriziosalmi.github.io/l0-git/"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fabriziosalmi/l0-git/releases/download/v0.3.3/lgit-darwin-arm64.tar.gz"
      sha256 "75e11f8929e8280b9bf469fae1162c62480e0071c4103e5be34ab5e10dcd4d02"
    end
    on_intel do
      url "https://github.com/fabriziosalmi/l0-git/releases/download/v0.3.3/lgit-darwin-amd64.tar.gz"
      sha256 "bf30ca04e5e3385a0729339e4813a8b7a68e94eee7f67e5c526bedb02d80be75"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fabriziosalmi/l0-git/releases/download/v0.3.3/lgit-linux-arm64.tar.gz"
      sha256 "5fb6d96f99c4791d552c334c282c294bec072b7896e1c422e754a51af32949e4"
    end
    on_intel do
      url "https://github.com/fabriziosalmi/l0-git/releases/download/v0.3.3/lgit-linux-amd64.tar.gz"
      sha256 "c4274b112bbe2669ce14cf858e476dd15f6c3ac51c3099d6a96470904340a813"
    end
  end

  def install
    # Each archive holds a single file named after its target, e.g.
    # lgit-darwin-arm64.
    bin.install Dir["lgit-*"].first => "lgit"
  end

  def caveats
    <<~EOS
      To use l0-git from Claude Code over MCP:
        claude mcp add -s user l0-git #{opt_bin}/lgit mcp
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lgit version").strip
    # A real run: the gates execute against an empty repository and persist
    # into a store under the test HOME.
    system "git", "init", "-q", testpath/"repo"
    out = shell_output("#{bin}/lgit check #{testpath}/repo")
    assert_match "readme_present", out
  end
end
