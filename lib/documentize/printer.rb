module Documentize
  class Printer
    def self.print_with_docs(tree, header)
      puts header
      tree.each do |branch|
        puts Builder.build_code(branch)
      end
    end
  end
end