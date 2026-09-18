# C2PA image fixtures

`c2pa_icon.avif` and `c2pa_icon.heic` are synthetic 64x64 static images with
a C2PA manifest whose claim-generator icon is `plain.svg`. They contain no
customer data and use c2patool's built-in development certificate.

Regenerate them from the repository root:

```sh
ffmpeg \
  -hide_banner \
  -loglevel error \
  -f lavfi \
  -i color=c=black:s=64x64:d=0.04 \
  -frames:v 1 \
  -c:v libaom-av1 \
  -still-picture 1 \
  -y /tmp/uv-media-validator-static.avif

magick -size 64x64 xc:black /tmp/uv-media-validator-static.heic

c2patool \
  /tmp/uv-media-validator-static.avif \
  -m test/fixtures/c2pa_manifest.json \
  -o test/fixtures/c2pa_icon.avif \
  --force

c2patool \
  /tmp/uv-media-validator-static.heic \
  -m test/fixtures/c2pa_manifest.json \
  -o test/fixtures/c2pa_icon.heic \
  --force
```
