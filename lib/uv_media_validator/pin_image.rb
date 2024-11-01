require 'image_size'

module UvMediaValidator
  # Pinterestの画像のバリデータ
  class PinImage
    include UvMediaValidator::Validator::FileSize
    include UvMediaValidator::Validator::ViewSize

    MAX_SIZE = 20 * 1024 * 1024 # 20Mb
    FORMAT_ARRAY = %i(bmp jpeg png tiff webp)
    MIN_WIDTH = 200
    MAX_WIDTH = 9038
    MIN_HEIGHT = 300
    MAX_HEIGHT = 9900

    def initialize(path, info: nil)
      @path = path
      @image_size = info
    end

    def max_width
      MAX_WIDTH
    end

    def min_width
      MIN_WIDTH
    end

    def max_height
      MAX_HEIGHT
    end

    def min_height
      MIN_HEIGHT
    end

    def max_size
      MAX_SIZE
    end

    def width
      image_size.width
    end

    def height
      image_size.height
    end

    def image_size
      @image_size ||= ImageSize.path(@path)
    end

    def file_size
      @file_size ||= FileTest.size?(@path)
    end

    def format?
      FORMAT_ARRAY.include?(image_size.format)
    end

    def all?
      file_size? &&
        format? &&
        view_size?
    end
  end
end
