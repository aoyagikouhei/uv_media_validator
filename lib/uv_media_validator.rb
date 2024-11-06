require "uv_media_validator/version"
require "uv_media_validator/validator/file_size"
require "uv_media_validator/validator/view_size"
require "uv_media_validator/tw_image"
require "uv_media_validator/tw_agif"
require "uv_media_validator/tw_video"
require "uv_media_validator/fb_image"
require "uv_media_validator/fb_video"
require "uv_media_validator/ig_image"
require "uv_media_validator/ig_video"
require "uv_media_validator/pin_image"
require "uv_media_validator/pin_video"

module UvMediaValidator
  class Error < StandardError; end

  def self.get_tw_validator(path, sync_flag: true)
    image_size = ImageSize.path(path)
    if image_size.format.nil?
      movie = FFMPEG::Movie.new(path)
      if movie.valid?
        return TwVideo.new(path, sync_flag: sync_flag, info: movie)
      else
        return nil
      end
    elsif image_size.format != :gif
      return TwImage.new(path, info: image_size)
    end
    gif_info = GifInfo::analyze_file(path)
    if gif_info.images_count > 1
      return TwAgif.new(path, info: gif_info)
    else
      return TwImage.new(path, info: image_size)
    end
  end

  def self.get_fb_validator(path, sync_flag: true, max_image_bytes: nil)
    image_size = ImageSize.path(path)
    if image_size.format.nil?
      movie = FFMPEG::Movie.new(path)
      if movie.valid?
        return FbVideo.new(path, sync_flag: sync_flag, info: movie)
      else
        return nil
      end
    else
      return FbImage.new(path, max_image_bytes: max_image_bytes, info: image_size)
    end
  end

  def self.get_ig_feed_validator(path, sync_flag: true, max_image_bytes: nil)
    image_size = ImageSize.path(path)

    return IgImage.new(path, max_image_bytes: max_image_bytes, info: image_size) unless image_size.format.nil?

    movie = FFMPEG::Movie.new(path)
    return nil unless movie.valid?

    IgVideo.new(path, sync_flag: sync_flag, info: movie)
  end

  def self.get_ig_reel_validator(path, sync_flag: true)
    image_size = ImageSize.path(path)

    # リールは動画のみ
    return nil unless image_size.format.nil?

    movie = FFMPEG::Movie.new(path)
    return nil unless movie.valid?

    IgReel.new(path, sync_flag: sync_flag, info: movie)
  end

  def self.get_ig_stories_validator(path, sync_flag: true, max_image_bytes: nil)
    image_size = ImageSize.path(path)
    return IgStoriesImage.new(path, max_image_bytes: max_image_bytes, info: image_size) unless image_size.format.nil?

    movie = FFMPEG::Movie.new(path)
    return nil unless movie.valid?

    IgStoriesVideo.new(path, sync_flag: sync_flag, info: movie)
  end

  def self.get_pin_validator(path, max_image_bytes: nil)
    image_size = ImageSize.path(path)
    return PinImage.new(path, max_image_bytes: max_image_bytes, info: image_size) unless image_size.format.nil?

    movie = FFMPEG::Movie.new(path)
    return nil unless movie.valid?

    PinVideo.new(path, info: movie)
  end
end
