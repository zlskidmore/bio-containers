# rMATS-turbo

Docker image for differential alternative splicing analysis with [rMATS-turbo](https://github.com/Xinglab/rmats-turbo).

## Included tools

- rMATS-turbo 4.4.0
- STAR 2.7.11b for FASTQ alignment
- samtools from `zlskidmore/bio-base:1.0.0`

Supports `linux/amd64` and `linux/arm64`. Includes the standard rMATS statistical model; optional PAIRADISE and DARTS models are not installed.

## Build

Run from the directory containing the Dockerfile:

```sh
docker buildx build --platform linux/amd64,linux/arm64 \
  -t zlskidmore/rmats-turbo:latest .
```

Add `--push` to publish both architectures to Docker Hub.

## Usage

Display available options:

```sh
docker run --rm zlskidmore/rmats-turbo:latest rmats.py --help
```

Run with BAM files:

```sh
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/data" \
  zlskidmore/rmats-turbo:latest \
  rmats.py --b1 /data/b1.txt --b2 /data/b2.txt \
  --gtf /data/annotation.gtf -t paired --readLength 150 \
  --nthread 8 --od /data/results --tmp /data/tmp
```

Each sample list contains comma-separated BAM paths inside the container, for example:

```text
/data/sample1.bam,/data/sample2.bam
```

Adjust `--readLength` and `--nthread` for your data. Paired-end reads (`-t paired`) are supported independently of the optional paired statistical model.

For FASTQ input, use `--s1` and `--s2` instead of BAM lists and provide a STAR index with `--bi`. See the [rMATS-turbo documentation](https://github.com/Xinglab/rmats-turbo#usage) for details.

## License

The container recipe is part of [bio-containers](https://github.com/zlskidmore/bio-containers). Included tools retain their respective upstream licenses.

