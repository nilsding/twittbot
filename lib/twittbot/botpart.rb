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

    # Runs +block+ every +interval+ +unit+(s).
    # @param interval [Fixnum]
    # @param unit [Symbol] the time unit.
    #   Can be one of:
    #
    #   * :minute or :minutes
    #   * :hour or :hours
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean] :run_at_start (true) Run the code in +block+ when the bot finished starting.
    def every(interval, unit = :minutes, options = {}, &block)
      raise "Not a Fixnum: #{interval}" unless interval.is_a? Fixnum
      raise "Interval less than 1" if interval < 1

      opts = {
          run_at_start: true
      }.merge(options)

      case unit
        when :min, :mins, :minute, :minutes
        when :hr, :hrs, :hour, :hours, :horse
          interval *= 60
        else
          raise "Unknown unit: #{unit}"
      end
      $bot[:periodic] << {
          interval: interval,
          remaining: opts[:run_at_start] ? 0 : interval,
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