require 'fileutils'
require 'yaml'
require 'twitter'

require 'twittbot/defaults'
require 'twittbot/botpart'
require 'twittbot/gem_ext/twitter'

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
      say "This will reset your current access tokens." unless already_authed?

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

      # get the bot's user name (screen_name) and print it to the console
      $bot[:config][:screen_name] = get_screen_name access_token
      puts "Hello, #{$bot[:config][:screen_name]}!"

      save_config
    end

    def start
      check_config
      $bot[:client] ||= Twitter::REST::Client.new do |cfg|
        cfg.consumer_key        = $bot[:config][:consumer_key]
        cfg.consumer_secret     = $bot[:config][:consumer_secret]
        cfg.access_token        = $bot[:config][:access_token]
        cfg.access_token_secret = $bot[:config][:access_token_secret]
      end

      @streamer ||= Twitter::Streaming::Client.new do |cfg|
        cfg.consumer_key        = $bot[:config][:consumer_key]
        cfg.consumer_secret     = $bot[:config][:consumer_secret]
        cfg.access_token        = $bot[:config][:access_token]
        cfg.access_token_secret = $bot[:config][:access_token_secret]
      end

      @userstream_thread ||= Thread.new do
        @streamer.user do |obj|
          handle_stream_object obj, :user
        end
      end

      @userstream_thread.join
    end

    def load_bot_code
      files = Dir["#{File.expand_path('./lib', @options[:current_dir])}/**/*"]
      files.each do |file|
        require_relative file.sub(/\.rb$/, '') if file.end_with? '.rb'
      end
    end

    def save_config
      config = $bot[:config].clone
      config.delete :client
      File.open "./#{Twittbot::CONFIG_FILE_NAME}", 'w' do |f|
        f.write config.to_yaml
      end
    end

    def check_config
      unless already_authed?
        say "Please authenticate using `twittbot auth' first."
        raise 'Not authenticated'
      end
    end

    def handle_stream_object(object, _type)
      case object
        when Twitter::Tweet
          do_callbacks :tweet, object
        else
          puts "no handler for #{object.class.to_s}"
      end
    end

    def do_callbacks(callback_type, object)
      $bot[:callbacks][callback_type][:block].call object
    end

    def already_authed?
      !($bot[:config][:access_token].empty? or $bot[:config][:access_token_secret].empty?)
    end

    private

    def get_screen_name(access_token)
      oauth_response = access_token.get('/1.1/account/verify_credentials.json?skip_status=true')
      oauth_response.body.match(/"screen_name"\s*:\s*"(.*?)"/).captures.first
    end
  end
end
