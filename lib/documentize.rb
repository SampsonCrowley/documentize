require "documentize/version"
require "documentize/printer"
require "documentize/builder"
require "documentize/collector"
require "documentize/informator"



module Documentize
  class Documentize
    REGEX = {
      ext:         /\.rb$|\.ru$/,
      shbang:      /^#!.*?ruby$/
    }

    attr_reader :collector, :file, :informator, :header, :tree

    def initialize(file_name)
      @file = load_file(file_name)
      @collector = Collector.new
      @informator = Informator.new
    end

    def load_file(file_name)
      file = File.readlines(file_name).map {|line| line.strip} - [""]
      raise ArgumentError unless valid?(file_name, file[0])
      file
    end

    def run
      @tree, @header = collector.run(@file)
      informator.gen_info(tree)
      informator.clear_screen
      Printer.print_with_docs(tree)
    end

    private

      def valid?(file_name, shebang)
        if file_name =~ REGEX[:ext] || shebang =~ REGEX[:shbang]
          true
        else
          false
        end
      end
  end
end