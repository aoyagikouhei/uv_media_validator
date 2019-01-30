require 'image_size'

module UvMediaValidator
  # https://developer.twitter.com/en/docs/media/upload-media/uploading-media/media-best-practices
  class TwImage
    MAX_SIZE = 5_000_000
    MIN_WIDTH = 5
    MIN_HEIGHT = 5
    MAX_WIDTH = 8192
    MAX_HEIGHT = 8192
    FORMAT_ARRAY = %i(jpeg png gif webp)

    def initialize(path, info: nil)
      @path = path
      @image_size = info
    end

    def image_size
      @image_size ||= ImageSize.path(@path)
    end

    def file_size
      @file_size ||= FileTest.size?(@path)
    end

    def file_size?
      file_size <= MAX_SIZE
    end

    def width?
      MIN_WIDTH <= image_size.w && image_size.w <= MAX_WIDTH
    end

    def height?
      MIN_WIDTH <= image_size.h && image_size.h <= MAX_WIDTH
    end

    def format?
      !FORMAT_ARRAY.include?(image_size.format).nil?
    end

    def all?
      file_size? && width? && height? && format?
    end
  end
end
