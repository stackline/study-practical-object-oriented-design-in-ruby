# Combine objects by composition

# [x] 8 intro
# [x] 8.1
# [x] 8.2
# [ ] 8.3 p.223

require 'minitest/autorun'
# require 'pry-byebug'
require 'forwardable'

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
  extend Forwardable
  def_delegators :@parts, :size, :each
  include Enumerable

  def initialize(parts)
    @parts = parts
  end

  def spares
    select(&:needs_spare)
  end
end

class Part
  attr_reader :name, :description, :needs_spare

  def initialize(args)
    @name = args[:name]
    @description = args[:description]
    @needs_spare = args.fetch(:needs_spare, true)
  end
end

module PartsFactory
  def self.build(config, part_class = Part, parts_class = Parts)
    parts = config.collect do |part_config|
      part_class.new(
        name: part_config[0],
        description: part_config[1],
        needs_spare: part_config.fetch(2, true)
      )
    end

    parts_class.new(parts)
  end
end

class TestRoadBikeParts < Minitest::Test
  def setup
    @chain = Part.new(name: 'chain', description: '10-speed')
    @road_tire = Part.new(name: 'tire_size', description: '23')
    @tape = Part.new(name: 'tape_color', description: 'red')
    @road_bike = Bicycle.new(
      size: 'L',
      parts: Parts.new([@chain, @road_tire, @tape])
    )
  end

  def test_size
    puts "\n## The size of the road bike"
    assert_equal 'L', @road_bike.size
  end

  def test_spares
    puts "\n## The spare parts of the road bike"
    spares = [@chain, @road_tire, @tape]
    assert_equal spares, @road_bike.spares
  end
end

class TestMountainBikeParts < Minitest::Test
  def setup
    @chain = Part.new(name: 'chain', description: '10-speed')
    @mountain_tire = Part.new(name: 'tire_size', description: '2.1')
    @front_shock = Part.new(name: 'front_shock',
                            description: 'Manitou',
                            needs_spare: false)
    @rear_shock = Part.new(name: 'rear_shock', description: 'Fox')
    @mountain_bike = Bicycle.new(
      size: 'L',
      parts: Parts.new([@chain, @mountain_tire, @front_shock, @rear_shock])
    )
  end

  def test_size
    puts "\n## The size of the mountain bike"
    assert_equal 'L', @mountain_bike.size
  end

  def test_spares
    puts "\n## The spare parts of the mountain bike"
    spares = [@chain, @mountain_tire, @rear_shock]
    assert_equal spares, @mountain_bike.spares
  end
end

class TestParts < Minitest::Test
  def setup
    @chain = Part.new(name: 'chain', description: '10-speed')
    @mountain_tire = Part.new(name: 'tire_size', description: '2.1')
    @front_shock = Part.new(name: 'front_shock',
                            description: 'Manitou',
                            needs_spare: false)
    @rear_shock = Part.new(name: 'rear_shock', description: 'Fox')
    parts = Parts.new([@chain, @mountain_tire, @front_shock, @rear_shock])
    @mountain_bike = Bicycle.new(size: 'L', parts: parts)
  end

  def test_spares_size
    puts "\n## The size of spares that the mountain bike needs"
    assert_equal 3, @mountain_bike.spares.size
  end

  def test_parts_size
    puts "\n## The size of parts that the mountain bike has"
    assert_equal 4, @mountain_bike.parts.size
  end

  def test_plus
    puts "\n## Parts class does not have a plus method"
    # MEMO: You can also describe as the following.
    #
    # proc = proc { @mountain_bike.parts + @mountain_bike.parts }
    # assert_raises NoMethodError, &proc
    assert_raises NoMethodError do
      @mountain_bike.parts + @mountain_bike.parts
    end
  end
end

class TestPartsFactory < Minitest::Test
  def setup
    @road_parts = PartsFactory.build(road_config)
    @mountain_parts = PartsFactory.build(mountain_config)
  end

  def test_build_road_parts
    puts "\n## Build road parts class from road config"
    assert_equal Parts, @road_parts.class
    assert_equal Part, @road_parts.spares.first.class
    assert_equal 3, @road_parts.size
    assert_equal 3, @road_parts.spares.size
  end

  def test_build_mountain_parts
    puts "\n## Build mountain parts class from mountain config"
    assert_equal Parts, @mountain_parts.class
    assert_equal Part, @mountain_parts.spares.first.class
    assert_equal 4, @mountain_parts.size
    assert_equal 3, @mountain_parts.spares.size
  end

  private

  def road_config
    [
      %w[chain 10-speed],
      %w[tire_size 23],
      %w[tape_color red]
    ]
  end

  def mountain_config
    [
      %w[chain 10-speed],
      %w[tire_size 2.1],
      ['front_shock', 'Manitou', false],
      %w[rear_shock Fox]
    ]
  end
end
