require 'image_size'

module UvMediaValidator
  # TikTok video validator
  # https://business-api.tiktok.com/portal/docs?id=1762228496095234
  class TtVideo
    include UvMediaValidator::Validator::FileSize
    include UvMediaValidator::Validator::ViewSize

    FORMAT_ARRAY = %i(mp4 mov webm)
    MIN_FRAME_RATE = 23
    MAX_FRAME_RATE = 60
    MIN_WIDTH = 360
    MIN_HEIGHT = 360
    MAX_DURATION = 600  # 10分
    MIN_DURATION = 3
    MAX_SIZE = 1024 * 1024 * 1024  # 1GB

    def initialize(path, sync_flag: true, info: nil)
      @path = path
      @sync_flag = sync_flag
      @video_info = info
    end

    def max_size
      self.class::MAX_SIZE
    end

    def video_info
      @video_info ||= FFMPEG::Movie.new(@path)
    end

    def file_size
      video_info.size
    end

    def duration?
      (self.class::MIN_DURATION..self.class::MAX_DURATION).include?(video_info.duration)
    end

    def width
      video_info.width
    end

    def height
      video_info.height
    end

    def min_width?
      width >= self.class::MIN_WIDTH
    end

    def min_height?
      height >= self.class::MIN_HEIGHT
    end

    def format?
      self.class::FORMAT_ARRAY.include?(File.extname(@path).gsub(/\./, '').downcase.to_sym)
    end

    def frame_rate_range?
      (self.class::MIN_FRAME_RATE..self.class::MAX_FRAME_RATE).include?(video_info.frame_rate)
    end

    def all?
      file_size? &&
      duration? &&
      min_width? &&
      min_height? &&
      format? &&
      frame_rate_range?
    end
  end
end
