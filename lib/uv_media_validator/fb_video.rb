require 'image_size'

module UvMediaValidator
  # https://developers.facebook.com/docs/graph-api/video-uploads?locale=ja_JP
  class FbVideo
    MAX_SYNC_SIZE = 1_000_000_000
    MAX_ASYNC_SIZE = 10_000_000_000
    MAX_SYNC_DURATION = 1200.0
    MAX_ASYNC_DURATION = 3600.0 * 4.0
    MAX_ASPECT_RATIO = 16.0 / 9.0
    FORMAT_ARRAY = %i(3g2 3gp 3gpp asf avi dat divx dv f4v flv gif m2ts m4v mkv mod mov mp4 mpe mpeg mpeg4 mpg mts nsv ogm ogv qt tod ts vob wmv)

    def initialize(path, sync_flag: true, info: nil)
      @path = path
      @sync_flag = sync_flag
      @video_info = info
    end

    def max_size
      @sync_flag ? MAX_SYNC_SIZE : MAX_ASYNC_SIZE
    end

    def max_duration
      @sync_flag ? MAX_SYNC_DURATION : MAX_ASYNC_DURATION
    end

    def video_info
      @video_info ||= FFMPEG::Movie.new(@path)
    end

    def file_size?
      max_size >= video_info.size
    end

    def duration?
      max_duration >= video_info.duration
    end

    def aspect_ratio?
      current_ratio = video_info.width > video_info.height ? 
        video_info.width.to_f / video_info.height.to_f : 
        video_info.height.to_f / video_info.width.to_f
      MAX_ASPECT_RATIO >= current_ratio
    end

    def format?
      !FORMAT_ARRAY.include?(File.extname(@path).gsub(/\./, '')).nil?
    end

    def all?
      file_size? &&
      duration? &&
      aspect_ratio? &&
      format?
    end
  end
end
