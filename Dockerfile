FROM ubuntu:disco

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
        git \
        jq \
        wget \
        xz-utils

RUN wget "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.0/clang+llvm-15.0.0-x86_64-apple-darwin.tar.xz" -O clang.tar.xz && \
    tar xf clang.tar.xz && \
    cd clang* && \
    cp -R * /usr/local

COPY LICENSE README.md /

COPY .clang-format /.clang-format

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
