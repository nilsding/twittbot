require 'fileutils'
require 'erubis'
require 'yaml'

module Twittbot
  module Generators
    class AppGenerator
      include Thor::Shell

      TEMPLATE_DIR = File.expand_path '../templates', __FILE__

      def initialize(app_name, options = {})
        @options = {
            'template_dir' => TEMPLATE_DIR
        }.merge!(options)
        @app_name = app_name
        @options['template_dir'] = File.expand_path @options['template_dir']
      end

      def create
        path = File.expand_path "./#{@app_name}"
        if File.exist?(@app_name)
          say "#{File.directory?(@app_name) ? 'Directory' : 'File'} #{@app_name} already exists", :red
          exit 1
        end
        FileUtils.mkdir_p(path)

        # build the template
        files = Dir["#{@options['template_dir']}/**/*"]
        files.each do |file|
          real_filename = file.sub(/^#{@options['template_dir']}\//, '').sub(/^_/, '.')
          real_path = "#{path}/#{real_filename}"
          say_status :create, real_filename, :green
          if File.directory? file
            FileUtils.mkdir_p real_path
          else
            erb = Erubis::Eruby.new File.read(file)
            File.open real_path, 'w' do |f|
              f.write erb.result(binding())
            end
          end
        end
        generate_config path
      end

      private

      def generate_config(base_path)
        config_file_name = 'config.yml'
        say_status :create, config_file_name, :green
        # TODO: move the default_options hash to a different file (/lib/twittbot/defaults.rb maybe?)
        default_options = {
            consumer_key: '',
            consumer_secret: '',
            access_token: '',
            access_token_secret: '',
        }

        File.open "#{base_path}/#{config_file_name}", 'w' do |f|
          f.write default_options.to_yaml
        end
      end
    end
  end
end