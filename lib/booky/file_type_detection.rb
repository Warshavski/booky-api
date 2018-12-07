# frozen_string_literal: true

module Booky
  # Booky::FileTypeDetection
  #
  #   File helpers methods.
  #   It needs the method filename to be defined.
  #
  module FileTypeDetection
    IMAGE_EXTENSIONS = %w[png jpg jpeg gif bmp tiff ico].freeze

    #
    # We recommend using the .mp4 format over .mov.
    # Videos in .mov format can still be used but you really need to make sure they are served with the
    # proper MIME type video/mp4 and not video/quicktime or your videos won't play on IE >= 9.
    #
    # http://archive.sublimevideo.info/20150912/docs.sublimevideo.net/troubleshooting.html
    #
    VIDEO_EXTENSIONS = %w[mp4 m4v mov webm ogv].freeze

    #
    # These extension types can contain dangerous code and should only be embedded inline with proper filtering.
    # They should always be tagged as "Content-Disposition: attachment", not "inline".
    #
    DANGEROUS_EXTENSIONS = %w[svg].freeze

    def image_or_video?
      image? || video?
    end

    def image?
      extension_match?(IMAGE_EXTENSIONS)
    end

    def video?
      extension_match?(VIDEO_EXTENSIONS)
    end

    def dangerous?
      extension_match?(DANGEROUS_EXTENSIONS)
    end

    private

    def extension_match?(extensions)
      filename ? extensions.include?(extension) : false
    end

    def extension
      File.extname(filename).delete('.').downcase
    end
  end
end
