require_relative "collector"
require_relative "generator"

class Documentize

  REGEX = {
    ext:         /\.rb$|\.ru$/,
    shbang:      /^#!.*?ruby$/
  }

  attr_reader :collector, :file, :header, :tree

  def initialize(file_name)
    @file = load_file(file_name)
    @collector = Collector.new
    @generator = Generator.new
  end

  def load_file(file_name)
    file = File.readlines(file_name).map {|line| line.strip} - [""]
    raise ArgumentError unless valid?(file_name, file[0])
    file
  end

  def run
    @tree, @header = collector.run(@file)
    generator.gen_docs(tree)
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