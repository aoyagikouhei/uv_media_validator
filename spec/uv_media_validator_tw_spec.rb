RSpec.describe UvMediaValidator do
  it "has a version number" do
    expect(UvMediaValidator::VERSION).not_to be nil
  end

  it "get_tw_validator" do
    media = UvMediaValidator.get_tw_validator("test/tw_videos/41fps.mp4")
    expect(media.class.name).to eq("UvMediaValidator::TwVideo")
    expect(media.all?).to eq(true)

    media = UvMediaValidator.get_tw_validator("test/tw_images/webp.webp")
    expect(media.class.name).to eq("UvMediaValidator::TwImage")
    expect(media.all?).to eq(true)

    media = UvMediaValidator.get_tw_validator("test/tw_gifs/351frame.gif")
    expect(media.class.name).to eq("UvMediaValidator::TwAgif")
    expect(media.all?).to eq(false)
  end

  it "tw image big file size" do
    media = UvMediaValidator::TwImage.new("test/tw_images/51.png")
    expect(media.file_size?).to eq(false)
    expect(media.width?).to eq(true)
    expect(media.height?).to eq(true)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw image bad min height" do
    media = UvMediaValidator::TwImage.new("test/tw_images/1000_2.png")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(true)
    expect(media.min_height?).to eq(false)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw image bad max height" do
    media = UvMediaValidator::TwImage.new("test/tw_images/150x9999.png")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(true)
    expect(media.max_height?).to eq(false)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw image bad min width" do
    media = UvMediaValidator::TwImage.new("test/tw_images/2_1000.png")
    expect(media.file_size?).to eq(true)
    expect(media.min_width?).to eq(false)
    expect(media.height?).to eq(true)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw image bad max width" do
    media = UvMediaValidator::TwImage.new("test/tw_images/9999x150.png")
    expect(media.file_size?).to eq(true)
    expect(media.max_width?).to eq(false)
    expect(media.height?).to eq(true)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw image bad format" do
    media = UvMediaValidator::TwImage.new("test/tw_images/150x150.psd")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(true)
    expect(media.height?).to eq(true)
    expect(media.format?).to eq(false)
    expect(media.all?).to eq(false)
  end

  it "tw image valid" do
    path = "test/tw_images"
    ary = %w(50.png webp.webp jpg.jpg fullsize.jpg 49.png)
    ary.each do |f|
      media = UvMediaValidator::TwImage.new(File.join(path, f))
      expect(media.all?).to eq(true), "cause #{f}"
    end
  end

  it "tw gif big resolution" do
    media = UvMediaValidator::TwAgif.new("test/tw_gifs/bigresolution.gif")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(false)
    expect(media.height?).to eq(false)
    expect(media.frames?).to eq(true)
    expect(media.pixels?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw gif big frame" do
    media = UvMediaValidator::TwAgif.new("test/tw_gifs/351frame.gif")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(true)
    expect(media.height?).to eq(true)
    expect(media.frames?).to eq(false)
    expect(media.pixels?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw gif min width" do
    media = UvMediaValidator::TwAgif.new("test/tw_gifs/3x100.gif")
    expect(media.file_size?).to eq(true)
    expect(media.min_width?).to eq(false)
    expect(media.height?).to eq(true)
    expect(media.frames?).to eq(true)
    expect(media.pixels?).to eq(true)
    expect(media.all?).to eq(false)
  end 

  it "tw gif min height" do
    media = UvMediaValidator::TwAgif.new("test/tw_gifs/100x3.gif")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(true)
    expect(media.min_height?).to eq(false)
    expect(media.frames?).to eq(true)
    expect(media.pixels?).to eq(true)
    expect(media.all?).to eq(false)
  end 

  it "tw gif max width" do
    media = UvMediaValidator::TwAgif.new("test/tw_gifs/1281x100.gif")
    expect(media.file_size?).to eq(true)
    expect(media.max_width?).to eq(false)
    expect(media.height?).to eq(true)
    expect(media.frames?).to eq(true)
    expect(media.pixels?).to eq(true)
    expect(media.all?).to eq(false)
  end 

  it "tw gif max height" do
    media = UvMediaValidator::TwAgif.new("test/tw_gifs/100x1081.gif")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(true)
    expect(media.max_height?).to eq(false)
    expect(media.frames?).to eq(true)
    expect(media.pixels?).to eq(true)
    expect(media.all?).to eq(false)
  end 

  it "tw video min height" do
    media = UvMediaValidator::TwVideo.new("test/tw_videos/32x18.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(true)
    expect(media.min_height?).to eq(false)
    expect(media.frame_rate?).to eq(true)
    expect(media.duration?).to eq(false)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.colorspace?).to eq(true)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw video max height" do
    media = UvMediaValidator::TwVideo.new("test/tw_videos/618x1100.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(true)
    expect(media.max_height?).to eq(false)
    expect(media.frame_rate?).to eq(true)
    expect(media.duration?).to eq(false)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.colorspace?).to eq(true)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw video bad frame rate" do
    media = UvMediaValidator::TwVideo.new("test/tw_videos/80frames.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(true)
    expect(media.max_height?).to eq(true)
    expect(media.frame_rate?).to eq(false)
    expect(media.duration?).to eq(false)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.colorspace?).to eq(true)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw video min width" do
    media = UvMediaValidator::TwVideo.new("test/tw_videos/18x32.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.min_width?).to eq(false)
    expect(media.height?).to eq(true)
    expect(media.frame_rate?).to eq(true)
    expect(media.duration?).to eq(false)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.colorspace?).to eq(true)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw video wrong ratio" do
    media = UvMediaValidator::TwVideo.new("test/tw_videos/wrong_ratio.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(true)
    expect(media.height?).to eq(true)
    expect(media.frame_rate?).to eq(true)
    expect(media.duration?).to eq(false)
    expect(media.aspect_ratio?).to eq(false)
    expect(media.colorspace?).to eq(true)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw video bad size" do
    media = UvMediaValidator::TwVideo.new("test/tw_videos/1600x900.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(false)
    expect(media.height?).to eq(true)
    expect(media.frame_rate?).to eq(true)
    expect(media.duration?).to eq(false)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.colorspace?).to eq(true)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw video bad duration" do
    media = UvMediaValidator::TwVideo.new("test/tw_videos/142sec.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(true)
    expect(media.height?).to eq(true)
    expect(media.frame_rate?).to eq(true)
    expect(media.duration?).to eq(false)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.colorspace?).to eq(true)
    expect(media.audio_codec?).to eq(true)
    expect(media.audio_channels?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw video valid" do
    path = "test/tw_videos"
    ary = %w(41fps.mp4 139sec.mp4)
    ary.each do |f|
      media = UvMediaValidator::TwVideo.new(File.join(path, f))
      expect(media.all?).to eq(true), "cause #{f}"
    end
  end
end
