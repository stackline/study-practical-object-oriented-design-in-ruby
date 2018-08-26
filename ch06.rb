# How to write inheritable source code
#
# [x] 6.1
# [x] 6.2
# [x] 6.3
# [ ] 6.4
#   - p.163

# require 'pry'

puts '# start'

# Abstract bicycle class
class Bicycle
  attr_reader :size, :chain, :tire_size

  def initialize(args = {})
    @size = args[:size]
    @chain = args[:chain] || 'default'
    @tire_size = args[:tire_size]
    raise 'Set default value to tire_size' unless @tire_size
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
  tire_size: '26',
  tape_color: 'red'
)

puts '## road_bike'
puts road_bike.size
puts road_bike.chain
puts road_bike.tire_size

mountain_bike = MountainBike.new(
  size: 'S',
  tire_size: '26',
  front_shock: 'Manitou',
  rear_shock: 'Fox'
)

puts '## mountain_bike'
puts mountain_bike.size
puts mountain_bike.chain
puts mountain_bike.tire_size
