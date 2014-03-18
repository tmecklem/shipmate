module Shipmate
  class AppImporter

    attr_reader :import_strategies

    def initialize
      super
      @import_strategies = []
    end

    def add_strategy(strategy)
      @import_strategies << strategy
    end

    def import_apps
      @import_strategies.each do |import_strategy|
        app_files = Dir.glob("#{import_strategy.import_dir}/**/*").reject { |entry| !entry.upcase.end_with?(import_strategy.app_extension.upcase) }
        app_files.each do |app_file|
          begin
            import_strategy.import_app app_file
          rescue StandardError => e
            puts "Unable to import #{app_file}: #{e}"
          end
        end
      end
    end

  end
end