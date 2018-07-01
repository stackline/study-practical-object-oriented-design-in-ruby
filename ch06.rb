# How to write inheritable source code
#
# [x] 6.1
# [x] 6.2
# [x] 6.3
# [ ] 6.4

# require 'pry'

# Bicycle class
class Bicycle
  attr_reader :size, :tape_color

  def initialize(args)
    @size = args[:size]
    @tape_color = args[:tape_color]
  end

  def spares
    { chain: '10-speed',
      tire_size: '23', # milimeters
      tape_color: tape_color }
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
