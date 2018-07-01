# How to write inheritable source code
#
# [x] 6.1
# [x] 6.2
# [ ] 6.3

# require 'pry'

# Bicycle class
class Bicycle
  attr_reader :style, :size, :tape_color,
              :front_shock, :rear_shock

  def initialize(args)
    @style = args[:style]
    @size = args[:size]
    @tape_color = args[:tape_color]
    @front_shock = args[:front_shock]
    @rear_shock = args[:rear_shock]
  end

  def spares
    if style == :road
      { chain: '10-speed',
        tire_size: '23', # milimeters
        tape_color: tape_color }
    else
      { chain: '10-speed',
        tire_size: '2.1', # inches
        rear_shock: rear_shock }
    end
  end
end

# Mountain bike class
class MountainBike < Bicycle
  attr_reader :front_shock, :rear_shock

  def initialize(args)
    @front_shock = args[:front_shock]
    @rear_shock = args[:rear_shock]
    super(args)
  end

  def spares
    super.merge(rear_shock: rear_shock)
  end
end

mountain_bike = MountainBike.new(
  size: 'S',
  front_shock: 'Manitou',
  rear_shock: 'Fox'
)

p mountain_bike.size
p mountain_bike.spares
