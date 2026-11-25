class Auditstream < Formula
  desc "CLI binary for the Auditstream database audit trail engine"
  homepage "https://auditstream.dev"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/auditstream/auditstream/releases/download/auditstream-v0.1.0/auditstream-aarch64-apple-darwin.tar.xz"
      sha256 "36289edd4ddf9bb4d1cb9bc19dc7ed0773e0d71d15ad1ea8b0ed2e13fec4b321"
    end
    if Hardware::CPU.intel?
      url "https://github.com/auditstream/auditstream/releases/download/auditstream-v0.1.0/auditstream-x86_64-apple-darwin.tar.xz"
      sha256 "f7c431c46bc3ad883a6dcd1ff8674b963cdee6e24870095abcbb83f8bef1d99a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/auditstream/auditstream/releases/download/auditstream-v0.1.0/auditstream-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e2f9ea7abc076ce545a0eeca43221bc5f53bf26ba7fce090f0e6135502d9bb0f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/auditstream/auditstream/releases/download/auditstream-v0.1.0/auditstream-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a1af93efcacc95818ede82c1a866982038fa5b3ea488f68a974d0e9cbb007a6"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "auditstream"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "auditstream"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "auditstream"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "auditstream"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
