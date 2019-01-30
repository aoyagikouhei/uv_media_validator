RSpec.describe UvMediaValidator do
  it "has a version number" do
    expect(UvMediaValidator::VERSION).not_to be nil
  end

  it "tw image big size" do
    media = UvMediaValidator::TwImage.new("test/tw_images/51.png")
    expect(media.file_size?).to eq(false)
    expect(media.width?).to eq(true)
    expect(media.height?).to eq(true)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw image bad height" do
    media = UvMediaValidator::TwImage.new("test/tw_images/1000_2.png")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(true)
    expect(media.height?).to eq(false)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "tw image bad width" do
    media = UvMediaValidator::TwImage.new("test/tw_images/2_1000.png")
    expect(media.file_size?).to eq(true)
    expect(media.width?).to eq(false)
    expect(media.height?).to eq(true)
    expect(media.format?).to eq(true)
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

  it "fb image valid" do
    path = "test/fb_images"
    ary = %w(50.png 51.png bmp.bmp tiff.tiff)
    ary.each do |f|
      media = UvMediaValidator::FbImage.new(File.join(path, f))
      expect(media.all?).to eq(true), "cause #{f}"
    end
  end

  it "fb video wrong aspect_ratio" do
    media = UvMediaValidator::FbVideo.new("test/fb_videos/wrong_aspect.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(true)
    expect(media.aspect_ratio?).to eq(false)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "fb video bad duration" do
    media = UvMediaValidator::FbVideo.new("test/fb_videos/21min.mp4")
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(false)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "fb video async duration" do
    media = UvMediaValidator::FbVideo.new("test/fb_videos/21min.mp4", sync_flag: false)
    expect(media.all?).to eq(true)
  end

  it "fb video valid" do
    path = "test/fb_videos"
    ary = %w(avi.avi mov.mov mp4.mp4 wmv.wmv)
    ary.each do |f|
      media = UvMediaValidator::FbVideo.new(File.join(path, f))
      expect(media.all?).to eq(true), "cause #{f}"
    end
  end
end
