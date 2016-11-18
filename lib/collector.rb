class Collector

  REGEX = {
    args:        /(.*?)[\(|\s](.*?)\)/,
    header:      /^require/,
    block:       /\sdo[\s\|.*]/,
    inline_do:   /\sdo.*?end/,
    is_class:    /^class/,
    is_method:   /^def/,
    is_module:   /^module/,
    comment:      /^#/
  }

  def run(lines)
    queue, header = remove_headers(lines)
    [build(queue), header]
  end

  private

    def build(queue)
      content = []
      skips = 0
      until queue.length == 0

        item = queue.shift

        if item =~ REGEX[:is_class] ||
           item =~ REGEX[:is_method] ||
           item =~ REGEX[:is_module]

          item = parse_command(item)

          item[:content], queue = build(queue)

        elsif item =~ REGEX[:block]

          skips += 1 unless item =~ REGEX[:inline_do]

        elsif item =~ /end/

          return content, queue if skips <= 0
          skips -= 1

        end

        content  << item

      end

      content

    end

    def get_args(cmd)
      if cmd !~ REGEX[:args]
        [cmd, nil]
      else
        matches = cmd.match(REGEX[:args])
        [matches[1], parse_args(matches[2])]
      end
    end

    def parse_args(arg_list)
      breakup = arg_list.split(",").map{|arg| arg.strip}
      breakup.map do |arg|
        items = arg.split("=").map{ |item| item.strip }
        {
          name: items[0],
          default: items[1]
        }
      end
    end

    def parse_command(cmd)
      breakup = cmd.split(" ", 2)
      if breakup[0] == "def"
        type = "method"
        cmd, args = get_args(breakup[1])
      else
        type = breakup[0]
        cmd = breakup[1]
      end
      {
          type: type,
          name: cmd,
          args: args,
          content: [],
          doc: nil
        }
    end

    def remove_headers(file)
      header = ""
      until file[0] !~ REGEX[:header] && file[0] !~ REGEX[:comment]
        header << "#{file.shift}\n"
      end
      header = header.length == 0 ? nil : header.strip
      [file, header]
    end

end