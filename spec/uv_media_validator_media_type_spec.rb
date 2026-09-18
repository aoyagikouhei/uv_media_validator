require "tempfile"

RSpec.describe "media type detection" do
  let(:embedded_svg_video) { "test/fb_videos/embedded_svg_metadata.mp4" }

  it "classifies an MP4 containing embedded SVG metadata as video for mixed-media factories" do
    factories_and_classes = {
      get_tw_validator: UvMediaValidator::TwVideo,
      get_fb_validator: UvMediaValidator::FbVideo,
      get_ig_feed_validator: UvMediaValidator::IgVideo,
      get_ig_stories_validator: UvMediaValidator::IgStoriesVideo,
      get_pin_validator: UvMediaValidator::PinVideo,
      get_tt_validator: UvMediaValidator::TtVideo
    }

    factories_and_classes.each do |factory, expected_class|
      validator = UvMediaValidator.public_send(factory, embedded_svg_video)
      expect(validator).to be_a(expected_class), "factory: #{factory}"
    end
  end

  it "classifies an MP4 containing embedded SVG metadata as an Instagram reel" do
    validator = UvMediaValidator.get_ig_reel_validator(embedded_svg_video)
    expect(validator).to be_a(UvMediaValidator::IgReel)
  end

  it "does not accept an MP4 containing embedded SVG metadata as a TikTok thumbnail" do
    validator = UvMediaValidator.get_tt_thumbnail_validator(embedded_svg_video)
    expect(validator).to be_nil
  end

  %w[avif heic].each do |extension|
    it "does not classify a C2PA #{extension.upcase} image with an SVG icon as video" do
      path = "test/fixtures/c2pa_icon.#{extension}"

      expect(File.binread(path, 1024).index("<svg")).not_to be_nil
      expect(ImageSize.path(path).format).to eq(:svg)
      expect(FFMPEG::Movie).not_to receive(:new)

      factories_and_classes = {
        get_tw_validator: UvMediaValidator::TwImage,
        get_fb_validator: UvMediaValidator::FbImage,
        get_ig_feed_validator: UvMediaValidator::IgImage,
        get_ig_stories_validator: UvMediaValidator::IgStoriesImage,
        get_pin_validator: UvMediaValidator::PinImage,
        get_tt_validator: UvMediaValidator::TtImage,
        get_tt_thumbnail_validator: UvMediaValidator::TtThumbnail
      }

      factories_and_classes.each do |factory, expected_class|
        validator = UvMediaValidator.public_send(factory, path)
        expect(validator).to be_a(expected_class), "factory: #{factory}"
      end
      expect(UvMediaValidator.get_ig_reel_validator(path)).to be_nil
    end
  end

  it "probes an ISO BMFF image brand when compatible brands declare an image sequence" do
    Tempfile.create(["image-sequence-with-svg", ".bin"]) do |file|
      file.binmode
      file.write([24].pack("N"))
      file.write("ftypmif1")
      file.write([0].pack("N"))
      file.write("mif1avis")
      file.write('<svg width="16" height="16"></svg>')
      file.flush

      expect(ImageSize.path(file.path).format).to eq(:svg)
      movie = double("FFMPEG::Movie", valid?: true)
      expect(FFMPEG::Movie).to receive(:new).with(file.path).and_return(movie)

      validator = UvMediaValidator.get_fb_validator(file.path)
      expect(validator).to be_a(UvMediaValidator::FbVideo)
    end
  end
end
