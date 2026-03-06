####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV KALLISTO_VERSION="0.52.0"

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    libhdf5-dev \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## Kallisto Install ####################################

WORKDIR /tmp/build

RUN set -eux; \
    mkdir -p /tmp/build; \
    cd /tmp/build; \
    curl -fsSL "https://github.com/pachterlab/kallisto/archive/v${KALLISTO_VERSION}.tar.gz" -o kallisto.tar.gz; \
    tar -xzf kallisto.tar.gz; \
    ls -la; \
    ls -la "kallisto-${KALLISTO_VERSION}"; \
    ls -la "kallisto-${KALLISTO_VERSION}/ext"; \
    cd "kallisto-${KALLISTO_VERSION}/ext/htslib"; \
    autoheader; \
    autoconf; \
    cd "/tmp/build/kallisto-${KALLISTO_VERSION}"; \
    mkdir -p build; \
    cd build; \
    cmake ..; \
    make; \
    make install; \
    rm -rf /tmp/build

WORKDIR /data
