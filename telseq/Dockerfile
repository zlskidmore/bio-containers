####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV TELSEQ_VERSION="0.0.2" \
    BAMTOOLS_VERSION="2.5.2"

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    libjsoncpp-dev \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## telseq Install ######################################

WORKDIR /tmp/build

# install bamtools dependency
RUN set -eux; \
    wget https://github.com/pezmaster31/bamtools/archive/refs/tags/v${BAMTOOLS_VERSION}.tar.gz; \
    tar -xzf v${BAMTOOLS_VERSION}.tar.gz; \
    mkdir -p bamtools-${BAMTOOLS_VERSION}/build; \
    cd bamtools-${BAMTOOLS_VERSION}/build; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..; \
    make; \
    make install; \
    rm -rf /tmp/build/bamtools-${BAMTOOLS_VERSION}; \
    rm -f /tmp/build/bamtools-${BAMTOOLS_VERSION}.tar.gz

# install telseq
RUN set -eux; \
    wget https://github.com/zd1/telseq/archive/refs/tags/v${TELSEQ_VERSION}.tar.gz; \
    tar -xzf v${TELSEQ_VERSION}.tar.gz; \
    cd telseq-${TELSEQ_VERSION}/src; \
    ./autogen.sh; \
    ./configure --with-bamtools=/usr/local ; \
    make; \
    cp Telseq/telseq /usr/local/bin; \
    rm -rf /tmp/build/v${TELSEQ_VERSION}; \
    rm -f telseq-${TELSEQ_VERSION}.tar.gz

WORKDIR /data
