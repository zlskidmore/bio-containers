####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV BBTOOLS_VERSION=39.84
ENV BBTOOLS_HOME=/opt/bbtools
ENV PATH="${BBTOOLS_HOME}/BBTools-${BBTOOLS_VERSION}:${PATH}"

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jre \
    && rm -rf /var/lib/apt/lists/*

####################################################################
########### setup bbtools ##########################################


# bbtools
WORKDIR ${BBTOOLS_HOME}
RUN set -eux; \
    wget "https://github.com/bbushnell/BBTools/archive/refs/tags/v${BBTOOLS_VERSION}.tar.gz"; \
    tar -xzvf v${BBTOOLS_VERSION}.tar.gz; \
    rm -f v39.84.tar.gz

# additional files
WORKDIR /data
RUN set -eux; \
    wget "https://github.com/bbushnell/BBTools/releases/download/v39.84/refseqA48_with_ribo.spectra.gz"; \
    gunzip refseqA48_with_ribo.spectra.gz

