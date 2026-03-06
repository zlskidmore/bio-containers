####################################################################
############ Standard Setup ########################################
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

ENV samtools_version=1.23
ENV bcftools_version=1.23
ENV htslib_version=1.23
ENV bedtools_version=2.31.1

# Base packages (build + runtime utils)
RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    bzip2 \
    ca-certificates \
    curl \
    gawk \
    git \
    htop \
    jq \
    less \
    libbz2-dev \
    libcurl4-openssl-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    lz4 \
    nano \
    parallel \
    pkg-config \
    pigz \
    procps \
    python-is-python3 \
    python3 \
    python3-pip \
    python3-venv \
    ripgrep \
    rsync \
    tar \
    time \
    tree \
    tzdata \
    unzip \
    vim \
    wget \
    zlib1g-dev \
    zstd \
 && rm -rf /var/lib/apt/lists/*

#################################################################
############# Samtools Suite ####################################
RUN set -eux; \
    mkdir -p /tmp/build && cd /tmp/build; \
    wget -q https://github.com/samtools/htslib/releases/download/${htslib_version}/htslib-${htslib_version}.tar.bz2; \
    wget -q https://github.com/samtools/samtools/releases/download/${samtools_version}/samtools-${samtools_version}.tar.bz2; \
    wget -q https://github.com/samtools/bcftools/releases/download/${bcftools_version}/bcftools-${bcftools_version}.tar.bz2; \
    tar -xjf htslib-${htslib_version}.tar.bz2; \
    tar -xjf samtools-${samtools_version}.tar.bz2; \
    tar -xjf bcftools-${bcftools_version}.tar.bz2; \
    cd /tmp/build/htslib-${htslib_version}; \
    ./configure; make -j"$(nproc)"; make install; ldconfig; \
    cd /tmp/build/samtools-${samtools_version}; \
    ./configure; make -j"$(nproc)"; make install; \
    cd /tmp/build/bcftools-${bcftools_version}; \
    make -j"$(nproc)"; make install; \
    rm -rf /tmp/build

###################################################################
############## Bedtools ###########################################
RUN set -eux; \
    mkdir -p /tmp/build && cd /tmp/build; \
    curl -fsSL https://github.com/arq5x/bedtools2/archive/v${bedtools_version}.tar.gz -o bedtools2-v${bedtools_version}.tar.gz; \
    tar -xzf bedtools2-v${bedtools_version}.tar.gz; \
    cd bedtools2-${bedtools_version}; \
    make -j"$(nproc)"; \
    install -m 0755 bin/bedtools /usr/local/bin/bedtools; \
    rm -rf /tmp/build

####################################################################
############ Check Essentials ######################################
RUN samtools --version && bcftools --version && bedtools --version

####################################################################
############## run default #########################################
CMD ["/bin/bash"]
