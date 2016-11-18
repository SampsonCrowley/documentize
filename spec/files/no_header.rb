class Pointless(arg1, arg2, arg3, arg4)

  def do_nothing
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