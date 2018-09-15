# Combine objects by composition

# [x] 8 intro
# [x] 8.1
# [ ] 8.2 p.211

require 'minitest/autorun'

class Bicycle
  attr_reader :size, :parts

  def initialize(args = {})
    @size = args[:size]
    @parts = args[:parts]
  end

  def spares
    parts.spares
  end
end

class Parts
  attr_reader :chain, :tire_size

  def initialize(args = {})
    @chain = args[:chain] || default_chain
    @tire_size = args[:tire_size] || default_tire_size
    post_initialize(args)
  end

  def default_chain
    '10-speed'
  end

  def default_tire_size
    raise NotImplementedError
  end

  # subclasses may override
  def post_initialize(_args)
    nil
  end

  def spares
    {
      tire_size: tire_size,
      chain: chain
    }.merge(local_spares)
  end

  def local_spares
    {}
  end
end

class RoadBikeParts < Parts
  attr_reader :tape_color

  def post_initialize(args)
    @tape_color = args[:tape_color]
  end

  def default_tire_size
    '23'
  end

  def local_spares
    { tape_color: tape_color }
  end
end

class MountainBikeParts < Parts
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

class TestRoadBikeParts < Minitest::Test
  def setup
    @road_bike = Bicycle.new(
      size: 'L',
      parts: RoadBikeParts.new(tape_color: 'red')
    )
  end

  def test_size
    puts "\n## The size of the road bike"
    assert_equal 'L', @road_bike.size
  end

  def test_spares
    puts "\n## The spare parts of the road bike"
    spares = {
      tire_size: '23',
      chain: '10-speed',
      tape_color: 'red'
    }
    assert_equal spares, @road_bike.spares
  end
end

class TestMountainBikeParts < Minitest::Test
  def setup
    @mountain_bike = Bicycle.new(
      size: 'L',
      parts: MountainBikeParts.new(rear_shock: 'Fox')
    )
  end

  def test_size
    puts "\n## The size of the mountain bike"
    assert_equal 'L', @mountain_bike.size
  end

  def test_spares
    puts "\n## The spare parts of the mountain bike"
    spares = {
      tire_size: '2.1',
      chain: '10-speed',
      rear_shock: 'Fox'
    }
    assert_equal spares, @mountain_bike.spares
  end
end
