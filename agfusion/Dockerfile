####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV AGFUSION_VERSION="1.5.0" \
    PATH="/opt/venv/bin:${PATH}" \
    MPLBACKEND="Agg" \
    PYENSEMBL_CACHE_DIR="/data/pyensembl"

# Source archive checksum for the version above
ARG AGFUSION_SHA256=8bed9d92c9c727567c26a1f34a0d33ff80f44c2c8b33145feab21a96ad8c06b4

####################################################################
############## AGFusion Install ####################################

WORKDIR /tmp/build

# set venv
RUN python -m venv /opt/venv && \
    python -m pip install --no-cache-dir --upgrade pip wheel && \
    python -m pip install --no-cache-dir setuptools==81.0.0

RUN set -eux; \
    curl -fsSL "https://github.com/murphycj/AGFusion/archive/refs/tags/v${AGFUSION_VERSION}.tar.gz" -o agfusion.tar.gz; \
    echo "${AGFUSION_SHA256}  agfusion.tar.gz" | sha256sum -c -; \
    tar -xzf agfusion.tar.gz; \
    cd "AGFusion-${AGFUSION_VERSION}"; \
    # Use upstream's tested dependency constraints, including pandas 2.2.3.
    python -m pip install --no-cache-dir -r requirements.txt .; \
    mkdir -p /opt/agfusion; \
    cp LICENSE.txt README.md /opt/agfusion/; \
    cp -r test /opt/agfusion/; \
    cd /; \
    rm -rf /tmp/build

####################################################################
############ Check Essentials ######################################
RUN python -m pip check && \
    python -c 'import importlib.metadata as m; assert m.version("agfusion") == "1.5.0"' && \
    agfusion --help > /dev/null && \
    agfusion annotate --help > /dev/null && \
    agfusion batch --help > /dev/null && \
    pyensembl --help > /dev/null

WORKDIR /data

