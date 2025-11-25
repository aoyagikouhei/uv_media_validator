RSpec.describe 'TikTok' do
  it 'has a version number' do
    expect(UvMediaValidator::VERSION).not_to be nil
  end

  it 'get_tt_validator' do
    media = UvMediaValidator.get_tt_validator('test/tt_videos/valid_640x360_30fps_5s.mp4')
    expect(media.class.name).to eq('UvMediaValidator::TtVideo')
    expect(media.all?).to eq(true)

    media = UvMediaValidator.get_tt_validator('test/tt_images/valid_1080x1920.jpg')
    expect(media.class.name).to eq('UvMediaValidator::TtImage')
    expect(media.all?).to eq(true)
  end

  it 'get_tt_thumbnail_validator' do
    media = UvMediaValidator.get_tt_thumbnail_validator('test/tt_thumbnails/valid_1080x1920.jpg')
    expect(media.class.name).to eq('UvMediaValidator::TtThumbnail')
    expect(media.all?).to eq(true)

    media = UvMediaValidator.get_tt_thumbnail_validator('test/tt_videos/valid_640x360_30fps_5s.mp4')
    expect(media).to eq(nil)
  end

  describe 'TtImage' do
    it 'valid portrait image' do
      media = UvMediaValidator::TtImage.new('test/tt_images/valid_1080x1920.jpg')
      expect(media.file_size?).to eq(true)
      expect(media.resolution?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.all?).to eq(true)
    end

    it 'valid landscape image' do
      media = UvMediaValidator::TtImage.new('test/tt_images/valid_1920x1080.jpg')
      expect(media.file_size?).to eq(true)
      expect(media.resolution?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.all?).to eq(true)
    end

    it 'valid webp image' do
      media = UvMediaValidator::TtImage.new('test/tt_images/valid_800x600.webp')
      expect(media.file_size?).to eq(true)
      expect(media.resolution?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.all?).to eq(true)
    end

    it 'invalid format (png)' do
      media = UvMediaValidator::TtImage.new('test/tt_images/invalid_format.png')
      expect(media.file_size?).to eq(true)
      expect(media.resolution?).to eq(true)
      expect(media.format?).to eq(false)
      expect(media.all?).to eq(false)
    end

    it 'oversized resolution' do
      media = UvMediaValidator::TtImage.new('test/tt_images/oversized_1920x1920.jpg')
      expect(media.file_size?).to eq(true)
      expect(media.resolution?).to eq(false)
      expect(media.format?).to eq(true)
      expect(media.all?).to eq(false)
    end
  end

  describe 'TtVideo' do
    it 'valid video' do
      media = UvMediaValidator::TtVideo.new('test/tt_videos/valid_640x360_30fps_5s.mp4')
      expect(media.file_size?).to eq(true)
      expect(media.duration?).to eq(true)
      expect(media.min_width?).to eq(true)
      expect(media.min_height?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.frame_rate_range?).to eq(true)
      expect(media.all?).to eq(true)
    end

    it 'valid mov format' do
      media = UvMediaValidator::TtVideo.new('test/tt_videos/valid_640x360_30fps_5s.mov')
      expect(media.file_size?).to eq(true)
      expect(media.duration?).to eq(true)
      expect(media.min_width?).to eq(true)
      expect(media.min_height?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.frame_rate_range?).to eq(true)
      expect(media.all?).to eq(true)
    end

    it 'valid webm format' do
      media = UvMediaValidator::TtVideo.new('test/tt_videos/valid_640x360_30fps_5s.webm')
      expect(media.file_size?).to eq(true)
      expect(media.duration?).to eq(true)
      expect(media.min_width?).to eq(true)
      expect(media.min_height?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.frame_rate_range?).to eq(true)
      expect(media.all?).to eq(true)
    end

    it 'too short duration' do
      media = UvMediaValidator::TtVideo.new('test/tt_videos/short_2s.mp4')
      expect(media.file_size?).to eq(true)
      expect(media.duration?).to eq(false)
      expect(media.min_width?).to eq(true)
      expect(media.min_height?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.frame_rate_range?).to eq(true)
      expect(media.all?).to eq(false)
    end

    it 'too long duration' do
      media = UvMediaValidator::TtVideo.new('test/tt_videos/long_650s.mp4')
      expect(media.file_size?).to eq(true)
      expect(media.duration?).to eq(false)
      expect(media.min_width?).to eq(true)
      expect(media.min_height?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.frame_rate_range?).to eq(true)
      expect(media.all?).to eq(false)
    end

    it 'low frame rate' do
      media = UvMediaValidator::TtVideo.new('test/tt_videos/low_fps_15fps.mp4')
      expect(media.file_size?).to eq(true)
      expect(media.duration?).to eq(true)
      expect(media.min_width?).to eq(true)
      expect(media.min_height?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.frame_rate_range?).to eq(false)
      expect(media.all?).to eq(false)
    end

    it 'high frame rate' do
      media = UvMediaValidator::TtVideo.new('test/tt_videos/high_fps_120fps.mp4')
      expect(media.file_size?).to eq(true)
      expect(media.duration?).to eq(true)
      expect(media.min_width?).to eq(true)
      expect(media.min_height?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.frame_rate_range?).to eq(false)
      expect(media.all?).to eq(false)
    end

    it 'too small resolution' do
      media = UvMediaValidator::TtVideo.new('test/tt_videos/small_320x240.mp4')
      expect(media.file_size?).to eq(true)
      expect(media.duration?).to eq(true)
      expect(media.min_width?).to eq(false)
      expect(media.min_height?).to eq(false)
      expect(media.format?).to eq(true)
      expect(media.frame_rate_range?).to eq(true)
      expect(media.all?).to eq(false)
    end
  end

  describe 'TtThumbnail' do
    it 'valid portrait thumbnail' do
      media = UvMediaValidator::TtThumbnail.new('test/tt_thumbnails/valid_1080x1920.jpg')
      expect(media.file_size?).to eq(true)
      expect(media.resolution?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.all?).to eq(true)
    end

    it 'valid landscape thumbnail' do
      media = UvMediaValidator::TtThumbnail.new('test/tt_thumbnails/valid_1920x1080.jpg')
      expect(media.file_size?).to eq(true)
      expect(media.resolution?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.all?).to eq(true)
    end

    it 'valid png format' do
      media = UvMediaValidator::TtThumbnail.new('test/tt_thumbnails/valid_800x600.png')
      expect(media.file_size?).to eq(true)
      expect(media.resolution?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.all?).to eq(true)
    end

    it 'valid webp format' do
      media = UvMediaValidator::TtThumbnail.new('test/tt_thumbnails/valid_800x600.webp')
      expect(media.file_size?).to eq(true)
      expect(media.resolution?).to eq(true)
      expect(media.format?).to eq(true)
      expect(media.all?).to eq(true)
    end

    it 'too small resolution' do
      media = UvMediaValidator::TtThumbnail.new('test/tt_thumbnails/small_320x240.jpg')
      expect(media.file_size?).to eq(true)
      expect(media.resolution?).to eq(false)
      expect(media.format?).to eq(true)
      expect(media.all?).to eq(false)
    end

    it 'oversized resolution' do
      media = UvMediaValidator::TtThumbnail.new('test/tt_thumbnails/oversized_1920x1920.jpg')
      expect(media.file_size?).to eq(true)
      expect(media.resolution?).to eq(false)
      expect(media.format?).to eq(true)
      expect(media.all?).to eq(false)
    end

    it 'invalid format (gif)' do
      media = UvMediaValidator::TtThumbnail.new('test/tt_thumbnails/invalid_format.gif')
      expect(media.file_size?).to eq(true)
      expect(media.resolution?).to eq(true)
      expect(media.format?).to eq(false)
      expect(media.all?).to eq(false)
    end
  end
end
