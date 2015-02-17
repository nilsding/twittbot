require 'fileutils'
require 'erubis'
require 'yaml'

require 'twittbot/defaults'

module Twittbot
  module Generators
    class AppGenerator
      include Thor::Shell

      def initialize(app_name, options = {})
        @options = {
            'template_dir' => Twittbot::TEMPLATE_DIR
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
              f.write erb.result(binding)
            end
          end
        end
        generate_config path
      end

      private

      def generate_config(base_path)
        say_status :create, Twittbot::CONFIG_FILE_NAME, :green
        default_options = {
            consumer_key: Twittbot::CONSUMER_KEY,
            consumer_secret: Twittbot::CONSUMER_SECRET,
            access_token: '',
            access_token_secret: ''
        }

        File.open "#{base_path}/#{Twittbot::CONFIG_FILE_NAME}", 'w' do |f|
          f.write default_options.to_yaml
        end
      end
    end
  end
end