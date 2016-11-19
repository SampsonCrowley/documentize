require 'test'

class Pointless

  def do_nothing(arg1, arg2 = nil, arg3, arg4)
    trick_you do |test|
      even_trickier do |test| bad_format end
    end
  end

end

module EvenMorePointless

  def do_nothing
    trick_you do |test|
      even_trickier do |test| bad_format end
    end
  end

end

def stand_alone_method
  trick_you do |test|
    even_trickier do |test| bad_format end
  end
end