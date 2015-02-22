require 'fileutils'
require 'erubis'
require 'yaml'

module Twittbot
  module Generators
    # Class to install a template to the bot.
    class TemplateGenerator
      include Thor::Shell

      def initialize(template_name, options)
        @template_name = template_name.gsub('-', '_')
        @options = {
            'template_options' => {}
        }.merge!(options)
        @options['template_dir'] = File.expand_path "../#{@template_name}", __FILE__
        @post_install_messages = []
      end

      def create
        files = Dir["#{@options['template_dir']}/**/*"]
        files.each do |file|
          real_filename = "lib/#{file.sub(/^#{@options['template_dir']}\//, '').sub(/^_/, '.')}"
          real_path = File.expand_path "./#{real_filename}"

          botpart_config = {}
          erb = Erubis::Eruby.new File.read(file)
          final_result = erb.result(binding)

          if File.exist? real_path
            say_status :exists, real_filename, :red
          else
            say_status :create, real_filename, :green
            if File.directory? file
              FileUtils.mkdir_p real_path
            else
              File.open real_path, 'w' do |f|
                f.write final_result
              end
            end
          end

          save_config botpart_config, real_filename unless botpart_config.empty?
        end
        unless @post_install_messages.empty?
          say "Post install messages:", :yellow
          puts @post_install_messages
        end
      end

      # Adds an optional post-install message.
      # @param msg [String] message to display
      def post_install_message(msg)
        @post_install_messages << msg
      end

      private

      def save_config(config, path)
        path = "etc/#{path.sub(/^lib\//, '').sub(/\.rb$/, '.yml')}"
        real_path = File.expand_path "./#{path}"

        if File.exist? real_path
          say_status :merge, path, :yellow
          existing_config = YAML.load_file real_path
          config.merge! existing_config
        else
          say_status :create, path, :green
        end

        File.open real_path, 'w' do |f|
          f.write config.to_yaml
        end
      end
    end
  end
end