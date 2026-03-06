####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV MOSDEPTH_VERSION=0.3.12 \
    D4_VERSION=0.3.10 \
    HTSLIB_VERSION=1.11 \
    NIM_VERSION=1.6.18 \
    PATH="/root/.cargo/bin:${PATH}"

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    bwa \
    cmake \
    libpcre3 \
    libpcre3-dev \
    openssl \
    && rm -rf /var/lib/apt/lists/*

#########################################################################
################# MOSDEPTH and related tooling ##########################

# install Rust toolchain via rustup
RUN set -eux; \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y --no-modify-path; \
    rustc --version; \
    cargo --version

# install Nim
RUN set -eux; \
    mkdir -p /tmp/build; \
    cd /tmp/build; \
    curl -fsSL -o "nim-${NIM_VERSION}.tar.xz" \
        "https://nim-lang.org/download/nim-${NIM_VERSION}.tar.xz"; \
    tar -xf "nim-${NIM_VERSION}.tar.xz"; \
    mv "nim-${NIM_VERSION}" /opt/nim; \
    cd /opt/nim; \
    sh build.sh; \
    bin/nim c koch; \
    ./koch nimble; \
    ln -sf /opt/nim/bin/nim /usr/local/bin/nim; \
    ln -sf /opt/nim/bin/nimble /usr/local/bin/nimble; \
    /usr/local/bin/nim --version; \
    /usr/local/bin/nimble --version; \
    rm -rf /tmp/build

# install D4
RUN set -eux; \
    mkdir -p /tmp/build; \
    cd /tmp/build; \
    wget -q "https://github.com/38/d4-format/archive/refs/tags/v${D4_VERSION}.tar.gz"; \
    tar -xzf "v${D4_VERSION}.tar.gz"; \
    cd "d4-format-${D4_VERSION}"; \ 
    cargo build --release; \
    install -m 0755 target/release/d4tools /usr/local/bin/d4tools; \
    rm -rf /tmp/build

# install mosdepth
RUN set -eux; \
    mkdir -p /tmp/build; \
    cd /tmp/build; \
    wget -q "https://github.com/brentp/mosdepth/archive/v${MOSDEPTH_VERSION}.tar.gz"; \
    tar -xzf "v${MOSDEPTH_VERSION}.tar.gz"; \
    cd "mosdepth-${MOSDEPTH_VERSION}"; \ 
    nimble refresh -y; \
    nimble build --mm:refc -d:release -y; \    
    install -m 0755 mosdepth /usr/local/bin/mosdepth; \
    rm -rf /tmp/build

WORKDIR /data
