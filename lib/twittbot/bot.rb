require 'fileutils'
require 'yaml'
require 'twitter'

require 'twittbot/defaults'
require 'twittbot/botpart'
require 'twittbot/gem_ext/twitter'

module Twittbot
  # Class providing the streaming connections and callback logic for the bot.
  class Bot

    include Thor::Shell

    def initialize(options = {})
      @options = {
          current_dir: FileUtils.pwd
      }

      $bot = {
          callbacks: {},
          config: YAML.load_file(File.expand_path("./#{Twittbot::CONFIG_FILE_NAME}", @options[:current_dir])),
          periodic: []
      }.merge!(options)

      load_bot_code
    end

    # Authenticates an account with Twitter.
    def auth
      require 'oauth'
      say "This will reset your current access tokens.", :red if already_authed?

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

    # Starts the bot.
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
        puts "connected to user stream"
        @streamer.user do |obj|
          handle_stream_object obj, :user
        end
        puts "lost user stream connection"
      end

      @tweetstream_thread ||= Thread.new do
        puts "connected to tweet stream"
        @streamer.filter track: $bot[:config][:track].join(",") do |obj|
          handle_stream_object obj, :filter
        end
        puts "lost tweet stream connection"
      end

      @periodic_thread ||= Thread.new do
        loop do
          do_periodic
          sleep 60
        end
      end

      @userstream_thread.join
      @tweetstream_thread.join
      @periodic_thread.join
    end

    # Loads the bot's actual code which is stored in the bot's +lib+
    # subdirectory.
    def load_bot_code
      files = Dir["#{File.expand_path('./lib', @options[:current_dir])}/**/*"]
      files.each do |file|
        require_relative file.sub(/\.rb$/, '') if file.end_with? '.rb'
      end
    end

    # Saves the bot's config (i.e. not the botpart ones).
    def save_config
      config = $bot[:config].clone
      config.delete :client
      File.open "./#{Twittbot::CONFIG_FILE_NAME}", 'w' do |f|
        f.write config.to_yaml
      end
    end

    # Checks some configuration values, e.g. if the bot is already authenticated with Twitter
    def check_config
      unless already_authed?
        say "Please authenticate using `twittbot auth' first.", :red
        raise 'Not authenticated'
      end
    end

    # Handles a object yielded from a Twitter::Streaming::Client.
    # @param object [Object] The object yielded from a Twitter::Streaming::Client connection.
    # @param type [Symbol] The type of the streamer.  Should be either :user or :filter.
    def handle_stream_object(object, type)
      opts = {
          stream_type: type
      }
      case object
        when Twitter::Streaming::FriendList
          # object: Array with IDs
          do_callbacks :friend_list, object
        when Twitter::Tweet
          # object: Twitter::Tweet
          is_mention = (object.user.screen_name != $bot[:config][:screen_name] and object.text.include?("@" + $bot[:config][:screen_name]) and not object.retweet?)
          do_callbacks :retweet, object, opts if object.retweet? and object.retweeted_tweet.user.screen_name == $bot[:config][:screen_name]
          do_callbacks :mention, object, opts if is_mention
          do_callbacks :tweet, object, opts.merge({ mention: is_mention, retweet: object.retweet? })
        when Twitter::Streaming::Event
          case object.name
            when :follow
              # object: Twitter::Streaming::Event(name: :follow, source: Twitter::User, target: Twitter::User)
              do_callbacks :follow, object, opts
            else
              puts "no handler for #{object.class.to_s}/#{object.name}\n  -- object data:"
              require 'pp'
              pp object
              do_callbacks object.name, object, opts
          end
        else
          puts "no handler for #{object.class.to_s}\n  -- object data:"
          require 'pp'
          pp object
      end
    end

    # Runs callbacks.
    # @param callback_type [:Symbol] The callback type.
    # @param object [Object] The object
    def do_callbacks(callback_type, object, options = {})
      $bot[:callbacks][callback_type][:block].call object, options unless $bot[:callbacks][callback_type].nil?
    end

    def do_periodic
      $bot[:periodic].each_with_index do |h, i|
        h[:remaining] = if h[:remaining] == 0
                          h[:block].call
                          h[:interval]
                        else
                          h[:remaining] - 1
                        end
        $bot[:periodic][i] = h
      end
    end

    # @return [Boolean] whether the bot is already authenticated or not.
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
