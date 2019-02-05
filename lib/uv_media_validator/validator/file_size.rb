module UvMediaValidator::Validator
  module FileSize
    def max_size
      self::class::MAX_SIZE
    end

    def file_size
      raise "not implements"
    end

    def file_size?
      file_size <= max_size
    end
  end
end