# frozen_string_literal: true

# GravatarGenerator
#
#   Used to generate gravatar in case if avatar is not set
#
class GravatarGenerator
  attr_reader :gravatar_config
  attr_reader :booky_config

  def initialize
    @gravatar_config = Booky.config.gravatar
    @booky_config = Booky.config.booky
  end

  def execute(email, size = nil, scale = 2, username: nil)
    identifier = email.presence || username.presence
    return unless identifier

    hash = Digest::MD5.hexdigest(identifier.strip.downcase)
    size = 40 unless size&.positive?

    format resolve_gravatar_url,
           hash: hash,
           size: size * scale,
           email: encode(email),
           username: encode(username)
  end

  private

  def resolve_gravatar_url
    ssl_enabled? ? gravatar_config.ssl_url : gravatar_config.plain_url
  end

  def ssl_enabled?
    booky_config.https
  end

  def encode(text)
    ERB::Util.url_encode(text&.strip || '')
  end
end
