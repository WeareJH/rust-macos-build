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
ENV PATH /root/.cargo/bin:$PATH
RUN rustup target add x86_64-apple-darwin 

RUN git clone https://github.com/tpoechtrager/osxcross && \
    cd osxcross && \
    git reset --hard 9498bfdc621716959e575bd6779c853a03cf5f8d

WORKDIR osxcross

RUN curl -O https://s3.dockerproject.org/darwin/v2/MacOSX10.10.sdk.tar.xz && \
    mv MacOSX10.10.sdk.tar.xz tarballs/ && \
    UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh

ENV PATH /osxcross/target/bin:$PATH

COPY config /root/.cargo/config

COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENV BUILD_DIR /build

RUN mkdir /build
WORKDIR /build
VOLUME /build
ENTRYPOINT ["entrypoint"]
CMD ["cargo", "build", "--target", "x86_64-apple-darwin", "--release"]
