####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV VATOOLS_VERSION="6.0.1" \
    PYENV_ROOT="/opt/pyenv" \
    PATH="/opt/pyenv/bin:/opt/pyenv/shims:/opt/venv/bin:$PATH" \
    BAM_READCOUNT_VERSION="1.0.1"

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## VATOOLS Install #####################################

WORKDIR /opt

# install
RUN set -eux; \
    python -m venv venv; \
    pip install --no-cache-dir "vatools==${VATOOLS_VERSION}"; \
    pip show vatools

RUN set -eux; \
    wget https://github.com/genome/bam-readcount/archive/refs/tags/v${BAM_READCOUNT_VERSION}.tar.gz; \
    tar -xzf v${BAM_READCOUNT_VERSION}.tar.gz; \
    cd bam-readcount-${BAM_READCOUNT_VERSION}; \
    mkdir build && cd build; \
    cmake ..; \
    make; \
    install -m 755 bin/bam-readcount /usr/local/bin/bam-readcount

####################################################################
############ readcount_helper Install ##############################

COPY requirements.txt /opt/requirements.txt

RUN pip install --no-cache-dir \
    -r /opt/requirements.txt \
    && rm requirements.txt

COPY bam_readcount_helper.py /usr/local/bin/bam_readcount_helper

RUN chmod 755 /usr/local/bin/bam_readcount_helper

WORKDIR /data
