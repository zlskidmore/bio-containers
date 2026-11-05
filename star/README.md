# STAR

Docker container for **STAR 2.7.11b**, the latest stable upstream release checked on November 5, 2026. Builds STAR from its checksum-verified source archive, installs it on `PATH`, and uses `/data` as the working directory.

[Docker Hub](https://hub.docker.com/r/zlskidmore/star) · [Source recipe](https://github.com/zlskidmore/bio-containers/tree/main/star) · [Upstream release](https://github.com/alexdobin/STAR/releases/tag/2.7.11b)

## Run locally

```bash
docker run --rm zlskidmore/star:2.7.11b STAR --version
docker run --rm zlskidmore/star:2.7.11b STAR --help
```

To align reads using an existing STAR genome index, run from a directory containing `genome-index/`, `reads_R1.fastq.gz`, and `reads_R2.fastq.gz`:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/star:2.7.11b \
    STAR --runThreadN 4 \
    --genomeDir /data/genome-index \
    --readFilesIn /data/reads_R1.fastq.gz /data/reads_R2.fastq.gz \
    --readFilesCommand zcat \
    --outSAMtype BAM SortedByCoordinate \
    --outFileNamePrefix /data/sample.
```

Use an index compatible with this STAR version and allocate sufficient memory for your reference genome. The example writes outputs into the current directory on your host.

## Build

From the root of bio-containers after replacing `star/Dockerfile` with the supplied file:

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
    --load -t zlskidmore/star:2.7.11b -t zlskidmore/star:latest ./star
```

Loading both architectures requires a Docker image store that supports multi-platform images, such as the containerd store used for this build. For a single-platform builder, omit `--platform` to build for the host architecture.

The recipe follows the collection's section headings and environment-variable style, builds on `zlskidmore/bio-base:1.0.0`, and adds `xxd`, which STAR's build uses. `BUILD_JOBS` defaults to 4 and can be changed with `--build-arg BUILD_JOBS=2` if memory is limited. AMD64 uses SSE2 rather than requiring AVX2; ARM64 uses STAR's bundled SIMDe implementation. The installed executable is `STAR`; `STARlong` is not built.

## Validate

From this directory:

```bash
docker run --rm -i --platform linux/arm64 zlskidmore/star:2.7.11b python - < validate.py
docker run --rm -i --platform linux/amd64 zlskidmore/star:2.7.11b python - < validate.py
```

The validation checks version and help output, builds a tiny annotated genome index, aligns three deterministic reads, verifies exact coordinates and strand, checks the expected `60M500N60M` splice-junction alignment, and checks the output BAM with samtools. Test data and indexes are created in a temporary container directory.

Both Linux ARM64 and AMD64 builds passed all checks on November 5, 2026 using Docker Desktop on Apple Silicon. ARM64 ran natively; AMD64 ran through Docker Desktop architecture support. See `validation-results.json` for the results and local image digest. The images are loaded locally under both tags; they have not been pushed to Docker Hub.

## Docker Hub overview

Copy the following three paragraphs into the Overview editor after publishing the matching image:

```markdown
This container provides **STAR 2.7.11b** for RNA-seq alignment, including spliced alignment and STARsolo functionality. Supports **AMD64 and ARM64**, with `/data` as the working directory.

Find the Dockerfile and build instructions in the [bio-containers STAR directory](https://github.com/zlskidmore/bio-containers/tree/main/star).

Container maintained by [Zachary Skidmore](https://zlskidmore.github.io).
```

## Credits

Container maintained by [Zachary Skidmore](https://zlskidmore.github.io). STAR is developed by [Alexander Dobin and contributors](https://github.com/alexdobin/STAR). The upstream license is retained at `/opt/STAR/LICENSE` in the image. Consult the upstream documentation for citation guidance.

