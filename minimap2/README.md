# minimap2

Docker container for **minimap2 2.31-r1302**, built in the bio-containers Dockerfile style. Uses `zlskidmore/bio-base:1.0.0`, installs `minimap2` on `PATH`, and sets `/data` as the working directory. Includes samtools through the base image.

**Native Linux AMD64 and ARM64 builds.** ARM64 uses the upstream NEON build (`arm_neon=1 aarch64=1`); AMD64 uses the upstream default CPU-dispatch build.

[Upstream release](https://github.com/lh3/minimap2/releases/tag/v2.31) · [Upstream documentation](https://github.com/lh3/minimap2/blob/v2.31/README.md)

## Build

Add this folder as `minimap2/` in bio-containers, then run from the repository root:

```bash
docker buildx build --platform linux/amd64,linux/arm64 --load \
    -t zlskidmore/minimap2:2.31 \
    -t zlskidmore/minimap2:latest ./minimap2
```

Docker Desktop's multi-platform image store can load both variants. With a single-platform store, omit `--platform` to build for the host architecture, or specify one platform at a time. This recipe builds natively for Apple Silicon when targeting `linux/arm64`.

The recipe checks the source archive SHA-256 before compiling. `BUILD_JOBS` defaults to 4 and can be reduced with `--build-arg BUILD_JOBS=2`.

Source archive SHA-256: `c1351de6319c123369c2f4f37ba0ccf18c7ace47e2b1c0a35e30056b4a3bd9c9`.

## Check the installation

```bash
docker run --rm zlskidmore/minimap2:2.31 minimap2 --version
```

Expected version: `2.31-r1302`. Docker selects the available image variant for your architecture.

## Choose a preset

| Reads | Preset |
|---|---|
| High-quality Nanopore genomic reads, such as Q20 | `lr:hq` |
| Noisier Nanopore genomic reads | `map-ont` |
| PacBio HiFi / CCS genomic reads | `map-hifi` |
| PacBio CLR genomic reads | `map-pb` |
| Spliced long-read RNA, strand unknown | `splice` |
| PacBio Kinnex / Iso-Seq RNA | `splice:hq -uf` |
| Nanopore direct RNA | `splice -uf -k14` |

Use the preset appropriate to the actual library and read quality. These choices follow the [upstream usage examples](https://github.com/lh3/minimap2/blob/v2.31/README.md); the functional tests below cover `map-hifi`, `lr:hq`, `map-ont`, and `splice`.

## Index and align

The following example uses high-quality Nanopore genomic reads. Run from a directory containing `reference.fa` and `reads.fastq.gz`:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/minimap2:2.31 \
    minimap2 -x lr:hq -t 4 -d /data/reference.lr-hq.mmi /data/reference.fa

docker run --rm -v "$PWD:/data" zlskidmore/minimap2:2.31 bash -o pipefail -c '
    minimap2 -ax lr:hq -t 4 \
        /data/reference.lr-hq.mmi /data/reads.fastq.gz \
    | samtools sort -@ 4 -o /data/sample.sorted.bam - &&
    samtools index /data/sample.sorted.bam
'
```

For HiFi, use `map-hifi` in both commands and a distinct index filename. For noisy Nanopore reads, use `map-ont`. Build indexes with the intended preset: indexing parameters such as minimizer size are stored in `.mmi` files and are not replaced by choosing a different mapping preset later. Keep the reference assembly/checksum and index settings with workflow records.

The output BAM and index are written on your host. Alignment and sorting run concurrently in this example; set their thread counts to fit your allocation. `pipefail` ensures an alignment failure fails the overall command.

For PAF output instead of SAM/BAM, omit `-a`:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/minimap2:2.31 \
    minimap2 -x lr:hq -t 4 /data/reference.lr-hq.mmi /data/reads.fastq.gz \
    > alignments.paf
```

## Spliced RNA alignment

For long RNA reads of unknown strand, align directly against the FASTA:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/minimap2:2.31 bash -o pipefail -c '
    minimap2 -ax splice -t 4 /data/reference.fa /data/rna.fastq.gz \
    | samtools sort -@ 4 -o /data/rna.sorted.bam - &&
    samtools index /data/rna.sorted.bam
'
```

Use the assay-specific settings in the preset table where appropriate. Long-read RNA alignment does not itself perform transcript reconstruction, isoform quantification, or single-cell barcode/UMI processing.

## Credits

Container maintained by [Zachary Skidmore](https://zlskidmore.github.io). Minimap2 is developed by Heng Li and contributors. The upstream license and README are retained in `/opt/minimap2`; the manual is in `/usr/local/share/man/man1/minimap2.1`. Consult the upstream project for citation guidance.

