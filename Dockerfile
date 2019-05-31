# This Docker image is be used to compile the
# Rust app for the Lambda target environment.

# just about any distro should work
FROM ubuntu:18.04

# musl-tools provides musl-gcc, which lets us
# compile for the musl target environment.
RUN apt-get update && \
    apt-get install -y curl build-essential musl-tools

# no need to use root
RUN useradd -ms /bin/bash app
USER app

# install the latest Rust installation from official releases;
# this is version 1.35 at the time of writing.
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    echo "export PATH=~/.cargo/bin:$PATH" >> ~/.bashrc

# install the Rust std libs for the musl target environment
RUN ~/.cargo/bin/rustup target install x86_64-unknown-linux-musl

# include the build script in the image; we'll run this
# as the container entrypoint when we compile
COPY rustbuild.sh /rustbuild.sh
ENTRYPOINT /rustbuild.sh

# the rest of the Rust source is shared via a volume
# so we don't have to rebuild the image when it changes
VOLUME /mnt/app
WORKDIR /mnt/app

