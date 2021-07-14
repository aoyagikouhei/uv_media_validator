RSpec.describe UvMediaValidator do
  it "has a version number" do
    expect(UvMediaValidator::VERSION).not_to be nil
  end

  it "get_fb_validator" do
    media = UvMediaValidator.get_fb_validator("test/fb_videos/avi.avi")
    expect(media.class.name).to eq("UvMediaValidator::FbVideo")
    expect(media.all?).to eq(true)

    media = UvMediaValidator.get_fb_validator("test/fb_images/tiff.tiff")
    expect(media.class.name).to eq("UvMediaValidator::FbImage")
    expect(media.all?).to eq(true)
  end

  it "fb image big file size" do
    media = UvMediaValidator::FbImage.new("test/fb_images/101.png")
    expect(media.file_size?).to eq(false)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "fb image big file size (specified size)" do
    media = UvMediaValidator::FbImage.new("test/fb_images/51.png", max_image_bytes: 5 * 1024 * 1024)
    expect(media.file_size?).to eq(false)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it "fb image valid (specified size)" do
    media = UvMediaValidator::FbImage.new("test/fb_images/50.png", max_image_bytes: 5 * 1024 * 1024)
    expect(media.file_size?).to eq(true)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(true)
  end

  it "fb image bad format" do
    media = UvMediaValidator::FbImage.new("test/fb_images/150x150.psd")
    expect(media.format?).to eq(false)
    expect(media.all?).to eq(false)
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
