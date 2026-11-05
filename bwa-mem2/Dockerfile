####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive
ARG BUILD_JOBS=4

# set the environment variables
ENV BWA_MEM2_VERSION="2.3"

# Complete upstream source release, including required submodules
ARG BWA_MEM2_SHA256=0c48a1ea800af499ae7264b4c8908c4ca35fbe5a7df2ad6106c79aa94bb49cbb
ARG BWA_MEM2_COMMIT=7aa5ff6c3330490e5629ab9b7327683d2dce02d6

####################################################################
############## BWA-MEM2 Install ####################################

WORKDIR /tmp/build

RUN set -eux; \
    # Upstream's SIMD build targets Linux AMD64, not native ARM64.
    test "$(dpkg --print-architecture)" = "amd64"; \
    curl -fsSL "https://github.com/bwa-mem2/bwa-mem2/releases/download/v${BWA_MEM2_VERSION}/Source_code_including_submodules.tar.gz" -o bwa-mem2.tar.gz; \
    echo "${BWA_MEM2_SHA256}  bwa-mem2.tar.gz" | sha256sum -c -; \
    tar -xzf bwa-mem2.tar.gz; \
    cd "bwa-mem2-${BWA_MEM2_VERSION}"; \
    test "$(git rev-parse HEAD)" = "${BWA_MEM2_COMMIT}"; \
    # The 2.3 source still labels itself 2.2.1; fix only version metadata.
    grep -Fx '#define PACKAGE_VERSION "2.2.1"' src/main.cpp; \
    sed -i "s/#define PACKAGE_VERSION .*/#define PACKAGE_VERSION \"${BWA_MEM2_VERSION}\"/" src/main.cpp; \
    make -j"${BUILD_JOBS}" CXX=g++ multi; \
    # Keep the dispatcher and all CPU-specific executables together.
    install -m 0755 bwa-mem2 bwa-mem2.* /usr/local/bin/; \
    mkdir -p /opt/bwa-mem2; \
    cp LICENSE README.md NEWS.md /opt/bwa-mem2/; \
    git rev-parse HEAD > /opt/bwa-mem2/SOURCE_COMMIT; \
    cd /; \
    rm -rf /tmp/build

####################################################################
############ Check Essentials ######################################
RUN test "$(bwa-mem2 version)" = "${BWA_MEM2_VERSION}" && samtools --version

WORKDIR /data

