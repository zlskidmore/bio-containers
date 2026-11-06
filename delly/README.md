# Delly

Docker container for **Delly 2.8.1**, built in the bio-containers Dockerfile style. Uses `zlskidmore/bio-base:1.0.0`, installs `delly` on `PATH`, and sets `/data` as the working directory. Samtools and bcftools are available through the base image.

**Native Linux AMD64 and ARM64.** The Dockerfile selects the corresponding official release binary and verifies its SHA-256. It also retains upstream licensing, documentation, and the small example BAMs/reference in `/opt/delly`.

[Upstream release](https://github.com/dellytools/delly/releases/tag/v2.8.1) · [Upstream documentation](https://github.com/dellytools/delly/blob/v2.8.1/README.md)

## Build

Add this folder as `delly/` in bio-containers, then run from the repository root:

```bash
docker buildx build --platform linux/amd64,linux/arm64 --load \
    -t zlskidmore/delly:2.8.1 \
    -t zlskidmore/delly:latest ./delly
```

Loading both variants requires a multi-platform image store, such as Docker Desktop's containerd store. With a single-platform store, omit `--platform` for the host architecture or select one platform at a time. ARM64 runs natively on Apple Silicon.

Pinned release hashes:

| File | SHA-256 |
|---|---|
| Linux AMD64 binary | `f3e309486a28393b78d4d2f8b63ce2c4d778d1e4e80a3f8d53dc4c2673e38a5c` |
| Linux ARM64 binary | `04d7f0442fa217afc6a65bd654395da0a809ca462e8f282d5121df57c76efc78` |
| Source archive used for documentation/example data | `09cfe5e6678ddd9da8b21667c0a593ad3c4dcac55bccfb04d068cebfc252f425` |

The two binary hashes also match the digests published in GitHub's release asset metadata.

## Check the installation

```bash
docker run --rm zlskidmore/delly:2.8.1 delly --version
```

The version banner includes `Delly version: v2.8.1` and dependency versions. Delly writes this banner to standard error.

## Prepare inputs

Use coordinate-sorted, indexed BAM/CRAM files with appropriate duplicate marking and correct read-group sample names. The indexed reference FASTA must match the alignments. For short reads, use the appropriate upstream exclusion map for your reference assembly. Keep the reference and its `.fai` available to Delly; CRAM also requires the matching reference for decoding.

The examples below assume all input files and indexes are in the current directory, mounted at `/data`. Outputs are written back to that directory.

## Short-read SV discovery

The current short-read subcommand is **`delly sr`**:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/delly:2.8.1 \
    delly sr -g /data/reference.fa -x /data/exclude.tsv \
        -o /data/sample.sv.bcf /data/sample.bam

docker run --rm -v "$PWD:/data" zlskidmore/delly:2.8.1 \
    bcftools view -Ov -o /data/sample.sv.vcf /data/sample.sv.bcf
```

Replace `exclude.tsv` with the matching exclusion map. The caller writes a BCF and its CSI index. Discovery calls and downstream filtered calls are separate stages.

## Tumor/normal somatic workflow

Call jointly with the matched tumor and normal:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/delly:2.8.1 \
    delly sr -g /data/reference.fa -x /data/exclude.tsv \
        -o /data/pair.sv.bcf /data/tumor.bam /data/normal.bam

docker run --rm -v "$PWD:/data" zlskidmore/delly:2.8.1 \
    bcftools query -l /data/pair.sv.bcf
```

Create `samples.tsv` with exactly the sample identifiers shown by `bcftools query -l`, followed by `tumor` or `control`, separated by a tab. For example, if those identifiers are `tumor_sample` and `normal_sample`:

```text
tumor_sample	tumor
normal_sample	control
```

Then apply somatic filtering:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/delly:2.8.1 \
    delly filter -f somatic -s /data/samples.tsv \
        -o /data/pair.somatic.bcf /data/pair.sv.bcf
```

This is the upstream tumor/normal workflow adapted to the container. It was not tested with a matched biological tumor/normal pair in this build task.

## Long-read SV discovery

For Nanopore:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/delly:2.8.1 \
    delly lr -y ont -g /data/reference.fa \
        -o /data/sample.ont.sv.bcf /data/sample.ont.bam
```

For PacBio, use `-y pb`. Long-read and short-read data need their respective caller modes. This image supports the binary's full CLI; the tests below exercised the upstream example's default `lr` mode and `sr` mode.

## Genotyping and filtering

For genotyping an existing short-read site list:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/delly:2.8.1 \
    delly sr -v /data/sites.bcf -g /data/reference.fa \
        -o /data/sample.genotyped.bcf /data/sample.bam
```

Use `delly merge` to construct a common site list from per-sample discoveries before cohort genotyping. Germline filtering uses `delly filter -f germline`; include `-l` for long-read filtering. Inspect the applicable filtering settings for the assay and cohort. To retain rejected records and tag them, use `-t` rather than interpreting an empty filtered BCF as a failed installation.

## Credits

Container maintained by [Zachary Skidmore](https://zlskidmore.github.io). Delly is developed by Tobias Rausch and contributors. The upstream license and README are retained in `/opt/delly`. Consult the project for citation and licensing guidance.

