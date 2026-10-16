# bio-containers

A collection of Dockerfiles and build recipes for bioinformatics tools and analysis environments, maintained by [Zachary Skidmore](https://zlskidmore.github.io).

This repository keeps container definitions in one place so they are easier to inspect, build, and maintain. Each tool has its own directory containing a Dockerfile and any supporting scripts or documentation.

**[Docker Hub](https://hub.docker.com/u/zlskidmore) · [Personal website](https://zlskidmore.github.io) · [Report an issue](https://github.com/zlskidmore/bio-containers/issues)**

## Container recipes

| Tool or environment | Build recipe |
| --- | --- |
| Shared bioinformatics base | [bio-base](./bio-base/) |
| fastp | [fastp](./fastp/) |
| fgbio | [fgbio](./fgbio/) |
| HTSeq | [htseq](./htseq/) |
| kallisto | [kallisto](./kallisto/) |
| Kraken 2 | [kraken2](./kraken2/) |
| mosdepth | [mosdepth](./mosdepth/) |
| MultiQC | [multiqc](./multiqc/) |
| Picard | [picard](./picard/) |
| preseq | [preseq](./preseq/) |
| R, Bioconductor, and CRAN environment | [r-bioc-cran](./r-bioc-cran/) |
| SciClone | [sciclone](./sciclone/) |
| SigProfilerExtractor | [sigprofilerextractractor](./sigprofilerextractractor/) |
| Somalier | [somalier](./somalier/) |
| STAR | [star](./star/) |
| TelSeq | [telseq](./telseq/) |
| VerifyBamID | [verifybamid](./verifybamid/) |

See each Dockerfile for its software version, dependencies, and installation method. Published image tags and supported architectures are listed on Docker Hub.

## Use a published image

Find images under the [zlskidmore Docker Hub profile](https://hub.docker.com/u/zlskidmore). Use an explicit version tag when recording or sharing a workflow.

Start with `bio-base`, the shared environment at the core of this collection. To pull it and check the bundled samtools installation:

```bash
docker pull zlskidmore/bio-base:1.0.0
docker run --rm zlskidmore/bio-base:1.0.0 samtools --version
```

To make files in your current directory available inside the container:

```bash
docker run --rm -v "$PWD:/data" -w /data zlskidmore/bio-base:1.0.0 \
    samtools flagstat reads.bam > flagstat.txt
```

This example summarizes alignment statistics for `reads.bam` and saves the report to `flagstat.txt` on your host. See the [bio-base directory](./bio-base/) for the base image recipe and bundled tools.

## Build locally

Clone the repository and build the core image:

```bash
git clone https://github.com/zlskidmore/bio-containers.git
cd bio-containers
docker build -t zlskidmore/bio-base:1.0.0 ./bio-base
```

Replace the image name, tag, and directory with those for your chosen tool. Recipes that use `zlskidmore/bio-base` pull the base image specified in their Dockerfile.

## Platform support

The published `bio-base:1.0.0` image provides both `linux/amd64` and `linux/arm64` variants. Architecture support for other images depends on the tool, its dependencies, and the published tag; check each image before choosing a platform.

Docker Buildx can build bio-base for both architectures and save a multi-platform OCI archive:

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
    -t zlskidmore/bio-base:1.0.0 \
    --output type=oci,dest=bio-base-1.0.0.tar ./bio-base
```

This requires a builder configured for both target architectures.

## Reproducibility

Use versioned image tags, record the image digest for important analyses, and consult the Dockerfile for dependency details. A pinned tool version alone does not guarantee identical rebuilds when base images or dependencies can change.

## Issues and contributions

For container build or runtime problems, [open an issue](https://github.com/zlskidmore/bio-containers/issues) with the tool name, image tag, platform, command, and relevant error output. Pull requests for fixes, version updates, and additional recipes are welcome.

Questions about a tool's algorithms or scientific interpretation are best directed to its upstream project.

## Credits and licensing

Container recipes are maintained by [Zachary Skidmore](https://zlskidmore.github.io). The packaged tools are developed by their respective upstream authors and retain their original licenses. Consult each project's documentation for license terms and citation guidance, and cite the underlying tools when using them in research.
