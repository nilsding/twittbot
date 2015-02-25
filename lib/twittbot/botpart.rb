require 'twittbot/defaults'
require 'pp'

module Twittbot
  class BotPart
    # @param name [Symbol] The name of the botpart.  Should be the same as the file name without the extension.
    def initialize(name, &block)
      botpart_config_path = File.expand_path("./etc/#{name}.yml")
      @config = $bot[:config].merge(if File.exist? botpart_config_path
                                      YAML.load_file botpart_config_path
                                    else
                                      {}
                                    end)
      instance_eval &block
    end

    # Adds a new callback to +name+.
    # @param name [Symbol] The callback type.
    #   Can be (at least) one of:
    #
    #   * :tweet
    #   * :mention
    #   * :retweet
    #   * :favorite
    #   * :friend_list
    def on(name, *args, &block)
      $bot[:callbacks][name] ||= {
          args: args,
          block: block
      }
    end

    # @return [Twitter::REST::Client]
    def client
      $bot[:client]
    end
    alias bot client
  end
end