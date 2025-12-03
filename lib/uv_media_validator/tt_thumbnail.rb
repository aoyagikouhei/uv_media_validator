require 'image_size'

module UvMediaValidator
  # TikTok thumbnail validator (for video posts)
  # https://ads.tiktok.com/help/article/tiktok-creative-specs
  class TtThumbnail
    include UvMediaValidator::Validator::FileSize
    include UvMediaValidator::Validator::ViewSize

    # 20MB
    MAX_SIZE = 20 * 1024 * 1024

    # 最小解像度
    MIN_WIDTH = 360
    MIN_HEIGHT = 360

    # 縦型最大解像度
    PORTRAIT_MAX_WIDTH = 1080
    PORTRAIT_MAX_HEIGHT = 1920

    # 横型最大解像度
    LANDSCAPE_MAX_WIDTH = 1920
    LANDSCAPE_MAX_HEIGHT = 1080

    FORMAT_ARRAY = %i(jpg jpeg webp png)

    def initialize(path, info: nil)
      @path = path
      @image_size = info
    end

    def image_size
      @image_size ||= ImageSize.path(@path)
    end

    def max_size
      MAX_SIZE
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

    def min_width?
      width >= MIN_WIDTH
    end

    def min_height?
      height >= MIN_HEIGHT
    end

    def resolution?
      # 最小解像度のチェック
      return false unless min_width? && min_height?

      # 縦型または横型のいずれかの解像度制限に収まっているかチェック
      portrait_valid = width <= PORTRAIT_MAX_WIDTH && height <= PORTRAIT_MAX_HEIGHT
      landscape_valid = width <= LANDSCAPE_MAX_WIDTH && height <= LANDSCAPE_MAX_HEIGHT
      portrait_valid || landscape_valid
    end

    def all?
      file_size? && resolution? && format?
    end
  end
end
