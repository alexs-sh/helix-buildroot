FROM debian:12

# APT
RUN apt update -y && apt install -y gcc g++ make git zip curl wget sed binutils build-essential \
  patch gzip bzip2 perl tar cpio unzip rsync file bc findutils genimage mtools dosfstools

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o install-rust.sh && \
  chmod +x install-rust.sh && \
  ./install-rust.sh -y
