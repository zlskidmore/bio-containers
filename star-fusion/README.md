# STAR-Fusion

Docker container for **STAR-Fusion 1.15.1** with **STAR 2.7.11b**, built in the bio-containers Dockerfile style. Both programs are installed on `PATH`; the working directory is `/data`.

[Upstream release](https://github.com/STAR-Fusion/STAR-Fusion/releases/tag/STAR-Fusion-v1.15.1) · [Installation and reference requirements](https://github.com/STAR-Fusion/STAR-Fusion/wiki/Installing-STAR-Fusion) · [Reference compatibility](https://github.com/STAR-Fusion/STAR-Fusion/wiki/STAR-Fusion-release-and-CTAT-Genome-Lib-Compatibility-Matrix)

## Included workflow

The image supports standard STAR-Fusion fusion calling from single-end or paired-end FASTQ reads, or from an existing compatible `Chimeric.out.junction` file. It includes the FULL upstream release with FusionAnnotator and FusionFilter, the compiled native Set::IntervalTree plugin, required Perl modules, STAR, and samtools from `bio-base:1.0.0`.

Optional FusionInspector workflows (`--FusionInspector`, `--denovo_reconstruct`), BBMerge preprocessing, and building a CTAT reference from scratch require additional tools that this image does not install. The FULL archive contains those components' source files, but their presence does not mean their optional workflows are configured. Use a prepared CTAT genome library for this container.

## Version label

The official **1.15.1 FULL release archive still reports `STAR-Fusion version: 1.15.0`**. This container preserves that upstream version string. The download is pinned to the 1.15.1 release asset and verified with SHA-256 `3c688c5ca446a3a3171d4f920d7a36fb360d7e49c35425468a3b5feaac0d6187`.

```bash
docker run --rm zlskidmore/star-fusion:1.15.1 STAR-Fusion --version
docker run --rm zlskidmore/star-fusion:1.15.1 STAR --version
docker run --rm zlskidmore/star-fusion:1.15.1 STAR-Fusion --help
```

## Reference library

Download and unpack a compatible prepared CTAT genome library from the [upstream CTAT resources](https://data.broadinstitute.org/Trinity/CTAT_RESOURCE_LIB/). STAR-Fusion 1.15.1 uses the StarFv1.10 library family. Follow the release notes concerning the current `AnnotFilterRule.pm`; the generic boilerplate shipped with the software is not a replacement for the reference library's current rules.

Mount the actual prepared library directory containing `ref_genome.fa`, `ref_annot.gtf`, `ref_genome.fa.star.idx/`, the annotation databases, and `AnnotFilterRule.pm`. A FASTA file alone is insufficient. Use a STAR index compatible with 2.7.11b, rebuilding it if STAR reports an incompatible index. No genome library is bundled or downloaded by this Dockerfile.

## Run from FASTQ

Run from the directory containing your paired FASTQ files. Replace `/absolute/path/to/ctat_genome_lib_build_dir` with your prepared library directory:

```bash
docker run --rm \
    -v "$PWD:/data" \
    -v /absolute/path/to/ctat_genome_lib_build_dir:/ctat:ro \
    zlskidmore/star-fusion:1.15.1 \
    STAR-Fusion --genome_lib_dir /ctat \
        --left_fq /data/reads_R1.fastq.gz \
        --right_fq /data/reads_R2.fastq.gz \
        --CPU 4 \
        --output_dir /data/star-fusion-results
```

The fusion reports are written into `star-fusion-results/` on your host. Human-reference alignment typically needs about 30 GB RAM according to upstream installation guidance; the container uses the memory allocated to Docker Desktop or your execution environment. For single-end reads, omit `--right_fq`.

## Run from STAR junctions

Use a compatible junction file with the expected header and final read-count line:

```bash
docker run --rm \
    -v "$PWD:/data" \
    -v /absolute/path/to/ctat_genome_lib_build_dir:/ctat:ro \
    zlskidmore/star-fusion:1.15.1 \
    STAR-Fusion --genome_lib_dir /ctat \
        -J /data/Chimeric.out.junction \
        --CPU 4 \
        --output_dir /data/star-fusion-results
```

## Build

Add the supplied folder as `star-fusion/` in bio-containers, then run from the repository root:

```bash
docker buildx build --platform linux/amd64,linux/arm64 --load \
    -t zlskidmore/star-fusion:1.15.1 \
    -t zlskidmore/star-fusion:latest ./star-fusion
```

The recipe builds STAR itself and does not depend on publishing the separate STAR image first. The base image is `zlskidmore/bio-base:1.0.0`; source archives have checksum checks. Set `--build-arg BUILD_JOBS=2` to reduce compilation concurrency. Loading both architectures requires a Docker image store with multi-platform support; otherwise build one platform at a time.

## Validation

From this directory:

```bash
docker run --rm -i --platform linux/arm64 zlskidmore/star-fusion:1.15.1 python - < validate.py
docker run --rm -i --platform linux/amd64 zlskidmore/star-fusion:1.15.1 python - < validate.py
```

The tests check program versions and help, Perl compilation for core scripts, the native interval-tree plugin, Berkeley DB access, fusion prediction from supplied synthetic junctions, and the full FASTQ-to-fusion path through STAR. Each fusion test must recover exactly `GENEA--GENEB` with three junction reads. The FASTQ test also builds a tiny STAR index and checks the output BAM.

The synthetic reference uses fabricated database contents and simple test filter rules. It exercises the filtering stages but does not validate their biological annotations. No real human CTAT reference, biological dataset, optional FusionInspector workflow, or reference-building workflow was tested. These are software checks, not a scientific benchmark.

Both architecture builds passed the tests on November 5, 2026 using Docker Desktop on Apple Silicon: ARM64 natively and AMD64 through Docker Desktop architecture support. Fusion-calling fixtures run with one CPU; index generation uses two threads. Results and the local image digest are recorded in `validation-results.json`. Both `1.15.1` and `latest` tags are loaded locally. Nothing has been pushed to Docker Hub or GitHub.

## Docker Hub overview

After adding `star-fusion/` to GitHub and publishing the image, copy these paragraphs into Docker Hub. The GitHub link below points to that intended new directory and will work once you add it.

```markdown
This container provides **STAR-Fusion 1.15.1** for RNA-seq fusion detection, including **STAR 2.7.11b**, FusionAnnotator, and FusionFilter. Supports **AMD64 and ARM64**, with `/data` as the working directory. Requires a compatible prepared CTAT genome library mounted at runtime; optional FusionInspector and reference-building workflows are not configured.

Find the Dockerfile and build instructions in the [bio-containers STAR-Fusion directory](https://github.com/zlskidmore/bio-containers/tree/main/star-fusion).

Container maintained by [Zachary Skidmore](https://zlskidmore.github.io).
```

## Credits

Container maintained by [Zachary Skidmore](https://zlskidmore.github.io). STAR-Fusion, FusionAnnotator, and FusionFilter are developed by their respective upstream authors. STAR is developed by Alexander Dobin and contributors. Upstream license files are retained in the installed source tree, and STAR's license is at `/opt/STAR/LICENSE`. Consult the projects' documentation for citation guidance.

