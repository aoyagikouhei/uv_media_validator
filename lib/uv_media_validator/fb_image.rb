require 'image_size'

module UvMediaValidator
  # https://developers.facebook.com/docs/graph-api/photo-uploads/
  class FbImage
    FORMAT_ARRAY = %i(jpeg png gif bmp tiff)

    def initialize(path, info: nil)
      @path = path
      @image_size = info
    end

    def image_size
      @image_size ||= ImageSize.path(@path)
    end

    def format?
      !FORMAT_ARRAY.include?(image_size.format).nil?
    end

    def all?
      format?
    end
  end
end
