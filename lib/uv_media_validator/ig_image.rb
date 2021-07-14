require 'image_size'

module UvMediaValidator
  # https://developers.facebook.com/docs/instagram-api/reference/ig-user/media
  class IgImage
    include UvMediaValidator::Validator::FileSize
    include UvMediaValidator::Validator::ViewSize

    # 8MiB
    MAX_SIZE = 8 * 1000 * 1000

    MIN_ASPECT_RATIO = 4.fdiv(5)
    MAX_ASPECT_RATIO = 1.91.fdiv(1.0)

    MIN_WIDTH = 1
    MAX_WIDTH = 1440

    MIN_HEIGHT = 1
    MAX_HEIGHT = MAX_WIDTH.fdiv(MIN_ASPECT_RATIO)

    FORMAT_ARRAY = %i(jpeg jpg)

    def initialize(path, max_image_bytes: nil, info: nil)
      @path = path
      @max_image_bytes = max_image_bytes
      @image_size = info
    end

    def image_size
      @image_size ||= ImageSize.path(@path)
    end

    def max_size
      @max_image_bytes || MAX_SIZE
    end

    def file_size
      @file_size ||= FileTest.size?(@path)
    end

    def width
      image_size.w
    end

    def height
      image_size.h
    end

    def format?
      FORMAT_ARRAY.include?(@image_size.format)
    end

    def aspect_ratio?
      (MIN_ASPECT_RATIO..MAX_ASPECT_RATIO).include?(width.fdiv(height))
    end

    def all?
      file_size? && max_height? && max_width? && aspect_ratio? && format?
    end
  end
end
