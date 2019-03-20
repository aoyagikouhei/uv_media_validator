require 'streamio-ffmpeg'

module UvMediaValidator
  # https://developer.twitter.com/en/docs/media/upload-media/uploading-media/media-best-practices
  class TwVideo
    include UvMediaValidator::Validator::FileSize
    include UvMediaValidator::Validator::ViewSize

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
    AUDIO_CODEC_PROFILE_ARRAY = [nil, 'LC']
    AUDIO_CHANNLES_ARRAY = [nil, 1, 2]
    MAX_BITRATE = 60_000_000

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

    def file_size
      video_info.size
    end

    def width
      video_info.width
    end

    def height
      video_info.height
    end

    def audio_codec_profile
      audio = video_info.metadata[:streams].select { |s| s[:codec_type] == 'audio' }.first
      audio.nil? ? nil : audio[:profile]
    end

    def frame_rate?
      MAX_FRAME_RATE >= video_info.frame_rate
    end

    def duration?
      MIN_DURATION <= video_info.duration && video_info.duration <= MAX_DURATION
    end

    def colorspace?
      COLORSPACE_ARRAY.include?(video_info.colorspace)
    end

    def audio_codec?
      AUDIO_CODEC_ARRAY.include?(video_info.audio_codec)
    end

    def audio_codec_profile?
      AUDIO_CODEC_PROFILE_ARRAY.include?(audio_codec_profile)
    end

    def audio_channels?
      AUDIO_CHANNLES_ARRAY.include?(video_info.audio_channels)
    end

    def bitrate?
      MAX_BITRATE >= video_info.bitrate
    end

    def all?
      file_size? && 
      view_size? && 
      frame_rate? && 
      duration? && 
      aspect_ratio? && 
      colorspace? &&
      audio_codec? &&
      audio_codec_profile? &&
      audio_channels? &&
      bitrate?
    end
  end
end
