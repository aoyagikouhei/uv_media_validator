require 'image_size'

module UvMediaValidator
  # https://developer.twitter.com/en/docs/media/upload-media/uploading-media/media-best-practices
  class TwImage
    include UvMediaValidator::Validator::FileSize
    include UvMediaValidator::Validator::ViewSize

    # 5Mb
    MAX_SIZE = 5 * 1024 * 1024

    MIN_WIDTH = 4
    MIN_HEIGHT = 4
    MAX_WIDTH = 2048
    MAX_HEIGHT = 2048
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
