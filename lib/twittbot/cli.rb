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

    desc 'auth', 'authorizes with Twitter'
    def auth
      require 'twittbot/bot'
      bot = Twittbot::Bot.new
      bot.auth
    end

    desc 'start', 'Starts the bot'
    def start
      require 'twittbot/bot'
      bot = Twittbot::Bot.new
      bot.start
    end

    desc 'cron TASK_NAME', 'Runs the task TASK_NAME, useful for calling from cron'
    def cron(task_name)
      require 'twittbot/bot'
      bot = Twittbot::Bot.new(save_config: false)
      bot.cron(task_name.downcase.to_sym)
    end

    desc 'generate TEMPLATE_NAME', 'Installs a template'
    def generate(template_name)
      require 'twittbot/generators/templates/template_generator'
      generator = Twittbot::Generators::TemplateGenerator.new template_name, options
      generator.create
    end

    desc 'list-templates', 'Lists all templates'
    def list_templates
      require 'twittbot/template_lister'
      lister = Twittbot::TemplateLister.new options
      lister.list
    end

    desc 'add-admin USER_NAME', 'Adds an user to the botadmin list'
    def add_admin(user_name)
      require 'twittbot/bot'
      bot = Twittbot::Bot.new
      bot.modify_admin(user_name, :add)
    end

    desc 'del-admin USER_NAME', 'Removes an user from the botadmin list'
    def del_admin(user_name)
      require 'twittbot/bot'
      bot = Twittbot::Bot.new
      bot.modify_admin(user_name, :delete)
    end
  end
end
