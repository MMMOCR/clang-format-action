FROM ubuntu:disco

FROM ubuntu:18.04

RUN echo "nameserver 9.9.9.9" > /etc/resolv.conf && apt-get update && apt-get install -y \
        git \
        jq \
        wget \
        xz-utils \
        file

RUN echo "nameserver 9.9.9.9" > /etc/resolv.conf && wget "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/clang+llvm-14.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz" -O clang.tar.xz && \
    tar xf clang.tar.xz && \
    cd clang* && \
    cp -R * /usr/local

RUN git config --global safe.directory '*'

COPY LICENSE README.md /

COPY .clang-format /.clang-format

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
