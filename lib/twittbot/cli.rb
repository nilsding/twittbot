require 'thor'

require 'twittbot/defaults'

module Twittbot
  class CLI < Thor
    desc 'new APP_NAME', 'Creates a new Twittbot application.'
    method_option :template_dir, type: :string, aliases: '-t', desc: 'Specifies the template directory to use', default: Twittbot::TEMPLATE_DIR
    def new(app_name)
      require 'twittbot/generators/twittbot/app/app_generator'
      generator = Twittbot::Generators::AppGenerator.new app_name, options
      generator.create
    end
  end
end