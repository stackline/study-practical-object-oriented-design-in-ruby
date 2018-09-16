# Combine objects by composition

# [x] 8 intro
# [x] 8.1
# [x] 8.2
# [ ] 8.3 p.220

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
