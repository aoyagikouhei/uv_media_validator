require 'image_size'

module UvMediaValidator

  class IgVideo
    include UvMediaValidator::Validator::FileSize
    include UvMediaValidator::Validator::ViewSize

    FORMAT_ARRAY = %i(mp4 mov)
    AUDIO_CODEC = 'aac'
    MAX_AUDIO_SAMPLE_RATE = 48 * 1024
    MAX_AUDIO_CHANNELS = 2
    VIDEO_CODEC_ARRAY = ['hevc', 'h264']
    MIN_FRAME_RATE = 23
    MAX_FRAME_RATE = 60
    MIN_ASPECT_RATIO = 4.fdiv(5)
    MAX_ASPECT_RATIO = 16.fdiv(9)
    MAX_WIDTH = 1920
    MAX_HEIGHT = MAX_WIDTH.fdiv(MIN_ASPECT_RATIO)
    MAX_VIDEO_BITRATE = 5 * 1024 * 1024 # bps
    MAX_DURATION = 60
    MIN_DURATION = 3
    MAX_SIZE = 100 * 1024 * 1024 # Bytes

    def initialize(path, sync_flag: true, info: nil)
      @path = path
      @sync_flag = sync_flag
      @video_info = info
    end

    def max_size
      MAX_SIZE
    end

    def video_info
      @video_info ||= FFMPEG::Movie.new(@path)
    end

    def file_size
      video_info.size
    end

    def duration?
      (MIN_DURATION..MAX_DURATION).include?(video_info.duration)
    end

    def width
      video_info.width
    end

    def height
      video_info.height
    end

    def aspect_ratio?
      (MIN_ASPECT_RATIO..MAX_ASPECT_RATIO).include?(width.fdiv(height))
    end

    def format?
      FORMAT_ARRAY.include?(File.extname(@path).gsub(/\./, '').downcase.to_sym)
    end

    def audio_codec?
      if video_info.audio_codec.nil?
        false
      else
        video_info.audio_codec == AUDIO_CODEC
      end
    end

    def audio_sample_rate?
      if video_info.audio_sample_rate.nil?
        false
      else
        video_info.audio_sample_rate <= MAX_AUDIO_SAMPLE_RATE
      end
    end

    def audio_channels?
      if video_info.audio_channels.nil?
        false
      else
        video_info.audio_channels <= MAX_AUDIO_CHANNELS
      end
    end

    def video_codec?
      VIDEO_CODEC_ARRAY.include?(video_info.video_codec)
    end

    def video_bitrate?
      video_info.video_bitrate <= MAX_VIDEO_BITRATE
    end

    def frame_rate_range?
      (MIN_FRAME_RATE..MAX_FRAME_RATE).include?(video_info.frame_rate)
    end

    def all?
      file_size? &&
      duration? &&
      max_height? &&
      max_width? &&
      aspect_ratio? &&
      format? &&
      frame_rate_range? &&
      audio_codec? &&
      audio_sample_rate? &&
      audio_channels? &&
      video_codec? &&
      video_bitrate?
    end
  end
end
