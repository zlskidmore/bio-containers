####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive
ARG BUILD_JOBS=4

# set the environment variables
ENV MINIMAP2_VERSION="2.31"

# Source archive checksum for the version above
ARG MINIMAP2_SHA256=c1351de6319c123369c2f4f37ba0ccf18c7ace47e2b1c0a35e30056b4a3bd9c9

####################################################################
############## MINIMAP2 Install ####################################

WORKDIR /tmp/build

RUN set -eux; \
    curl -fsSL "https://github.com/lh3/minimap2/releases/download/v${MINIMAP2_VERSION}/minimap2-${MINIMAP2_VERSION}.tar.bz2" -o minimap2.tar.bz2; \
    echo "${MINIMAP2_SHA256}  minimap2.tar.bz2" | sha256sum -c -; \
    tar -xjf minimap2.tar.bz2; \
    cd "minimap2-${MINIMAP2_VERSION}"; \
    # Use upstream CPU dispatch on AMD64 and native NEON on ARM64.
    case "$(dpkg --print-architecture)" in \
        amd64) make -j"${BUILD_JOBS}" ;; \
        arm64) make -j"${BUILD_JOBS}" arm_neon=1 aarch64=1 ;; \
        *) echo "Unsupported architecture" >&2; exit 1 ;; \
    esac; \
    install -m 0755 minimap2 /usr/local/bin/minimap2; \
    mkdir -p /opt/minimap2 /usr/local/share/man/man1; \
    cp LICENSE.txt README.md /opt/minimap2/; \
    install -m 0644 minimap2.1 /usr/local/share/man/man1/minimap2.1; \
    cd /; \
    rm -rf /tmp/build

####################################################################
############ Check Essentials ######################################
RUN test "$(minimap2 --version)" = "${MINIMAP2_VERSION}-r1302" && \
    minimap2 --help > /dev/null && samtools --version

WORKDIR /data

