module Documentize
  class Builder

    REGEX = {
      bad_do_block:  /\sdo.*?end/,
      do_block:      /\sdo[\s\|.*]/
    }

    def self.build_docs(branch)
      doc_str = ""
      doc_str << "# Public: #{branch[:desc]}\n#\n"
      if branch[:args]
        branch[:args].each do |arg|
          doc_str << "# #{arg[:name]} - #{arg[:type]}: #{arg[:desc]}\n"
        end
        doc_str << "# \n"
      end
      doc_str
    end


    def self.build_args(args)
      str = ""
      str << "("
      args.each do |arg|
        str << "#{arg[:name]}"
        str << " = #{arg[:default]}" if arg[:default]
        str << ", " unless arg == args[-1]
      end
      str << ")"
    end

    def self.build_code(code, indent = 0)
      str = ""
      str << build_docs(code) if code[:doc]
      str << "  "*indent
      str << "#{code[:type]} #{code[:name]}"
      str << build_args(code[:args]) if code[:args]
      str << "\n\n"

      code[:content].each do |item|
        if item.is_a?(Hash)

          str << build_code(item, indent+1)

        else

          indent -= 1 if item =~ /end/ && item !~ REGEX[:bad]

          str << "  "*(indent+1) + "#{item} \n"
          str << "\n" if item =~ /end/ && item !~ REGEX[:bad]

          indent += 1 if item =~ REGEX[:do_block] && item !~ REGEX[:bad]

        end
      end

      str << "  "*indent
      str << "end\n"
      indent -= 1
      str << "\n"
    end
  end
end