# How to write inheritable source code
#
# [x] 6.1

class Bicycle
  attr_reader :size, :tape_color

  def initialize(args)
    @size = args[:size]
    @tape_color = args[:tape_color]
  end

  def spares
    {
      chain: '10-speed',
      tire_size: '23',
      tape_color: tape_color
    }
  end
end

p Bicycle.new(size: 25, tape_color: 'red').spares

