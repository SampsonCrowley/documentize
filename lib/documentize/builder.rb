module Documentize
  class Builder

    class << self

      REGEX = {
        bad_do_block:  /\sdo.*?end/,
        do_block:      /\sdo[\s\|.*]/,
        flow:          /^(if|unless|while|for).*?/
      }

      def build_docs(branch, level = 0)
        doc_str = ""
        doc_str << "#{indent(level)}# #{@private ? 'Private' : 'Public'}: #{branch[:desc]}\n#{indent(level)}#\n"
        if branch[:args]
          branch[:args].each do |arg|
            doc_str << "#{indent(level)}# #{arg[:name]} - #{arg[:type]}: #{arg[:desc]}\n"
          end
          doc_str << "#{indent(level)}# \n"
        end
        doc_str
      end


      def build_args(args)
        str = ""
        str << "("
        args.each do |arg|
          str << "#{arg[:name]}"
          str << " = #{arg[:default]}" if arg[:default]
          str << ", " unless arg == args[-1]
        end
        str << ")"
      end

      def build_code(code, level = 0)
        make_public if(code[:type] == "class")
        str = ""
        str << build_docs(code, level) if code[:doc]
        str << indent(level)
        str << "#{code[:type] == "method" ? "def" : code[:type]} #{code[:name]}"
        str << build_args(code[:args]) if code[:args]
        str << "\n\n"

        code[:content].each do |item|
          if item.is_a?(Hash)

            str << build_code(item, level+1)

          else
            make_private if(item =~ /private/)
            level -= 1 if item =~ /end/ && item !~ REGEX[:bad]

            str << indent(level+1) + "#{item} \n"
            str << "\n" if item =~ /end/ && item !~ REGEX[:bad]

            level += 1 if (item =~ REGEX[:do_block] || item =~ REGEX[:flow]) && item !~ REGEX[:bad]

          end
        end

        str << indent(level)
        str << "end\n"
        level -= 1
        str << "\n"
      end

      private
        def make_private
          @private = true
        end

        def make_public
          @private = false
        end

        def indent(level)
          '  ' * level
        end
    end
  end
end
