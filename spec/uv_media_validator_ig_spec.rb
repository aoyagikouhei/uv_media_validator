RSpec.describe UvMediaValidator do
  it "has a version number" do
    expect(UvMediaValidator::VERSION).not_to be nil
  end

  it "get_ig_validator" do
    media = UvMediaValidator.get_ig_validator("test/ig_videos/30fps_44100Hz_640x480.mp4")
    expect(media.class.name).to eq("UvMediaValidator::IgVideo")
    expect(media.all?).to eq(true)

    media = UvMediaValidator.get_ig_validator("test/ig_images/700x700.jpeg")
    expect(media.class.name).to eq("UvMediaValidator::IgImage")
    expect(media.all?).to eq(true)
  end

  it "ig image wrong aspect ratio (1 : 2) and wrong format" do
    media = UvMediaValidator::IgImage.new("test/ig_images/100x200.gif")
    expect(media.file_size?).to eq(true)
    expect(media.max_height?).to eq(true)
    expect(media.max_width?).to eq(true)
    expect(media.aspect_ratio?).to eq(false)
    expect(media.format?).to eq(false)
  end

  it "ig image wrong aspect ratio (2 : 1) and wrong format" do
    media = UvMediaValidator::IgImage.new("test/ig_images/200x100.tif")
    expect(media.file_size?).to eq(true)
    expect(media.max_height?).to eq(true)
    expect(media.max_width?).to eq(true)
    expect(media.aspect_ratio?).to eq(false)
    expect(media.format?).to eq(false)
  end

  it "ig image min aspect ratio (4 : 5) and wrong format" do
    media = UvMediaValidator::IgImage.new("test/ig_images/1440x1800.png")
    expect(media.file_size?).to eq(true)
    expect(media.max_height?).to eq(true)
    expect(media.max_width?).to eq(true)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.format?).to eq(false)
  end

  it "ig image max aspect ratio (1.91 : 1)" do
    media = UvMediaValidator::IgImage.new("test/ig_images/1440x754.jpeg")
    expect(media.file_size?).to eq(true)
    expect(media.max_height?).to eq(true)
    expect(media.max_width?).to eq(true)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.format?).to eq(true)
  end

  it "ig image too big" do
    media = UvMediaValidator::IgImage.new("test/ig_images/2000x2000.jpeg")
    expect(media.file_size?).to eq(true)
    expect(media.max_height?).to eq(false)
    expect(media.max_width?).to eq(false)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.format?).to eq(true)
  end

  it "ig video short duration" do
    media = UvMediaValidator::IgVideo.new("test/ig_videos/1.8s.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(false)
    expect(media.max_height?).to eq(true)
    expect(media.max_width?).to eq(true)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.format?).to eq(true)
    expect(media.frame_rate_range?).to eq(true)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_sample_rate?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.video_codec?).to eq(true)
    expect(media.video_bitrate?).to eq(true)
  end

  it "ig video long duration" do
    media = UvMediaValidator::IgVideo.new("test/ig_videos/78s.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(false)
    expect(media.max_height?).to eq(true)
    expect(media.max_width?).to eq(true)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.format?).to eq(true)
    expect(media.frame_rate_range?).to eq(true)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_sample_rate?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.video_codec?).to eq(true)
    expect(media.video_bitrate?).to eq(true)
  end

  it "ig video less fps" do
    media = UvMediaValidator::IgVideo.new("test/ig_videos/15fps.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(true)
    expect(media.max_height?).to eq(true)
    expect(media.max_width?).to eq(true)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.format?).to eq(true)
    expect(media.frame_rate_range?).to eq(false)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_sample_rate?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.video_codec?).to eq(true)
    expect(media.video_bitrate?).to eq(true)
  end

  it "ig video wrong aspect ratio (1 : 2)" do
    media = UvMediaValidator::IgVideo.new("test/ig_videos/200x400.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(true)
    expect(media.max_height?).to eq(true)
    expect(media.max_width?).to eq(true)
    expect(media.aspect_ratio?).to eq(false)
    expect(media.format?).to eq(true)
    expect(media.frame_rate_range?).to eq(true)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_sample_rate?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.video_codec?).to eq(true)
    expect(media.video_bitrate?).to eq(true)
  end

  it "ig video wrong aspect ratio (2 : 1)" do
    media = UvMediaValidator::IgVideo.new("test/ig_videos/400x200.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(true)
    expect(media.max_height?).to eq(true)
    expect(media.max_width?).to eq(true)
    expect(media.aspect_ratio?).to eq(false)
    expect(media.format?).to eq(true)
    expect(media.frame_rate_range?).to eq(true)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_sample_rate?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.video_codec?).to eq(true)
    expect(media.video_bitrate?).to eq(true)
  end

  it "ig video too high spec" do
    media = UvMediaValidator::IgVideo.new("test/ig_videos/8K-120fps-96kHz-6channels.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(true)
    expect(media.max_height?).to eq(false)
    expect(media.max_width?).to eq(false)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.format?).to eq(true)
    expect(media.frame_rate_range?).to eq(false)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_sample_rate?).to eq(false)
    expect(media.audio_channels?).to eq(false)
    expect(media.video_codec?).to eq(true)
    expect(media.video_bitrate?).to eq(false)
  end

  it "ig video high bitrate" do
    media = UvMediaValidator::IgVideo.new("test/ig_videos/8Mbps_1920x1080.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(true)
    expect(media.max_height?).to eq(true)
    expect(media.max_width?).to eq(true)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.format?).to eq(true)
    expect(media.frame_rate_range?).to eq(true)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_sample_rate?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.video_codec?).to eq(true)
    expect(media.video_bitrate?).to eq(false)
  end

  it "ig video wrong format with no audio" do
    media = UvMediaValidator::IgVideo.new("test/ig_videos/mkv.mkv")
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(true)
    expect(media.max_height?).to eq(true)
    expect(media.max_width?).to eq(true)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.format?).to eq(false)
    expect(media.audio_codec?).to eq(false)
    expect(media.audio_sample_rate?).to eq(false)
    expect(media.audio_channels?).to eq(false)
    expect(media.frame_rate_range?).to eq(true)
    expect(media.video_codec?).to eq(true)
    expect(media.video_bitrate?).to eq(true)
  end
end
