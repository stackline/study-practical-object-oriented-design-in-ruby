# Design a cost-effective test

# [x] 9.1
# [ ] 9.2 p.249

require 'minitest/autorun'

class Wheel
  attr_reader :rim, :tire

  def initialize(rim, tire)
    @rim = rim
    @tire = tire
  end

  def diameter
    rim + (tire * 2)
  end
end

class Gear
  attr_reader :chainring, :cog, :wheel

  def initialize(args)
    @chainring = args[:chainring]
    @cog = args[:cog]
    @wheel = args[:wheel]
  end

  def gear_inches
    ratio * wheel.diameter
  end

  def ratio
    chainring / cog.to_f
  end
end

class WheelTest < MiniTest::Test
  def test_calculates_diameter
    wheel = Wheel.new(26, 1.5)
    assert_in_delta(29, wheel.diameter, 0.01)
  end
end

class GearTest < MiniTest::Test
  def test_calculates_gear_inches
    wheel = Wheel.new(26, 1.5)
    gear = Gear.new(chainring: 52, cog: 11, wheel: wheel)
    assert_in_delta(137.1, gear.gear_inches, 0.01)
  end
end
