# How to write inheritable source code
#
# [x] 6.1
# [x] 6.2
# [x] 6.3
# [x] 6.4
#   - p.167
# [ ] 6.5

# require 'pry'

puts '# start'

# Abstract bicycle class
class Bicycle
  attr_reader :size, :chain, :tire_size

  def initialize(args = {})
    @size = args[:size]
    @chain = args[:chain] || default_chain
    @tire_size = args[:tire_size] || default_tire_size
  end

  def default_chain
    '10-speed'
  end

  def default_tire_size
    # raise NotImplementedError, "This #{self.class} cannot respond to:"
    raise NotImplementedError,
          "You have to implement #{__method__} method in #{self.class} class."
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

  def default_tire_size
    '23'
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

  def default_tire_size
    '2.1'
  end
end

# recumbent
class RecumbentBike < Bicycle
  def default_chain
    '9-speed'
  end

  def default_tire_size
    '1.0'
  end
end

puts "\n"
puts '## road_bike'
road_bike = RoadBike.new(
  size: 'M',
  tape_color: 'red'
)
puts road_bike.chain
puts road_bike.tire_size

puts "\n"
puts '## mountain_bike'
mountain_bike = MountainBike.new(
  size: 'S',
  front_shock: 'Manitou',
  rear_shock: 'Fox'
)
puts mountain_bike.chain
puts mountain_bike.tire_size

puts "\n"
puts '## recumbent_bike'
recumbent_bike = RecumbentBike.new
puts recumbent_bike.chain
puts recumbent_bike.tire_size
