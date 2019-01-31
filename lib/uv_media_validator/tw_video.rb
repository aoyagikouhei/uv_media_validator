require 'streamio-ffmpeg'

module UvMediaValidator
  # https://developer.twitter.com/en/docs/media/upload-media/uploading-media/media-best-practices
  class TwVideo
    MAX_SYNC_SIZE = 15_000_000
    MAX_ASYNC_SIZE = 512_000_000
    MIN_WIDTH = 32
    MIN_HEIGHT = 32
    MAX_WIDTH = 1280
    MAX_HEIGHT = 1024
    MAX_FRAME_RATE = 60.0
    MIN_DURATION = 0.5
    MAX_DURATION = 140.0
    MAX_ASPECT_RATIO = 3.0
    COLORSPACE_ARRAY = %w(yuv420p yuvj420p)
    AUDIO_CODEC_ARRAY = [nil, 'aac']
    AUDIO_CHANNLES_ARRAY = [nil, 1, 2]

    def initialize(path, sync_flag: true, info: nil)
      @path = path
      @sync_flag = sync_flag
      @video_info = info
    end

    def max_size
      @sync_flag ? MAX_SYNC_SIZE : MAX_ASYNC_SIZE
    end

    def video_info
      @video_info ||= FFMPEG::Movie.new(@path)
    end
    
    def file_size?
      max_size >= video_info.size
    end

    def width?
      MIN_WIDTH <= video_info.width && video_info.width <= MAX_WIDTH
    end

    def height?
      MIN_WIDTH <= video_info.height && video_info.height <= MAX_WIDTH
    end

    def frame_rate?
      MAX_FRAME_RATE >= video_info.frame_rate
    end

    def duration?
      MIN_DURATION <= video_info.duration && video_info.duration <= MAX_DURATION
    end

    def aspect_ratio?
      current_ratio = video_info.width > video_info.height ? 
        video_info.width.to_f / video_info.height.to_f : 
        video_info.height.to_f / video_info.width.to_f
      MAX_ASPECT_RATIO >= current_ratio
    end

    def colorspace?
      !COLORSPACE_ARRAY.include?(video_info.colorspace).nil?
    end

    def audio_codec?
      !AUDIO_CODEC_ARRAY.include?(video_info.audio_codec).nil?
    end

    def audio_channels?
      !AUDIO_CHANNLES_ARRAY.include?(video_info.audio_channels).nil?
    end

    def all?
      file_size? && 
      width? && 
      height? && 
      frame_rate? && 
      duration? && 
      aspect_ratio? && 
      colorspace? &&
      audio_codec? &&
      audio_channels?
    end
  end
end
