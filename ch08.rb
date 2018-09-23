# Combine objects by composition

# [x] 8 intro
# [x] 8.1
# [x] 8.2
# [x] 8.3
# [x] 8.4
# [x] 8.5

require 'minitest/autorun'
require 'pry-byebug'

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

require 'forwardable'
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

require 'ostruct'
module PartsFactory
  class << self
    def build(config, parts_class = Parts)
      parts = config.collect { |part_config| create_part(part_config) }
      parts_class.new(parts)
    end

    private

    def create_part(part_config)
      OpenStruct.new(
        name: part_config[0],
        description: part_config[1],
        # needs_spare: part_config.fetch(2, true)
        needs_spare: fetch_needs_spare(part_config[2])
      )
    end

    def fetch_needs_spare(needs_spare)
      case needs_spare
      when nil then true
      when 'true' then true
      when 'false' then false
      else raise TypeError, 'Can only specify "true" or "false"'
      end
    end
  end
end

class TestBicycle < Minitest::Test
  def setup
    @parts = PartsFactory.build(road_config)
    @road_bike = Bicycle.new(size: 'L', parts: @parts)
  end

  def test_size
    puts "\nBicycle#size"
    assert_equal 'L', @road_bike.size
  end

  def test_parts
    puts "\nBicycle#parts"
    assert_equal Parts, @road_bike.parts.class
    assert_equal @parts, @road_bike.parts
  end

  def test_spares
    puts "\nBicycle#spares"
    assert_equal Array, @road_bike.spares.class
    assert_equal @parts.first, @road_bike.spares.first
  end

  private

  def road_config
    [
      %w[chain 10-speed],
      %w[tire_size 23],
      %w[tape_color red]
    ]
  end
end

class TestRecumbentBike < Minitest::Test
  def setup
    @parts = PartsFactory.build(recumbent_config)
    @recumbent_bike = Bicycle.new(size: 'L', parts: @parts)
  end

  def test_size
    puts "\nBicycle#size recumbent_bike"
    assert_equal 'L', @recumbent_bike.size
  end

  def test_spares
    puts "\nBicycle#spares recumbent_bike"
    assert_equal @parts.spares, @recumbent_bike.spares
  end

  private

  def recumbent_config
    [
      %w[chain 9-speed],
      %w[tire_size 28],
      %w[flag tall\ and\ orange]
    ]
  end
end

class TestPartsFactory < Minitest::Test
  def setup
    @road_parts = PartsFactory.build(road_config)
  end

  def test_build
    puts "\nPartsFactory.build"
    assert_equal Parts, @road_parts.class
    assert_equal 3, @road_parts.size
    part = OpenStruct.new(
      name: 'chain',
      description: '10-speed',
      needs_spare: true
    )
    assert_equal part, @road_parts.spares.first
  end

  def test_build_error
    puts "\nPartsFactory.build error"
    e = assert_raises TypeError do
      PartsFactory.build(incorrect_road_config)
    end
    assert_equal 'Can only specify "true" or "false"', e.message
  end

  private

  def road_config
    [
      %w[chain 10-speed],
      %w[tire_size 23],
      %w[tape_color red]
    ]
  end

  def incorrect_road_config
    [
      %w[chain 10-speed incorrect_config],
      %w[tire_size 23],
      %w[tape_color red]
    ]
  end
end

class TestParts < Minitest::Test
  def setup
    @road_parts = PartsFactory.build(road_config)
    @mountain_parts = PartsFactory.build(mountain_config)
  end

  def test_size
    puts "\nParts#size"
    assert_equal 3, @road_parts.size
    assert_equal 4, @mountain_parts.size
  end

  def test_spares
    puts "\nParts#spares"
    assert_equal 3, @road_parts.spares.size
    assert_equal 3, @mountain_parts.spares.size
    part = OpenStruct.new(
      name: 'chain',
      description: '10-speed',
      needs_spare: true
    )
    assert_equal part, @road_parts.spares.first
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
      %w[front_shock Manitou false],
      %w[rear_shock Fox]
    ]
  end
end
