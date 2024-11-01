# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Pinterest' do
  it 'has a version number' do
    expect(UvMediaValidator::VERSION).not_to be nil
  end

  it 'get_pin_validator' do
    media = UvMediaValidator.get_pin_validator('test/pin_videos/4s_1920x1920.mp4')
    expect(media.class.name).to eq('UvMediaValidator::PinVideo')
    expect(media.all?).to eq(true)

    media = UvMediaValidator.get_pin_validator('test/pin_images/9038x9900.jpg')
    expect(media.class.name).to eq('UvMediaValidator::PinImage')
    expect(media.all?).to eq(true)
  end

  it 'get_pin_validator (H264)' do
    media = UvMediaValidator.get_pin_validator('test/pin_videos/30m_1280x1024_h264.mp4')
    expect(media.class.name).to eq('UvMediaValidator::PinVideo')
    expect(media.all?).to eq(true)
  end

  it 'get_pin_validator (H265)' do
    media = UvMediaValidator.get_pin_validator('test/pin_videos/30m_1280x1024_h265.mp4')
    expect(media.class.name).to eq('UvMediaValidator::PinVideo')
    expect(media.all?).to eq(true)
  end

  it 'pin image big file size' do
    media = UvMediaValidator::PinImage.new('test/pin_images/9038x9900_20MbyteOver.jpg')
    expect(media.file_size?).to eq(false)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it 'pin image bad format' do
    media = UvMediaValidator::PinImage.new('test/pin_images/500x500.psd')
    expect(media.format?).to eq(false)
    expect(media.all?).to eq(false)
  end

  it 'pin image valid' do
    path = 'test/pin_images'
    ary = %w[500x500.bmp 9038x9900.jpeg 9038x9900.png 500x500.tiff 9038x9900.webp]
    ary.each do |f|
      media = UvMediaValidator::PinImage.new(File.join(path, f))
      expect(media.all?).to eq(true), "cause #{f}"
    end
  end

  it 'pin video wrong aspect_ratio (for 1.91 / 1.0)' do
    media = UvMediaValidator::PinVideo.new('test/pin_videos/4s_1800x900.mp4')
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(true)
    expect(media.aspect_ratio?).to eq(false)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it 'pin video wrong aspect_ratio (for 1.0 / 2.0)' do
    media = UvMediaValidator::PinVideo.new('test/pin_videos/4s_900x1801.mp4')
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(true)
    expect(media.aspect_ratio?).to eq(false)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it 'pin video bad duration' do
    media = UvMediaValidator::PinVideo.new('test/pin_videos/901s_1280x1024.mp4')
    expect(media.file_size?).to eq(true)
    expect(media.duration?).to eq(false)
    expect(media.aspect_ratio?).to eq(true)
    expect(media.format?).to eq(true)
    expect(media.all?).to eq(false)
  end

  it 'pin video valid' do
    path = 'test/pin_videos'
    ary = %w[30s_1280x1024.mov 30s_1280x1024.m4v 4s_1280x1024.mp4]
    ary.each do |f|
      media = UvMediaValidator::FbVideo.new(File.join(path, f))
      expect(media.all?).to eq(true), "cause #{f}"
    end
  end
end
# rubocop:enable Metrics/BlockLength
