FROM debian:12

# APT
RUN apt update -y && apt install -y python3 python3-magic python3-flake8
