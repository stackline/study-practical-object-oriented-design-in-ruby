# How to write inheritable source code
#
# [x] 6.1
# [x] 6.2
# [x] 6.3
# [x] 6.4
# [x] 6.5
# [x] 6.6

# require 'pry'
require 'minitest/autorun'

# Abstract bicycle class
class Bicycle
  attr_reader :size, :chain, :tire_size

  def initialize(args = {})
    @size = args[:size]
    @chain = args[:chain] || default_chain
    @tire_size = args[:tire_size] || default_tire_size

    post_initialize(args)
  end

  def post_initialize(_args)
    nil
  end

  def default_chain
    '10-speed'
  end

  def default_tire_size
    raise NotImplementedError,
          "You have to implement #{__method__} method in #{self.class} class."
  end

  def spares
    {
      chain: chain,
      tire_size: tire_size
    }.merge(local_spares)
  end

  def local_spares
    {}
  end
end

# Road bike
class RoadBike < Bicycle
  attr_reader :tape_color

  def post_initialize(args)
    @tape_color = args[:tape_color]
  end

  def default_tire_size
    '23' # mili-meters
  end

  def local_spares
    { tape_color: tape_color }
  end
end

# Mountain bike
class MountainBike < Bicycle
  attr_reader :front_shock, :rear_shock

  def post_initialize(args)
    @front_shock = args[:front_shock]
    @rear_shock = args[:rear_shock]
  end

  def default_tire_size
    '2.1'
  end

  def local_spares
    { rear_shock: rear_shock }
  end
end

# Recumbent bike
class RecumbentBike < Bicycle
  attr_reader :flag

  def post_initialize(args)
    @flag = args[:flag]
  end

  def default_chain
    '9-speed'
  end

  def default_tire_size
    '28'
  end

  def local_spares
    { flag: flag }
  end
end

# Minitest unit tests
# ref. https://github.com/seattlerb/minitest#unit-tests
class TestBicycle < Minitest::Test
  def setup
    @road_bike = RoadBike.new(size: 'M', tape_color: 'red')
    @mountain_bike = MountainBike.new(
      size: 'S', front_shock: 'Manitou', rear_shock: 'Fox'
    )
    @recumbent_bike = RecumbentBike.new(flag: 'tall and orange')
  end

  def test_road_bike
    before_puts(@road_bike)
    assert_equal '10-speed', @road_bike.chain
    assert_equal '23', @road_bike.tire_size
    spares = { chain: '10-speed', tire_size: '23', tape_color: 'red' }
    assert_equal spares, @road_bike.spares
  end

  def test_mountain_bike
    before_puts(@mountain_bike)
    assert_equal '10-speed', @mountain_bike.chain
    assert_equal '2.1', @mountain_bike.tire_size
    spares = { chain: '10-speed', tire_size: '2.1', rear_shock: 'Fox' }
    assert_equal spares, @mountain_bike.spares
  end

  def test_recumbent_bike
    before_puts(@recumbent_bike)
    assert_equal '9-speed', @recumbent_bike.chain
    assert_equal '28', @recumbent_bike.tire_size
    spares = { chain: '9-speed', tire_size: '28', flag: 'tall and orange' }
    assert_equal spares, @recumbent_bike.spares
  end

  private

  def before_puts(bike)
    puts "\n# #{bike.class} class"
    puts bike.spares
  end
end
