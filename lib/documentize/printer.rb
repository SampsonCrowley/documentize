module Documentize
  class Printer
    def self.print_with_docs(tree)
      tree.each do |branch|
        puts Builder.build_code(branch)
      end
    end
  end
end