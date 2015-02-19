require 'fileutils'
require 'yaml'
require 'twitter'

require 'twittbot/defaults'
require 'twittbot/botpart'

module Twittbot
  class Bot

    include Thor::Shell

    def initialize(options = {})
      @options = {
          current_dir: FileUtils.pwd
      }

      $bot = {
          callbacks: {},
          config: YAML.load_file(File.expand_path("./#{Twittbot::CONFIG_FILE_NAME}", @options[:current_dir]))
      }.merge!(options)

      load_bot_code
    end

    def auth
      require 'oauth'
      say "This will reset your current access tokens." unless $bot[:config][:access_token].empty? or $bot[:config][:access_token_secret].empty?

      # get the request token URL
      callback = OAuth::OUT_OF_BAND
      consumer = OAuth::Consumer.new $bot[:config][:consumer_key],
                                     $bot[:config][:consumer_secret],
                                     site: Twitter::REST::Client::BASE_URL,
                                     scheme: :header
      request_token = consumer.get_request_token(oauth_callback: callback)
      url = request_token.authorize_url(oauth_callback: callback)

      puts "Open this URL in a browser: #{url}"
      pin = ''
      until pin =~ /^\d+$/
        print "Enter PIN =>"
        pin = $stdin.gets.strip
      end

      access_token = request_token.get_access_token(oauth_verifier: pin)
      $bot[:config][:access_token] = access_token.token
      $bot[:config][:access_token_secret] = access_token.secret

      save_config

      # get the bot's user name (screen_name) and print it to the console
      oauth_response = access_token.get('/1.1/account/verify_credentials.json?skip_status=true')
      screen_name = oauth_response.body.match(/"screen_name"\s*:\s*"(.*?)"/).captures.first
      puts "Hello, #{screen_name}!"
    end

    def start; end

    def load_bot_code
      files = Dir["#{File.expand_path('./lib', @options[:current_dir])}/**/*"]
      files.each do |file|
        require_relative file.sub(/\.rb$/, '') if file.end_with? '.rb'
      end
    end

    def save_config
      File.open "./#{Twittbot::CONFIG_FILE_NAME}", 'w' do |f|
        f.write $bot[:config].to_yaml
      end
    end
  end
end
