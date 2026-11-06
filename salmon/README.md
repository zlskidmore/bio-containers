# Salmon

Docker container for **Salmon 2.11.0**, built in the bio-containers Dockerfile style. Uses `zlskidmore/bio-base:1.0.0`, installs `salmon` on `PATH`, and sets `/data` as the working directory.

**Native Linux AMD64 and ARM64.** The Dockerfile selects the appropriate official Linux release binary and checks its SHA-256 before installation. No Rust compiler is needed in the image.

[Upstream release](https://github.com/COMBINE-lab/salmon/releases/tag/v2.11.0) · [Documentation](https://combine-lab.github.io/salmon) · [Migration guide](https://github.com/COMBINE-lab/salmon/blob/v2.11.0/MIGRATION.md)

## Build

Add this folder as `salmon/` in bio-containers, then run from the repository root:

```bash
docker buildx build --platform linux/amd64,linux/arm64 --load \
    -t zlskidmore/salmon:2.11.0 \
    -t zlskidmore/salmon:latest ./salmon
```

Loading both variants requires a multi-platform image store, such as Docker Desktop's containerd store. With a single-platform store, omit `--platform` to build for the host, or select one architecture at a time. ARM64 is native on Apple Silicon.

The pinned archive hashes match the upstream release checksum file:

| Platform | SHA-256 |
|---|---|
| AMD64 | `e15b1ef0c4bece9c2ce271e2acbafb6ac1dc22b4b038fe8380f849455b9d8527` |
| ARM64 | `7d87e73701e3310a09fe3cfa5e2d8e72dea6b6dcf2a0f9bc800b868d8d8995dc` |

## Check the installation

```bash
docker run --rm zlskidmore/salmon:2.11.0 salmon --version
```

Expected output: `salmon 2.11.0`. Docker selects the appropriate architecture automatically.

## Migrating older Salmon workflows

Salmon 2.x is a Rust rewrite with a new index format. **Rebuild indexes from Salmon 1.x or older**; do not point this image at an old C++/pufferfish index. An update between compatible 2.x releases does not necessarily require rebuilding; consult the relevant release notes.

The core transcript output remains `quant.sf`, but CLI options and some behaviors changed. Selective alignment is the default, so the old `--validateMappings` flag is unnecessary. Review custom legacy arguments against the [migration guide](https://github.com/COMBINE-lab/salmon/blob/v2.11.0/MIGRATION.md).

**`salmon alevin` is not included in Salmon 2.x.** Use the [alevin-fry ecosystem](https://github.com/COMBINE-lab/alevin-fry) or your selected single-cell quantification workflow for that role. This image's example and tests concern bulk paired-end transcript quantification.

## Build a transcriptome index

Run from a directory containing `transcripts.fa`:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/salmon:2.11.0 \
    salmon index -t /data/transcripts.fa -i /data/salmon-index -p 4
```

Keep the transcriptome version, FASTA checksum, Salmon version, and index settings with the workflow. Do not mix annotation releases when preparing transcript-to-gene mappings.

## Decoy-aware index

For a decoy-aware index, use a matching genome and transcriptome. Put the transcript records first and genome decoy records last. With uncompressed `transcripts.fa` and `genome.fa` in your current directory:

```bash
cat transcripts.fa genome.fa > gentrome.fa
awk '/^>/{sub(/^>/, ""); print $1}' genome.fa > decoys.txt

docker run --rm -v "$PWD:/data" zlskidmore/salmon:2.11.0 \
    salmon index -t /data/gentrome.fa -d /data/decoys.txt \
        -i /data/salmon-decoy-index -p 4
```

The decoy list must contain sequence identifiers that exactly match the corresponding FASTA records. The full genome increases index resource requirements. These preparation steps follow the upstream decoy-aware workflow; a reference already prepared by your pipeline can be used instead.

## Quantify paired-end reads

With the index and gzipped FASTQ files in your current directory:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/salmon:2.11.0 \
    salmon quant -i /data/salmon-decoy-index -l A \
        -1 /data/reads_R1.fastq.gz -2 /data/reads_R2.fastq.gz \
        -p 4 -o /data/sample-quant
```

Use `/data/salmon-index` for the transcript-only index example. The output is written to `sample-quant/` on your host, including `quant.sf` and `aux_info/meta_info.json`. Inspect mapping diagnostics and inferred library type; use an explicit library type when it is known from your protocol. `NumReads` represents estimated fragment assignments and may be fractional on real data.

For optional gene aggregation, add `-g /data/tx2gene.tsv`. Supply a headerless two-column tab-delimited file mapping transcript IDs to gene IDs, with identifiers matching the index. This also writes `quant.genes.sf`. Alternatively, aggregate transcript estimates through your chosen downstream R workflow.

## Credits

Container maintained by [Zachary Skidmore](https://zlskidmore.github.io). Salmon is developed by the COMBINE Lab and contributors. The upstream license and README are retained in `/opt/salmon`. Consult the project documentation for citation guidance.

