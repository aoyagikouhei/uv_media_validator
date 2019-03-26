require 'image_size'

module UvMediaValidator
  # https://developers.facebook.com/docs/graph-api/photo-uploads/
  class FbImage
    include UvMediaValidator::Validator::FileSize
    
    # 10Mb
    MAX_SIZE = 10 * 1024 * 1024
    
    FORMAT_ARRAY = %i(jpeg png gif bmp tiff)

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

    def format?
      FORMAT_ARRAY.include?(image_size.format)
    end

    def all?
      file_size? && format?
    end
  end
end
