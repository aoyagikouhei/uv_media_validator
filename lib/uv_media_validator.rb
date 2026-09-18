require "uv_media_validator/version"
require "uv_media_validator/validator/file_size"
require "uv_media_validator/validator/view_size"
require "uv_media_validator/validator/exif_orientation"
require "uv_media_validator/validator/video_rotation"
require "uv_media_validator/tw_image"
require "uv_media_validator/tw_agif"
require "uv_media_validator/tw_video"
require "uv_media_validator/fb_image"
require "uv_media_validator/fb_video"
require "uv_media_validator/ig_image"
require "uv_media_validator/ig_video"
require "uv_media_validator/pin_image"
require "uv_media_validator/pin_video"
require "uv_media_validator/tt_image"
require "uv_media_validator/tt_video"
require "uv_media_validator/tt_thumbnail"

module UvMediaValidator
  class Error < StandardError; end

  SVG_DOCUMENT_PREFIX = /\A(?:\xEF\xBB\xBF)?\s*(?:(?:<\?.*?\?>|<!--.*?-->|<!DOCTYPE.*?>)\s*)*<svg\b/min.freeze
  STATIC_ISO_BMFF_IMAGE_BRANDS = %w[
    1pic avif avio heic heix heim heis mif1 mif2
  ].freeze
  ISO_BMFF_IMAGE_SEQUENCE_BRANDS = %w[
    avis hevc hevm hevs hevx msf1
  ].freeze
  MAX_FTYP_BOX_SIZE = 4096
  private_constant :SVG_DOCUMENT_PREFIX,
    :STATIC_ISO_BMFF_IMAGE_BRANDS,
    :ISO_BMFF_IMAGE_SEQUENCE_BRANDS,
    :MAX_FTYP_BOX_SIZE

  def self.get_tw_validator(path, sync_flag: true)
    image_size, movie = media_info(path)
    return TwVideo.new(path, sync_flag: sync_flag, info: movie) unless movie.nil?
    return nil if image_size.format.nil?

    if image_size.format != :gif
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
    image_size, movie = media_info(path)
    return FbVideo.new(path, sync_flag: sync_flag, info: movie) unless movie.nil?
    return nil if image_size.format.nil?

    FbImage.new(path, max_image_bytes: max_image_bytes, info: image_size)
  end

  def self.get_ig_feed_validator(path, sync_flag: true, max_image_bytes: nil)
    image_size, movie = media_info(path)
    return IgVideo.new(path, sync_flag: sync_flag, info: movie) unless movie.nil?
    return nil if image_size.format.nil?

    IgImage.new(path, max_image_bytes: max_image_bytes, info: image_size)
  end

  def self.get_ig_reel_validator(path, sync_flag: true, max_bytes: nil)
    _image_size, movie = media_info(path)
    return nil if movie.nil?

    IgReel.new(path, sync_flag: sync_flag, info: movie, max_bytes: max_bytes)
  end

  def self.get_ig_stories_validator(path, sync_flag: true, max_image_bytes: nil)
    image_size, movie = media_info(path)
    return IgStoriesVideo.new(path, sync_flag: sync_flag, info: movie) unless movie.nil?
    return nil if image_size.format.nil?

    IgStoriesImage.new(path, max_image_bytes: max_image_bytes, info: image_size)
  end

  def self.get_pin_validator(path, format: nil)
    image_size, movie = media_info(path)
    return PinVideo.new(path, info: movie) unless movie.nil?
    return nil if image_size.format.nil?

    PinImage.new(path, info: image_size, format: format)
  end

  def self.get_tt_validator(path, sync_flag: true)
    image_size, movie = media_info(path)
    return TtVideo.new(path, sync_flag: sync_flag, info: movie) unless movie.nil?
    return nil if image_size.format.nil?

    TtImage.new(path, info: image_size)
  end

  def self.get_tt_thumbnail_validator(path)
    image_size, movie = media_info(path)
    return nil unless movie.nil?
    return nil if image_size.format.nil?

    TtThumbnail.new(path, info: image_size)
  end

  def self.media_info(path)
    image_size = ImageSize.path(path)
    # image_size 2.1.2 searches for <svg anywhere near the start of the file.
    # Probe non-document SVG matches as video before trusting that result.
    should_probe_video = image_size.format.nil? ||
      (image_size.format == :svg &&
        !svg_document?(path) &&
        !static_iso_bmff_image?(path))
    return [image_size, nil] unless should_probe_video

    movie = FFMPEG::Movie.new(path)
    return [image_size, movie] if movie.valid?

    [image_size, nil]
  end
  private_class_method :media_info

  def self.svg_document?(path)
    File.open(path, "rb") do |file|
      file.read(4096).match?(SVG_DOCUMENT_PREFIX)
    end
  end
  private_class_method :svg_document?

  def self.static_iso_bmff_image?(path)
    File.open(path, "rb") do |file|
      header = file.read(16)
      return false unless !header.nil? && header.bytesize == 16 && header[4, 4] == "ftyp"

      box_size = header[0, 4].unpack1("N")
      return false unless box_size.between?(16, MAX_FTYP_BOX_SIZE)
      return false unless ((box_size - 16) % 4).zero?

      compatible_bytes = file.read(box_size - 16)
      return false unless !compatible_bytes.nil? && compatible_bytes.bytesize == box_size - 16

      compatible_brands = compatible_bytes.unpack("a4" * (compatible_bytes.bytesize / 4))
      brands = [header[8, 4], *compatible_brands]

      STATIC_ISO_BMFF_IMAGE_BRANDS.include?(brands.first) &&
        (brands & ISO_BMFF_IMAGE_SEQUENCE_BRANDS).empty?
    end
  end
  private_class_method :static_iso_bmff_image?
end
