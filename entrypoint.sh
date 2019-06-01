#!/bin/sh
set -e

cd $BUILD_DIR


if [ -d "/github/home" ] then;
    ln -s /root/.rustup /github/home/.rustup
    ln -s /root/.cargo /github/home/.cargo
fi

exec "$@"
