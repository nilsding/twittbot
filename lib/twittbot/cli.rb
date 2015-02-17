require 'thor'

require 'twittbot/generators/twittbot/app/app_generator'

module Twittbot
  class CLI < Thor
    desc 'new APP_NAME', 'Creates a new Twittbot application.'
    method_option :template_dir, type: :string, aliases: '-t', desc: 'Specifies the template directory to use', default: Twittbot::Generators::AppGenerator::TEMPLATE_DIR
    def new(app_name)
      generator = Twittbot::Generators::AppGenerator.new app_name, options
      generator.create
    end
  end
end