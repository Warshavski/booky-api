require 'settingslogic'

class Settings < Settingslogic
  source ENV.fetch('BOOKY_CONFIG') { Pathname.new(File.expand_path('..', __dir__)).join('config/booky.yml') }
  namespace ENV.fetch('BOOKY_ENV') { Rails.env }

  def self.absolute(path)
    File.expand_path(path, Rails.root)
  end
end
