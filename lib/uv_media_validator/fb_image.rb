require 'image_size'

module UvMediaValidator
  # https://developers.facebook.com/docs/graph-api/reference/photo/
  class FbImage
    include UvMediaValidator::Validator::FileSize
    
    # 10Mb
    MAX_SIZE = 10 * 1024 * 1024
    
    FORMAT_ARRAY = %i(jpeg png gif bmp tiff)

    def initialize(path, max_image_bytes: nil, info: nil)
      @path = path
      @max_image_bytes = max_image_bytes
      @image_size = info
    end

    def max_size
      @max_image_bytes || MAX_SIZE
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
      file_size? && format?
    end
  end
end
