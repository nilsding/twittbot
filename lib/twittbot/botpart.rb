require 'twittbot/defaults'
require 'pp'

module Twittbot
  class BotPart
    def initialize(name, &block)
      botpart_config_path = File.expand_path("./etc/#{name}.yml")
      @config = $bot[:config].merge(if File.exist? botpart_config_path
                                      YAML.load_file botpart_config_path
                                    else
                                      {}
                                    end)
      instance_eval &block
    end

    def on(name, *args, &block)
      $bot[:callbacks][name] ||= {
          args: args,
          block: block
      }
    end
  end
end