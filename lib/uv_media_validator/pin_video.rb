# frozen_string_literal: true

require 'streamio-ffmpeg'

module UvMediaValidator
  # PinterestのVIDEO用のバリデータ
  class PinVideo
    include UvMediaValidator::Validator::FileSize
    include UvMediaValidator::Validator::ViewSize

    # APIの制限はAdsの仕様はこちらだが、リリース直後は少なめでいく。
    # https://help.pinterest.com/en/business/article/pinterest-product-specs
    # 基本的に、VIDEOは実際にバリデーションの段階で、実際にアップロードするので、
    # 最悪その時点で投稿できない動画であるかどうかは判明する。

    FORMAT_ARRAY = %i(mp4 mov m4v)
    MAX_SIZE = 200 * 1024 * 1024 # 2000Mb
    MIN_WIDTH = 100
    MIN_HEIGHT = 100
    MAX_WIDTH = 1920
    MAX_HEIGHT = 1920
    # MAX_FRAME_RATE 不明
    MIN_DURATION = 4.0 # 画面の仕様に準じた
    MAX_DURATION = 900.0 # 画面の仕様に準じた
    MAX_ASPECT_RATIO = 1.91 / 1.0 # adsの仕様に準じた
    MIN_ASPECT_RATIO = 1.0 / 2.0  # adsの仕様に準じた
    VIDEO_CODEC_ARRAY = %w[hevc h264].freeze
    # 以下、観点としてコメントアウトして残しておく。
    # COLORSPACE_ARRAY = %w(yuv420p yuvj420p) Twitterではこの概念があるが、Pinterestでは不明
    # AUDIO_CODEC_ARRAY adsの仕様にあるが、どこまで対応する需要があるかどうか不明なので、今回は対応しない。
    # AUDIO_CODEC_PROFILE_ARRAY 同上
    # AUDIO_CHANNLES_ARRAY 同上
    # MAX_BITRATE 不明

    def initialize(path, info: nil)
      @path = path
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

    def width
      video_info.width
    end

    def height
      video_info.height
    end

    def format?
      FORMAT_ARRAY.include?(File.extname(@path).gsub(/\./, '').downcase.to_sym)
    end

    def duration?
      MIN_DURATION <= video_info.duration && video_info.duration <= MAX_DURATION
    end

    def aspect_ratio?
      MIN_ASPECT_RATIO <= width.to_f / height &&
        width.to_f / height <= MAX_ASPECT_RATIO
    end

    def video_codec?
      VIDEO_CODEC_ARRAY.include?(video_info.video_codec)
    end

    def all?
      format? &&
        file_size? &&
        view_size? &&
        duration? &&
        aspect_ratio? &&
        video_codec?
    end
  end
end
