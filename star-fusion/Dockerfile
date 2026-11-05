####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive
ARG BUILD_JOBS=4

# set the environment variables
ENV STAR_VERSION="2.7.11b"

# Source archive checksum for the version above
ARG STAR_SHA256=3f65305e4112bd154c7e22b333dcdaafc681f4a895048fa30fa7ae56cac408e7

# Additional libs needed (build tools and zlib are in bio-base)
RUN apt-get update && apt-get install -y --no-install-recommends \
    xxd \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## STAR Install ########################################

WORKDIR /tmp/build

RUN set -eux; \
    curl -fsSL "https://github.com/alexdobin/STAR/archive/refs/tags/${STAR_VERSION}.tar.gz" -o star.tar.gz; \
    echo "${STAR_SHA256}  star.tar.gz" | sha256sum -c -; \
    tar -xzf star.tar.gz; \
    cd "STAR-${STAR_VERSION}/source"; \
    # Use portable SSE2 on AMD64 and bundled SIMDe on ARM64.
    case "$(dpkg --print-architecture)" in \
        amd64) simd_flags="-msse2" ;; \
        arm64) simd_flags="" ;; \
        *) echo "Unsupported architecture" >&2; exit 1 ;; \
    esac; \
    make -j"${BUILD_JOBS}" STAR CXXFLAGS_SIMD="${simd_flags}"; \
    install -m 0755 STAR /usr/local/bin/STAR; \
    mkdir -p /opt/STAR; \
    cp ../LICENSE /opt/STAR/; \
    cd /; \
    rm -rf /tmp/build

####################################################################
############ Check Essentials ######################################
RUN test "$(STAR --version)" = "${STAR_VERSION}" && STAR --help > /dev/null

####################################################################
############## STAR-Fusion Install #################################

# set the environment variables
ENV STAR_FUSION_VERSION="1.15.1" \
    STAR_FUSION_HOME="/opt/STAR-Fusion" \
    PATH="/opt/STAR-Fusion:${PATH}"

# FULL release includes the required FusionAnnotator and FusionFilter submodules.
ARG STAR_FUSION_SHA256=3c688c5ca446a3a3171d4f920d7a36fb360d7e49c35425468a3b5feaac0d6187

# Additional Perl dependencies for the standard fusion-calling workflow
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcarp-assert-perl \
    libdb-dev \
    libjson-xs-perl \
    libperl-dev \
    libperlio-gzip-perl \
    liburi-perl \
    perl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/build

RUN set -eux; \
    curl -fsSL "https://github.com/STAR-Fusion/STAR-Fusion/releases/download/STAR-Fusion-v${STAR_FUSION_VERSION}/STAR-Fusion-v${STAR_FUSION_VERSION}.FULL.tar.gz" -o star-fusion.tar.gz; \
    echo "${STAR_FUSION_SHA256}  star-fusion.tar.gz" | sha256sum -c -; \
    tar -xzf star-fusion.tar.gz; \
    mv "STAR-Fusion-v${STAR_FUSION_VERSION}" "${STAR_FUSION_HOME}"; \
    cd "${STAR_FUSION_HOME}"; \
    # Build the native Set::IntervalTree plugin for the target architecture.
    # FusionInspector and CTAT reference-building dependencies are optional.
    make plugins_only; \
    cd /; \
    rm -rf /tmp/build

####################################################################
############ Check Essentials ######################################
RUN STAR-Fusion --version && \
    STAR-Fusion --help > /dev/null 2>&1 && \
    perl -I/opt/STAR-Fusion/PerlLib -MSet::IntervalTree -MJSON::XS \
        -MDB_File -MURI::Escape -MCarp::Assert -MPerlIO::gzip -e 1 && \
    samtools --version

WORKDIR /data

