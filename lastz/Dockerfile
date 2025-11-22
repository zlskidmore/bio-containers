# work from latest LTS ubuntu release
FROM ubuntu:24.04

# set the environment variables
ENV lastz_version=1.04.52

# run update and install necessary packages
RUN apt-get update -y && apt-get install -y \
    bzip2 \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libnss-sss \
    libbz2-dev \
    liblzma-dev \
    vim \
    less \
    libcurl4-openssl-dev \
    wget

# download the tool and make it
WORKDIR /usr/local/bin/
RUN wget https://github.com/lastz/lastz/archive/refs/tags/${lastz_version}.tar.gz
RUN tar -xvzf ${lastz_version}.tar.gz

# build the tool
WORKDIR /usr/local/bin/lastz-${lastz_version}/src
RUN make
RUN make install

RUN make lastz_32
RUN make install_32

# copy binaries
RUN cp /root/lastz-distrib/bin/* /usr/local/bin/

# set default behavior
CMD ["lastz", "--help"]


