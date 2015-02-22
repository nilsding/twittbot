module Twittbot
  # Class to list available templates
  class TemplateLister
    include Thor::Shell

    # @param options [Hash] The CLI options from Thor
    def initialize(options)
      @options = {}.merge(options)
      @options['templates_dir'] = File.expand_path "../generators/templates", __FILE__
    end

    # Prints the available templates to stdout.
    def list
      dirs = Dir["#{@options['templates_dir']}/*"]
      dirs.each do |dir|
        if File.exist? dir and File.directory? dir
          say File.basename(dir).gsub('_', '-')
        end
      end
    end
  end
end