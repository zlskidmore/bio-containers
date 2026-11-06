# FastQC

Docker container for **FastQC 0.13.0**, built in the bio-containers Dockerfile style. Uses `zlskidmore/bio-base:1.0.0`, installs FastQC in `/opt/fastqc` with its command on `PATH`, and sets `/data` as the working directory.

**Native Linux AMD64 and ARM64.** Includes Java 17, the Python 3 launcher, and fonts for headless report generation. The same official FastQC distribution runs on each architecture's native Java runtime.

[Upstream release](https://github.com/s-andrews/FastQC/releases/tag/v0.13.0) · [Upstream project](https://github.com/s-andrews/FastQC)

## Build

Add this folder as `fastqc/` in bio-containers, then run from the repository root:

```bash
docker buildx build --platform linux/amd64,linux/arm64 --load \
    -t zlskidmore/fastqc:0.13.0 \
    -t zlskidmore/fastqc:latest ./fastqc
```

Loading both variants requires a multi-platform image store, such as Docker Desktop's containerd store. For a single-platform store, omit `--platform` to build for the host, or choose one architecture at a time.

The official release archive is pinned by SHA-256: `c9504d47752e79ecfe61691e09bf367fc3f15167ac3fe83d9e33534fffbcc301`. Java and other Ubuntu packages resolve at build time; their versions are not fully locked by this recipe.

## Check the installation

```bash
docker run --rm zlskidmore/fastqc:0.13.0 fastqc --version
```

Expected output: `FastQC v0.13.0`. Docker selects the image for your architecture automatically.

## Analyze paired FASTQ files

Run from the directory containing your reads. Create the output directory first; FastQC expects it to exist:

```bash
mkdir -p fastqc-results

docker run --rm -v "$PWD:/data" zlskidmore/fastqc:0.13.0 \
    fastqc --threads 4 --outdir /data/fastqc-results \
        /data/reads_R1.fastq.gz /data/reads_R2.fastq.gz
```

FastQC checks each file separately. The HTML reports and ZIP archives are saved in `fastqc-results/` on your host. The ZIP files include `fastqc_data.txt` and module summaries for downstream aggregation. Use your selected MultiQC workflow to combine reports across samples.

In this release, `--threads` is the total CPU thread count, and a single file can use up to four threads. Allocate resources for the chosen file count and thread setting. `--memory` sets the base per-file memory allowance in MB; it defaults to 512.

## Report options

SVG plots are the default in 0.13.0. To generate PNG plots and extract the ZIP contents:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/fastqc:0.13.0 \
    fastqc --threads 4 --png --extract \
        --outdir /data/fastqc-results /data/reads_R1.fastq.gz
```

FastQC module FAIL/WARN results describe properties of the input, not an installation failure. Review them in the context of the library and assay. The validation deliberately uses poor-quality reads and expects the appropriate FAIL flags.

## Changes from older FastQC versions

- The launcher now uses **Python 3** instead of Perl. This image includes the required interpreter.
- Reports use **SVG** by default; `--png` selects raster plots.
- The thread setting now describes total CPU threads rather than simply one thread per file.
- Normal modern FASTQ input uses the default quality encoding. Use `--phred64` only for legacy Phred64 data.
- `--min_length` and `--max_length` **filter reads before analysis**. They do not merely change the plot axes. Avoid adding them unless dropping those reads is intended.

See the [0.13.0 release notes](https://github.com/s-andrews/FastQC/releases/tag/v0.13.0) when migrating older commands.

## Credits

Container maintained by [Zachary Skidmore](https://zlskidmore.github.io). FastQC is developed by Simon Andrews and contributors. The upstream license, bundled dependency licenses, documentation, and configuration remain in `/opt/fastqc`. Consult the project for citation guidance.

