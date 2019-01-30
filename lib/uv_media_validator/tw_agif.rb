require 'gif-info'

module UvMediaValidator
  # https://developer.twitter.com/en/docs/media/upload-media/uploading-media/media-best-practices
  class TwAgif
    MAX_SIZE = 15_000_000
    MIN_WIDTH = 5
    MIN_HEIGHT = 5
    MAX_WIDTH = 1280
    MAX_HEIGHT = 1080
    MAX_FRAMES = 350
    MAX_PIXELS = 300_000_000

    def initialize(path, info: nil)
      @path = path
      @gif_info = info
    end

    def file_size
      @file_size ||= FileTest.size?(@path)
    end

    def gif_info
      @gif_info ||= GifInfo::analyze_file(@path)
    end
    
    def file_size?
      file_size <= MAX_SIZE
    end

    def width?
      MIN_WIDTH <= gif_info.width && gif_info.width <= MAX_WIDTH
    end

    def height?
      MIN_HEIGHT <= gif_info.height && gif_info.height <= MAX_HEIGHT
    end

    def frames?
      MAX_FRAMES >= gif_info.images_count
    end

    def pixels?
      MAX_PIXELS >= gif_info.images_count * gif_info.width * gif_info.height
    end

    def all?
      file_size? && width? && height? && frames? && pixels?
    end
  end
end
