##################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV KRAKEN_VERSION="2.17.1" \
    BRACKEN_VERSION="3.1" \
    KRAKEN_TOOLS_VERSION="1.2.1"

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-biopython \
    perl \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## KRAKEN2 Install #####################################

WORKDIR /tmp/build

# KRAKEN2
RUN set -eux; \
    wget https://github.com/DerrickWood/kraken2/archive/refs/tags/v${KRAKEN_VERSION}.tar.gz; \
    tar -xzf v${KRAKEN_VERSION}.tar.gz; \
    cd kraken2-${KRAKEN_VERSION}; \
    ./install_kraken2.sh /usr/local/bin; \
    chmod +x /usr/local/bin/kraken2 /usr/local/bin/kraken2-build /usr/local/bin/kraken2-inspect; \
    rm -rf kraken2-${KRAKEN_VERSION} v${KRAKEN_VERSION}.tar.gz

# BRACKEN
RUN set -eux; \
    wget https://github.com/jenniferlu717/Bracken/archive/refs/tags/v${BRACKEN_VERSION}.tar.gz; \
    tar -xzf v${BRACKEN_VERSION}.tar.gz; \
    make -C Bracken-${BRACKEN_VERSION}/src; \
    cp Bracken-${BRACKEN_VERSION}/analysis_scripts/combine_bracken_outputs.py \
       Bracken-${BRACKEN_VERSION}/bracken \
       Bracken-${BRACKEN_VERSION}/bracken-build \
       Bracken-${BRACKEN_VERSION}/src/kmer2read_distr \
       Bracken-${BRACKEN_VERSION}/src/generate_kmer_distribution.py \
       Bracken-${BRACKEN_VERSION}/src/est_abundance.py \
       /usr/local/bin/; \
    chmod +x /usr/local/bin/bracken /usr/local/bin/bracken-build /usr/local/bin/kmer2read_distr /usr/local/bin/*.py; \
    rm -rf Bracken-${BRACKEN_VERSION} v${BRACKEN_VERSION}.tar.gz

# KRAKENTOOLS
RUN set -eux; \
    wget https://github.com/jenniferlu717/KrakenTools/archive/refs/tags/v${KRAKEN_TOOLS_VERSION}.tar.gz; \
    tar -xzf v${KRAKEN_TOOLS_VERSION}.tar.gz; \
    find KrakenTools-${KRAKEN_TOOLS_VERSION} -type f -name '*.py' -exec cp {} /usr/local/bin/ \; ; \
    chmod +x /usr/local/bin/*.py; \
    rm -rf KrakenTools-${KRAKEN_TOOLS_VERSION} v${KRAKEN_TOOLS_VERSION}.tar.gz

WORKDIR /data
