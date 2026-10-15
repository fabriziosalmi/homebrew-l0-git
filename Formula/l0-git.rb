# Homebrew formula for l0-git: deterministic project-hygiene gates.
#
# Installs the pre-built release binary as `lgit`. On macOS the binary is
# signed with a Developer ID and notarized. The version and sha256 lines are
# bumped by the l0-git release workflow on every stable tag: do not edit them
# by hand.
class L0Git < Formula
  desc "Deterministic project-hygiene gates for the shell, the editor and MCP"
  homepage "https://fabriziosalmi.github.io/l0-git/"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/fabriziosalmi/l0-git/releases/download/v0.3.2/lgit-darwin-arm64.tar.gz"
      sha256 "1f46abfc5ae2d6dbc808670474e66c0b00cf45ba9a281505ffc10aee7c309e0a"
    end
    on_intel do
      url "https://github.com/fabriziosalmi/l0-git/releases/download/v0.3.2/lgit-darwin-amd64.tar.gz"
      sha256 "7d78cec73dfa51e920692ca9efb1155db6a3a1ff4612bb9aea7f61bf507838dd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fabriziosalmi/l0-git/releases/download/v0.3.2/lgit-linux-arm64.tar.gz"
      sha256 "ae4cec480367485abb3442edd952ad334b8c9851b3232c54f4d1a4a915fab1b9"
    end
    on_intel do
      url "https://github.com/fabriziosalmi/l0-git/releases/download/v0.3.2/lgit-linux-amd64.tar.gz"
      sha256 "b1914866f1ac41418feb8f4ccee219a5856ab0764a69e8e2eea220b978fb1751"
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
