####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV CNVKIT_VERSION="0.9.14" \
    PATH="/opt/venv/bin:${PATH}" \
    MPLBACKEND="Agg"

# Source archive checksum for the version above
ARG CNVKIT_SHA256=800cbdf0250e06f5e295f6d71be1707a550a18547b7d442e1df80252dce13e53

# R and DNAcopy are needed for default CBS segmentation.
RUN apt-get update && apt-get install -y --no-install-recommends \
    r-base-core \
    r-bioc-dnacopy \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## CNVKIT Install ######################################

WORKDIR /tmp/build

# set venv
RUN python -m venv /opt/venv && \
    python -m pip install --no-cache-dir --upgrade pip setuptools wheel

RUN set -eux; \
    curl -fsSL "https://github.com/etal/cnvkit/archive/refs/tags/v${CNVKIT_VERSION}.tar.gz" -o cnvkit.tar.gz; \
    echo "${CNVKIT_SHA256}  cnvkit.tar.gz" | sha256sum -c -; \
    tar -xzf cnvkit.tar.gz; \
    cd "cnvkit-${CNVKIT_VERSION}"; \
    python -m pip install --no-cache-dir .; \
    mkdir -p /opt/cnvkit; \
    cp LICENSE README.rst /opt/cnvkit/; \
    cd /; \
    rm -rf /tmp/build

####################################################################
############ Check Essentials ######################################
RUN python -m pip check && \
    test "$(cnvkit.py version)" = "${CNVKIT_VERSION}" && \
    cnvkit.py --help > /dev/null && \
    Rscript -e 'stopifnot(requireNamespace("DNAcopy", quietly = TRUE))'

WORKDIR /data

