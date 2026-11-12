class LordOfTheClaudes < Formula
  desc "Menu bar app that tracks Claude Code sessions in Ghostty and reopens them"
  homepage "https://github.com/Jonesybaker/lord-of-the-claudes"
  url "https://github.com/Jonesybaker/lord-of-the-claudes/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "6945d51e9f7f6f45cbb8040f990e2cd38ab1d380e039adc69b33e1f2d6f6d90f"
  license "MIT"

  depends_on macos: :sonoma

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    app = prefix/"Lord of the Claudes.app"
    (app/"Contents/MacOS").install ".build/release/LordOfTheClaudes"
    bin.install ".build/release/lotc"
    (app/"Contents").install "Info.plist"
    system "codesign", "--force", "--sign", "-", app
    (bin/"lord-of-the-claudes").write <<~SH
      #!/bin/bash
      exec open "#{opt_prefix}/Lord of the Claudes.app"
    SH
  end

  def caveats
    <<~EOS
      Start it with:
        lord-of-the-claudes
      On first run macOS asks to let it control Ghostty. Allow it.
      It then starts by itself at login.
      To answer permission prompts in its window:
        lotc hooks install
    EOS
  end

  test do
    assert_path_exists prefix/"Lord of the Claudes.app/Contents/MacOS/LordOfTheClaudes"
  end
end
