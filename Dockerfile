FROM debian:stretch-slim

RUN apt update && apt -y install \
    make \
    git \
    curl \
    clang \
    gcc \
    g++ \
    zlib1g-dev \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev

RUN curl -sf -L https://static.rust-lang.org/rustup.sh | sh -s -- -y
RUN echo "PATH="source $HOME/.cargo/env"" >> ~/.bashrc
ENV PATH /root/.cargo/bin:$PATH
RUN echo $PATH
RUN rustup target add x86_64-apple-darwin

RUN git clone https://github.com/tpoechtrager/osxcross
WORKDIR osxcross
RUN curl -O https://s3.dockerproject.org/darwin/v2/MacOSX10.10.sdk.tar.xz
RUN mv MacOSX10.10.sdk.tar.xz tarballs/
RUN UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh
ENV PATH /osxcross/target/bin:$PATH

RUN mkdir /build
WORKDIR /build
VOLUME /build
CMD ["cargo", "build", "--target", "x86_64-apple-darwin", "--release"]
