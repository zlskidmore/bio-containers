####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV DELLY_VERSION="2.8.1"

# Official Linux release binary checksums for the version above
ARG DELLY_AMD64_SHA256=f3e309486a28393b78d4d2f8b63ce2c4d778d1e4e80a3f8d53dc4c2673e38a5c
ARG DELLY_ARM64_SHA256=04d7f0442fa217afc6a65bd654395da0a809ca462e8f282d5121df57c76efc78
ARG DELLY_SOURCE_SHA256=09cfe5e6678ddd9da8b21667c0a593ad3c4dcac55bccfb04d068cebfc252f425

####################################################################
############## DELLY Install #######################################

WORKDIR /tmp/build

RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
        amd64) delly_arch="amd64"; delly_sha256="${DELLY_AMD64_SHA256}" ;; \
        arm64) delly_arch="arm64"; delly_sha256="${DELLY_ARM64_SHA256}" ;; \
        *) echo "Unsupported architecture" >&2; exit 1 ;; \
    esac; \
    curl -fsSL "https://github.com/dellytools/delly/releases/download/v${DELLY_VERSION}/delly-v${DELLY_VERSION}-linux-${delly_arch}" -o delly; \
    echo "${delly_sha256}  delly" | sha256sum -c -; \
    install -m 0755 delly /usr/local/bin/delly; \
    curl -fsSL "https://github.com/dellytools/delly/archive/refs/tags/v${DELLY_VERSION}.tar.gz" -o delly-source.tar.gz; \
    echo "${DELLY_SOURCE_SHA256}  delly-source.tar.gz" | sha256sum -c -; \
    tar -xzf delly-source.tar.gz; \
    cd "delly-${DELLY_VERSION}"; \
    mkdir -p /opt/delly; \
    cp LICENSE README.md /opt/delly/; \
    # Retain the small upstream example data for functional checks.
    cp -r example /opt/delly/; \
    cd /; \
    rm -rf /tmp/build

####################################################################
############ Check Essentials ######################################
RUN test "$(delly --version 2>&1 | head -n 1)" = "Delly version: v${DELLY_VERSION}" && \
    delly sr --help > /dev/null 2>&1 && \
    delly lr --help > /dev/null 2>&1 && bcftools --version

WORKDIR /data

