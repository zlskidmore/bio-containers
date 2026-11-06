####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV OPTITYPE_VERSION="1.5.0" \
    PATH="/opt/venv/bin:${PATH}" \
    MPLBACKEND="Agg"

# Source archive checksum for the version above
ARG OPTITYPE_SHA256=a59e917db1f57721fc65baad703e04e76cbe293c4fe2936d4d5dae720db31da8

# Native RazerS3 mapper and open-source ILP solvers.
RUN apt-get update && apt-get install -y --no-install-recommends \
    seqan-apps \
    glpk-utils \
    coinor-cbc \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## OptiType Install ####################################

WORKDIR /tmp/build

# set venv
RUN python -m venv /opt/venv && \
    python -m pip install --no-cache-dir --upgrade pip setuptools wheel

RUN set -eux; \
    curl -fsSL "https://github.com/FRED-2/OptiType/archive/refs/tags/v${OPTITYPE_VERSION}.tar.gz" -o optitype.tar.gz; \
    echo "${OPTITYPE_SHA256}  optitype.tar.gz" | sha256sum -c -; \
    tar -xzf optitype.tar.gz; \
    cd "OptiType-${OPTITYPE_VERSION}"; \
    python -m pip install --no-cache-dir .; \
    mkdir -p /opt/optitype; \
    cp LICENSE README.md /opt/optitype/; \
    cp -r test /opt/optitype/; \
    cd /; \
    rm -rf /tmp/build

####################################################################
############ Check Essentials ######################################
RUN python -m pip check && \
    test "$(optitype --version)" = "optitype, version ${OPTITYPE_VERSION}" && \
    optitype check-deps && \
    optitype run --help > /dev/null && \
    razers3 --version

WORKDIR /data

