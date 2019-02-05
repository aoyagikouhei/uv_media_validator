require 'image_size'

module UvMediaValidator
  # https://developer.twitter.com/en/docs/media/upload-media/uploading-media/media-best-practices
  class TwImage
    include UvMediaValidator::Validator::FileSize
    include UvMediaValidator::Validator::ViewSize

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

    def width
      image_size.w
    end

    def height
      image_size.h
    end

    def format?
      FORMAT_ARRAY.include?(image_size.format)
    end

    def all?
      file_size? && view_size? && format?
    end
  end
end
