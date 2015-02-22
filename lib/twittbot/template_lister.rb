module Twittbot
  class TemplateLister
    include Thor::Shell

    def initialize(options)
      @options = {}.merge(options)
      @options['templates_dir'] = File.expand_path "../generators/templates", __FILE__
    end

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