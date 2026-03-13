####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV VERIFYBAMID_VERSION="2.0.1"
ENV FGBIO="/usr/local/bin/fgbio.jar"

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    libhts-dev \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############### get FGBIO ##########################################

RUN set -eux; \
    mkdir -p /tmp/; \
    cd /tmp/; \
    wget -q -O verifybamid.tar.gz "https://github.com/Griffan/VerifyBamID/archive/refs/tags/${VERIFYBAMID_VERSION}.tar.gz"; \
    tar -xzf verifybamid.tar.gz; \
    cd VerifyBamID-${VERIFYBAMID_VERSION}; \
    mkdir -p build; \
    cd build; \
    cmake ..; \
    make; \
    make test; \
    mv ../bin/* /usr/local/bin; \
    rm -rf /tmp/verifybamid.tar.gz /tmp/VerifyBamID-${VERIFYBAMID_VERSION}

WORKDIR /data
