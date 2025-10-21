# work from latest LTS ubuntu release
FROM ubuntu:24.04

# set the environment variables
ENV kallisto_version=0.51.1

# run update and install necessary tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    cmake \
    zlib1g-dev \
    libhdf5-dev \
    libnss-sss \
    curl \
    autoconf \
    vim \
    less \
    wget

# install kallisto
WORKDIR /usr/local/bin/
RUN curl -SL https://github.com/pachterlab/kallisto/archive/v${kallisto_version}.tar.gz \
    | tar -zxvC /usr/local/bin/
WORKDIR /usr/local/bin/kallisto-${kallisto_version}/ext/htslib
RUN autoheader
RUN autoconf
RUN mkdir -p /usr/bin/kallisto/kallisto-${kallisto_version}/build
WORKDIR /usr/local/bin/kallisto-${kallisto_version}/build
RUN cmake ..
RUN make
RUN make install
WORKDIR /usr/local/bin

# set default command
CMD ["kallisto"]
