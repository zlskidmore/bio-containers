# BWA-MEM2

Docker container for **BWA-MEM2 2.3** for short-read DNA alignment, built in the bio-containers Dockerfile style. The image builds on `zlskidmore/bio-base:1.0.0`, installs `bwa-mem2` on `PATH`, and uses `/data` as the working directory.

**Platform: Linux AMD64.** On Apple Silicon, use `--platform linux/amd64` through Docker Desktop's architecture support. This is not a native ARM64 image.

[Upstream release](https://github.com/bwa-mem2/bwa-mem2/releases/tag/v2.3) · [Upstream documentation](https://github.com/bwa-mem2/bwa-mem2)

## Build

Add this folder as `bwa-mem2/` in bio-containers, then run from the repository root:

```bash
docker buildx build --platform linux/amd64 --load \
    -t zlskidmore/bwa-mem2:2.3 \
    -t zlskidmore/bwa-mem2:latest ./bwa-mem2
```

The complete source release includes its required submodules. The Dockerfile verifies the archive SHA-256 and source commit, then compiles the upstream dispatcher and SSE4.1, SSE4.2, AVX, AVX2, and AVX512BW executables using GCC. The dispatcher selects an implementation compatible with the reported CPU. All executables are installed together in `/usr/local/bin`.

`BUILD_JOBS` defaults to 4. Reduce compilation concurrency with `--build-arg BUILD_JOBS=2` if needed. The recipe explicitly rejects a native ARM64 build rather than installing x86 executables into an ARM image.

## Version metadata correction

The official 2.3 source archive and precompiled binary still identify the program as **2.2.1**. This recipe uses the verified **2.3 source revision** and changes only the stale `PACKAGE_VERSION` definition in `src/main.cpp` to `2.3`. It does not change alignment logic. This correction makes both `bwa-mem2 version` and the SAM `@PG` version field identify the release being built.

- Source commit: `7aa5ff6c3330490e5629ab9b7327683d2dce02d6`.
- Source archive SHA-256: `0c48a1ea800af499ae7264b4c8908c4ca35fbe5a7df2ad6106c79aa94bb49cbb`.
- License, upstream README and NEWS, and the source commit are retained in `/opt/bwa-mem2/`.

Upstream recommends its Intel-compiled binaries for performance. This GCC source build makes provenance and the version correction explicit; no throughput comparison with those binaries was performed.

## Check the installation

```bash
docker run --rm --platform linux/amd64 \
    zlskidmore/bwa-mem2:2.3 bwa-mem2 version
```

Expected version: `2.3`. CPU-dispatch messages may also appear on standard error.

## Index a reference

Run from a directory containing your uncompressed `reference.fa`:

```bash
docker run --rm --platform linux/amd64 -v "$PWD:/data" \
    zlskidmore/bwa-mem2:2.3 bwa-mem2 index /data/reference.fa
```

The index files are written alongside the FASTA. Build the index with BWA-MEM2; do not reuse an original BWA index. Retain the reference assembly, FASTA checksum, index-tool version, and index files with your workflow records.

## Align paired-end reads

Run from a directory containing the indexed reference and the paired FASTQ files:

```bash
docker run --rm --platform linux/amd64 -v "$PWD:/data" \
    zlskidmore/bwa-mem2:2.3 bash -o pipefail -c '
        bwa-mem2 mem -t 4 \
            -R "@RG\tID:sample\tSM:sample\tPL:ILLUMINA" \
            /data/reference.fa \
            /data/reads_R1.fastq.gz /data/reads_R2.fastq.gz \
        | samtools sort -@ 4 -o /data/sample.sorted.bam - &&
        samtools index /data/sample.sorted.bam
    '
```

Replace the read-group/sample identifiers with the identifiers for your data. The output BAM and index are saved on your host. BWA-MEM2 and samtools run concurrently in this example; choose thread counts to fit your allocated resources. `pipefail` ensures an alignment failure also fails the command.

BWA-MEM2 is the DNA short-read alignment path in this collection. Use the appropriate minimap2 workflow for long reads and STAR for spliced short-read RNA alignment.

## Validate

From this directory:

```bash
docker run --rm -i --platform linux/amd64 \
    zlskidmore/bwa-mem2:2.3 python - < validate.py
```

The reproducible synthetic test builds an index, aligns compressed paired-end FASTQs, and verifies 40 properly paired fragments against known coordinates, CIGAR strings, strands, mate coordinates, insert sizes, read groups, and zero edit distances. It also checks two deliberately unmappable reads, the corrected SAM version header, sorted/indexed BAM integrity, and agreement between the SSE4.1 executable and the automatically selected executable.

This is a functional software check, not a human-genome accuracy or performance benchmark. It does not establish equivalence for every old BWA workflow. Compare representative data before migrating an established analysis.

The Linux AMD64 image passed all checks on November 5, 2026 using Docker Desktop on Apple Silicon through its AMD64 architecture support. The dispatcher selected AVX2; SSE4.1 was tested explicitly. Other compiled instruction-set variants were not executed. This was not a physical Intel/AMD host test. See `validation-results.json` for the recorded results and image digest, and `version-metadata.patch` for the exact source-label correction. Both `2.3` and `latest` tags are loaded locally; nothing has been pushed to Docker Hub or GitHub.

## Credits

Container maintained by [Zachary Skidmore](https://zlskidmore.github.io). BWA-MEM2 is developed by the upstream BWA-MEM2 contributors. Its upstream license is retained in `/opt/bwa-mem2/LICENSE`; consult the upstream documentation for citations and usage guidance.

