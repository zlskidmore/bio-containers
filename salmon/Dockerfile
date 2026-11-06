####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV SALMON_VERSION="2.11.0"

# Official Linux release archive checksums for the version above
ARG SALMON_AMD64_SHA256=e15b1ef0c4bece9c2ce271e2acbafb6ac1dc22b4b038fe8380f849455b9d8527
ARG SALMON_ARM64_SHA256=7d87e73701e3310a09fe3cfa5e2d8e72dea6b6dcf2a0f9bc800b868d8d8995dc

# Additional tools needed to extract the release archive
RUN apt-get update && apt-get install -y --no-install-recommends \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## SALMON Install ######################################

WORKDIR /tmp/build

RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
        amd64) salmon_target="x86_64-unknown-linux-gnu"; salmon_sha256="${SALMON_AMD64_SHA256}" ;; \
        arm64) salmon_target="aarch64-unknown-linux-gnu"; salmon_sha256="${SALMON_ARM64_SHA256}" ;; \
        *) echo "Unsupported architecture" >&2; exit 1 ;; \
    esac; \
    curl -fsSL "https://github.com/COMBINE-lab/salmon/releases/download/v${SALMON_VERSION}/salmon-cli-${salmon_target}.tar.xz" -o salmon.tar.xz; \
    echo "${salmon_sha256}  salmon.tar.xz" | sha256sum -c -; \
    tar -xJf salmon.tar.xz; \
    cd "salmon-cli-${salmon_target}"; \
    install -m 0755 salmon /usr/local/bin/salmon; \
    mkdir -p /opt/salmon; \
    cp LICENSE README.md /opt/salmon/; \
    cd /; \
    rm -rf /tmp/build

####################################################################
############ Check Essentials ######################################
RUN test "$(salmon --version)" = "salmon ${SALMON_VERSION}" && \
    salmon index --help > /dev/null && salmon quant --help > /dev/null

WORKDIR /data

