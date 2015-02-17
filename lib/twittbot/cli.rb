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

    desc 'start', 'Starts the bot'
    def start
      require 'twittbot/bot'
      bot = Twittbot::Bot.new
      bot.start
    end

    desc 'generate TEMPLATE_NAME', 'Generates a template'
    def generate(template_name)
      require 'twittbot/generators/templates/template_generator'
      generator = Twittbot::Generators::TemplateGenerator.new template_name, options
      generator.create
    end
  end
end