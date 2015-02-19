require 'fileutils'
require 'yaml'

require 'twittbot/defaults'
require 'twittbot/botpart'

module Twittbot
  class Bot
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
      puts "This will reset your current access tokens." unless $bot[:config][:access_token].empty? or $bot[:config][:access_token_secret].empty?
      # TODO: actually authenticate with Twitter
    end

    def start; end

    def load_bot_code
      files = Dir["#{File.expand_path('./lib', @options[:current_dir])}/**/*"]
      files.each do |file|
        require_relative file.sub(/\.rb$/, '') if file.end_with? '.rb'
      end
    end
  end
end
