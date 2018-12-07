# frozen_string_literal: true

require_relative '../settings'
require_relative '../object_store_settings'

# load and fill some application settings

#
# Uploads
#
Settings['uploads'] ||= Settingslogic.new({})

Settings.uploads['base_dir']      = Settings.uploads['base_dir'] || 'uploads/-/system'
Settings.uploads['storage_path']  = Settings.absolute(Settings.uploads['storage_path'] || 'public')

Settings.uploads['object_store'] = ObjectStoreSettings.parse(Settings.uploads['object_store'])
Settings.uploads['object_store']['remote_directory'] ||= 'uploads'

#
# Booky
#
Settings['booky'] ||= Settingslogic.new({})
Settings.booky['relative_url_root'] ||= ENV['RAILS_RELATIVE_URL_ROOT'] || ''
Settings.booky['protocol']          ||= Settings.booky.https ? 'https' : 'http'
Settings.booky['base_url']          ||= Settings.__send__(:build_base_booky_url)

#
# Gravatar
#
Settings['gravatar'] ||= Settingslogic.new({})

Settings.gravatar['enabled'] = true if Settings.gravatar['enabled'].nil?

Settings.gravatar['plain_url']  ||= 'https://www.gravatar.com/avatar/%{hash}?s=%{size}&d=identicon'
Settings.gravatar['ssl_url']    ||= 'https://secure.gravatar.com/avatar/%{hash}?s=%{size}&d=identicon'
Settings.gravatar['host']         = Settings.host_without_www(Settings.gravatar['plain_url'])
