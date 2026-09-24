# Facebook video fixtures

`embedded_svg_metadata.mp4` is a synthetic H.264 MP4 whose metadata contains
SVG markup. It reproduces `image_size` 2.1.2 detecting an embedded SVG as the
format of the whole file. It is not a C2PA-signed file.

Regenerate it from the repository root with:

```sh
ffmpeg \
  -hide_banner \
  -loglevel error \
  -f lavfi \
  -i color=c=black:s=64x64:d=0.04 \
  -frames:v 1 \
  -c:v libx264 \
  -pix_fmt yuv420p \
  -movflags +faststart+use_metadata_tags \
  -metadata comment='<svg width="716" height="716"></svg>' \
  -y test/fb_videos/embedded_svg_metadata.mp4
```
