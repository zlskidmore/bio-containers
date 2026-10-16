# HTSeq

Docker container for **HTSeq 2.1.2**, a Python library for analyzing high-throughput sequencing data. Includes `htseq-count`, `htseq-count-barcodes`, and `htseq-qa` with matplotlib support.

**Platforms:** Linux AMD64 (Intel/AMD) and ARM64 (including Apple Silicon through Docker).

[Docker Hub](https://hub.docker.com/r/zlskidmore/htseq) · [Dockerfile](./Dockerfile) · [HTSeq documentation](https://htseq.readthedocs.io/)

## Pull and run

```bash
docker pull zlskidmore/htseq:2.1.2
docker run --rm zlskidmore/htseq:2.1.2 htseq-count --help
```

Docker automatically selects the image matching your architecture. The default working directory is `/data`; mount your input directory there to access local files.

## Count reads

For a BAM file sorted by read name and an unstranded library, run from the directory containing your BAM and GTF files:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/htseq:2.1.2 \
    htseq-count -f bam -r name -s no \
    reads.name_sorted.bam genes.gtf > counts.tsv
```

Counts are saved to `counts.tsv` on your host. Set `-r` to match the BAM sort order (`name` or `pos`) and `-s` to match your library protocol (`yes`, `no`, or `reverse`).

## Other commands

```bash
docker run --rm zlskidmore/htseq:2.1.2 htseq-count-barcodes --help
docker run --rm zlskidmore/htseq:2.1.2 htseq-qa --help
```

To open an interactive shell with access to your current directory:

```bash
docker run --rm -it -v "$PWD:/data" zlskidmore/htseq:2.1.2 bash
```

## Build locally

From the root of the `bio-containers` repository:

```bash
docker build -t zlskidmore/htseq:2.1.2 ./htseq
```

To build both architectures into an OCI archive:

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
    -t zlskidmore/htseq:2.1.2 \
    --output type=oci,dest=htseq-2.1.2.tar ./htseq
```

Multi-platform builds require a builder configured for both architectures.

## Image details

- Based on `zlskidmore/bio-base:1.0.0`.
- HTSeq is installed in `/opt/venv`, with its commands available on `PATH`.
- `htseq-qa` uses matplotlib's noninteractive `Agg` backend.
- Python development headers and SWIG support source builds on ARM64.
- Optional dependencies for BigWig, MTX, H5AD, and Loom support are not included.
- HTSeq is version-pinned; transitive Python dependencies are not pinned.

## Validation

Both AMD64 and ARM64 images were built and tested using Docker Desktop. Checks covered dependency consistency, HTSeq version, help output for all three commands, and a synthetic SAM/GTF read-counting test that returned the expected result. AMD64 testing used Docker Desktop's architecture support rather than a separate physical Intel host.

## Credits

Container maintained by [Zachary Skidmore](https://zlskidmore.github.io) as part of [bio-containers](https://github.com/zlskidmore/bio-containers).

HTSeq is developed and maintained by the [HTSeq project](https://github.com/htseq/htseq). See its [documentation](https://htseq.readthedocs.io/) for usage guidance and citation information. HTSeq retains its upstream license; this repository provides the container build recipe.
