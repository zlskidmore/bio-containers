# HTSeq container

Place this directory at `htseq/` in `zlskidmore/bio-containers`.
The Dockerfile follows the repository's MultiQC layout: `bio-base:1.0.0`,
an `/opt/venv` environment, and `/data` as the working directory.
It inherits the base image's default Bash command.

HTSeq is pinned to 2.1.2 and installed from PyPI using its documented pip
installation method. Includes `htseq-count`, `htseq-count-barcodes`, and
`htseq-qa` with matplotlib's noninteractive Agg backend.
Python development headers and SWIG support builds where no HTSeq wheel
is available. Optional BigWig, MTX, H5AD, and Loom dependencies are not included.
Transitive Python dependencies are not pinned.

## Build and check

From the repository root, with Docker running:

```bash
docker build -t zlskidmore/htseq:2.1.2 ./htseq
docker run --rm zlskidmore/htseq:2.1.2 htseq-count --help
```

The image build also checks package dependency consistency, the HTSeq version,
and help output from all three command-line tools.

## Count reads

For paired-end BAM records sorted by read name, and an unstranded assay:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/htseq:2.1.2 \
    htseq-count -f bam -r name -s no reads.name_sorted.bam genes.gtf > counts.tsv
```

Set `-r` to match the input sort order and `-s` to match the library protocol.

## Multi-platform build

To create a local OCI archive without publishing:

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
    -t zlskidmore/htseq:2.1.2 \
    --output type=oci,dest=htseq-2.1.2.tar ./htseq
```

Both platforms require a compatible `zlskidmore/bio-base:1.0.0` image and
a builder configured for those platforms.

## Validation

On October 16, 2026, both `linux/arm64` and `linux/amd64` built successfully
with Docker Desktop and were loaded locally as `zlskidmore/htseq:2.1.2`.
ARM64 compiled HTSeq from source; AMD64 installed its published wheel.
Both passed dependency consistency, HTSeq version 2.1.2, and help checks for
all three commands. Each image also processed a synthetic SAM/GTF fixture
and returned the expected count of one read for `gene1`, with all special
counter values zero. Runtime architectures were confirmed as `aarch64`
and `x86_64`; these are Docker Desktop tests, not separate physical-host tests.

The local multi-platform image digest is
`sha256:dd3b02177cabdaefc9b4a3407dd489eecae865c189f1bb04541c9ef376ca187c`.
No image was pushed to a registry.

## References

- Repository style: https://github.com/zlskidmore/bio-containers/blob/main/multiqc/Dockerfile
- HTSeq source: https://github.com/htseq/htseq
- HTSeq release and installation requirements: https://pypi.org/project/HTSeq/2.1.2/
