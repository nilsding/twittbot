module Twittbot
  # The version of Twittbot.
  VERSION = "0.3.0"

  CONSUMER_KEY = 'FYRuQcDbPAXAyVjuPZMuw' # :nodoc:
  CONSUMER_SECRET = 'KiLCYTftPdxNebl5DNcj7Ey2Y8YVZu7hfqiFRYkcg' # :nodoc:

  # Contains the path to the initial bot template.
  TEMPLATE_DIR = File.expand_path '../generators/twittbot/app/templates', __FILE__
  # The name of the bot's config file.
  CONFIG_FILE_NAME = 'config.yml'

  # Hash containing the default bot configuration.
  DEFAULT_BOT_CONFIG = {
    consumer_key: Twittbot::CONSUMER_KEY,
    consumer_secret: Twittbot::CONSUMER_SECRET,
    access_token: '',
    access_token_secret: '',
    track: [],
    admins: [],
    dm_command_prefix: '!'
  }

  # How many seconds should be waited until the bot reconnects
  RECONNECT_WAIT_TIME = 5
end