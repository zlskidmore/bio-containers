# CNVkit

Docker container for **CNVkit 0.9.14**, built in the bio-containers Dockerfile style. Uses `zlskidmore/bio-base:1.0.0`, installs CNVkit and its Python dependencies in `/opt/venv`, and sets `/data` as the working directory.

**Linux AMD64 and native ARM64.** Includes R and **DNAcopy** for default CBS segmentation, plus the Python dependencies for Haar and HMM methods. Plotting uses matplotlib's headless `Agg` backend.

[Upstream release](https://github.com/etal/cnvkit/releases/tag/v0.9.14) · [Upstream project](https://github.com/etal/cnvkit)

## Build

Add this folder as `cnvkit/` in bio-containers, then run from the repository root:

```bash
docker buildx build --platform linux/amd64,linux/arm64 --load \
    -t zlskidmore/cnvkit:0.9.14 \
    -t zlskidmore/cnvkit:latest ./cnvkit
```

Loading both variants requires a multi-platform image store, such as Docker Desktop's containerd store. With a single-platform store, omit `--platform` to build for the host, or specify a single target architecture.

The CNVkit source is pinned by version and SHA-256: `800cbdf0250e06f5e295f6d71be1707a550a18547b7d442e1df80252dce13e53`. Python dependencies and Ubuntu packages are resolved at build time rather than fully pinned. The tested Python package inventories accompany these files; they record the environment without serving as a rebuild lockfile.

## Check the installation

```bash
docker run --rm zlskidmore/cnvkit:0.9.14 cnvkit.py version
docker run --rm zlskidmore/cnvkit:0.9.14 cnvkit.py --help
```

Expected version: `0.9.14`. Docker selects your architecture automatically.

## Hybrid-capture panel or WES example

Run from a directory containing coordinate-sorted, indexed BAMs (`tumor.bam`, `normal.bam`), an uncompressed `reference.fa`, and the assay's capture intervals (`targets.bed`):

```bash
docker run --rm -v "$PWD:/data" zlskidmore/cnvkit:0.9.14 \
    cnvkit.py batch /data/tumor.bam \
        --normal /data/normal.bam \
        --targets /data/targets.bed \
        --fasta /data/reference.fa \
        --output-reference /data/normal-reference.cnn \
        --output-dir /data/cnvkit-results \
        --processes 4 --scatter --diagram
```

The example uses one normal; a suitable set of normals can be supplied after `--normal` to build a pooled reference. Match the reference to your assay, genome assembly, and library preparation. The FASTA may be indexed during processing, so mount a writable prepared directory or supply its existing index. Outputs are written on your host.

Use the appropriate method for your assay: hybrid capture is the default, while amplicon data requires `--method amplicon`. An amplicon assay does not supply off-target information in the same way as hybrid capture.

## WGS example

With sorted/indexed tumor and normal BAMs, the reference FASTA, and a matching gene annotation file:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/cnvkit:0.9.14 \
    cnvkit.py batch /data/tumor.bam \
        --normal /data/normal.bam \
        --method wgs \
        --fasta /data/reference.fa \
        --annotate /data/refFlat.txt \
        --segment-method haar \
        --output-reference /data/normal-wgs-reference.cnn \
        --output-dir /data/cnvkit-wgs-results \
        --processes 4 --scatter
```

The 0.9.14 release recommends Haar segmentation for WGS. Choose binning/reference settings for coverage and assay characteristics; the command is a workflow example rather than a universal configuration. [Release guidance](https://github.com/etal/cnvkit/releases/tag/v0.9.14)

## Purity, ploidy, and integer copy-number calls

**Correction to the earlier portfolio advice:** this release can estimate purity and ploidy itself. Its new `purity` command fits segmented copy ratios, and somatic HMM segmentation also supports joint estimation. A separate ASCAT-style workflow is therefore not automatically required just to obtain purity/ploidy estimates. More specialized allele-specific or subclonal analyses can still justify a separate method. The synthetic test here verifies software operation, not biological estimation accuracy.

For an existing `.cns` file:

```bash
docker run --rm -v "$PWD:/data" zlskidmore/cnvkit:0.9.14 \
    cnvkit.py purity /data/cnvkit-results/tumor.cns \
        --output /data/cnvkit-results/tumor.purity.tsv

docker run --rm -v "$PWD:/data" zlskidmore/cnvkit:0.9.14 \
    cnvkit.py call /data/cnvkit-results/tumor.cns \
        --purity-file /data/cnvkit-results/tumor.purity.tsv \
        --output /data/cnvkit-results/tumor.called.cns
```

The caller uses the first ranked purity/ploidy solution from the TSV. Inspect model fit and plausible alternative solutions rather than treating every fit as uniquely identified. Supported VCF options can add SNP b-allele-frequency evidence; see `cnvkit.py purity --help`.

## Plot and export

```bash
docker run --rm -v "$PWD:/data" zlskidmore/cnvkit:0.9.14 \
    cnvkit.py scatter /data/cnvkit-results/tumor.cnr \
        --segment /data/cnvkit-results/tumor.called.cns \
        --output /data/cnvkit-results/tumor.scatter.pdf

docker run --rm -v "$PWD:/data" zlskidmore/cnvkit:0.9.14 \
    cnvkit.py export vcf /data/cnvkit-results/tumor.called.cns \
        --output /data/cnvkit-results/tumor.cnv.vcf
```

## Credits

Container maintained by [Zachary Skidmore](https://zlskidmore.github.io). CNVkit is developed by Eric Talevich and contributors; DNAcopy is developed by its Bioconductor authors. CNVkit's upstream license and README are retained in `/opt/cnvkit`. Consult the upstream projects for citations and licensing information.

