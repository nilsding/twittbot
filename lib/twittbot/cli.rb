require "thor"

module Twittbot
  class CLI < Thor
    desc "new APP_NAME", "Creates a new Twittbot application."
    def new(app_name)
      require 'twittbot/generators/twittbot/app/app_generator'
      generator = Twittbot::Generators::AppGenerator.new app_name
      generator.create
    end
  end
end