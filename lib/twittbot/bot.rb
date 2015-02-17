require 'fileutils'
require 'yaml'

require 'twittbot/defaults'

module Twittbot
  class Bot
    def initialize(options = {})
      @options = {
          current_dir: FileUtils.pwd
      }.merge!(options)

      @config = YAML.load_file File.expand_path("./#{Twittbot::CONFIG_FILE_NAME}", @options[:current_dir])

      load_bot_code
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