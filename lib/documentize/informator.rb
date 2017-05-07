module Documentize
  class Informator

    def clear_screen
      system("cls") || system("tput reset") || system("clear") || puts("\e[H\e[2J")
    end

    def branch_info(branch, parent = nil)

      display_branch(branch, parent)

      branch[:desc] = get_desc(branch[:type])

      get_args(branch) if branch[:args]

      branch[:content].each do |item|
        branch_info(item, [branch[:name], branch[:type]]) if item.is_a?(Hash)
      end

    end

    def display_branch(branch, parent = nil)
      clear_screen unless parent

      puts line_break

      print "Describing: #{branch[:name]} #{branch[:type]}"
      print " of #{parent[0]} #{parent[1]}" if parent
      puts

      puts line_break

      puts Builder.build_code(branch)
    end

    def gen_doc(branch)
      branch[:content].each do |item|
        gen_doc(item) if item.is_a?(Hash)
      end
      branch[:doc] = Builder.build_docs(branch)
    end

    def gen_info(tree)

      tree.each do |branch|
        branch_info(branch)
        gen_doc(branch)
      end

    end

    def get_args(branch)

      print "#{branch[:type]} #{branch[:name]}"
      print Builder.build_args(branch[:args])
      puts

      branch[:args].each do |arg|

        puts "Please enter a brief description of argument: #{arg[:name]}"
        arg[:desc] = gets.strip

        puts "What input Type should be entered for agument: #{arg[:name]}"
        arg[:type] = gets.strip

        if arg[:default] == nil
          puts "Please enter a default 'testing' value for Rspec:"
          arg[:test] = gets.strip
        end

      end

      branch[:args]
    end

    def get_desc(type)

      puts "please enter a description of the above #{type}\n\n"
      gets.strip

    end



    def line_break
      puts
      puts "--------------------------------------------------"
    end

  end
end
