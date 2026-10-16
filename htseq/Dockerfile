####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV HTSEQ_VERSION="2.1.2" \
    PATH="/opt/venv/bin:$PATH" \
    MPLBACKEND="Agg"

# Additional packages for source builds (e.g. on linux/arm64)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-dev \
    swig \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## HTSEQ Install #######################################
WORKDIR /app

# set venv
RUN python -m venv /opt/venv && \
    python -m pip install --no-cache-dir --upgrade pip setuptools wheel

# install the pinned release, including matplotlib for htseq-qa
RUN python -m pip install --no-cache-dir "HTSeq[htseq-qa]==${HTSEQ_VERSION}"

####################################################################
############ Check Essentials ######################################
RUN python -m pip check && \
    python -c "import HTSeq, os; assert HTSeq.__version__ == os.environ['HTSEQ_VERSION']" && \
    htseq-count --help > /dev/null && \
    htseq-count-barcodes --help > /dev/null && \
    htseq-qa --help > /dev/null

WORKDIR /data
