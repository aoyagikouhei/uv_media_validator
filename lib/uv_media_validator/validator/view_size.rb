module UvMediaValidator::Validator
  module ViewSize
    def view_size?
      width? && height?
    end

    # width

    def width
      raise "not implements"
    end

    def max_width
      self::class::MAX_WIDTH
    end

    def min_width
      self::class::MIN_WIDTH
    end

    def max_width?
      width <= max_width
    end

    def min_width?
      width >= min_width
    end

    def width?
      max_width? && min_width?
    end

    # height

    def hegiht
      raise "not implements"
    end

    def max_height
      self::class::MAX_HEIGHT
    end

    def min_height
      self::class::MIN_HEIGHT
    end

    def max_height?
      height <= max_height
    end

    def min_height?
      height >= min_height
    end

    def height?
      max_height? && min_height?
    end

    # aspect ratio

    def max_aspect_ratio
      self::class::MAX_ASPECT_RATIO
    end

    def aspect_ratio
      width > height ? 
        width.to_f / height.to_f : 
        height.to_f / width.to_f
    end

    def aspect_ratio?
      aspect_ratio <= max_aspect_ratio
    end
  end
end