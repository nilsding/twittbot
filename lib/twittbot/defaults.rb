module Twittbot
  VERSION = "0.0.1"

  CONSUMER_KEY = 'FYRuQcDbPAXAyVjuPZMuw'
  CONSUMER_SECRET = 'KiLCYTftPdxNebl5DNcj7Ey2Y8YVZu7hfqiFRYkcg'

  TEMPLATE_DIR = File.expand_path '../generators/twittbot/app/templates', __FILE__
  CONFIG_FILE_NAME = 'config.yml'

  DEFAULT_BOT_CONFIG = {
    consumer_key: Twittbot::CONSUMER_KEY,
    consumer_secret: Twittbot::CONSUMER_SECRET,
    access_token: '',
    access_token_secret: '',
    track: []
  }
end