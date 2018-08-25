# How to write inheritable source code
#
# [x] 6.1
# [x] 6.2
# [x] 6.3
# [ ] 6.4
#   - p.161

# require 'pry'

puts '--- start ---'

# Abstract bicycle class
class Bicycle
  attr_reader :size

  def initialize(args = {})
    @size = args[:size]
  end
end

# Road bike
class RoadBike < Bicycle
  attr_reader :tape_color

  def initialize(args)
    @tape_color = args[:tape_color]
    super(args)
  end

  def spares
    { chain: '10-speed',
      tire_size: '23', # milimeters
      tape_color: tape_color }
  end
end

# Mountain bike
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

road_bike = RoadBike.new(
  size: 'M',
  tape_color: 'red'
)

puts 'road_bike.size'
puts road_bike.size

mountain_bike = MountainBike.new(
  size: 'S',
  front_shock: 'Manitou',
  rear_shock: 'Fox'
)

puts 'mountain_bike.size'
puts mountain_bike.size
