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
  attr_reader :chainring, :cog, :rim, :tire

  def initialize(args)
    @chainring = args[:chainring]
    @cog = args[:cog]
    @rim = args[:rim]
    @tire = args[:tire]
  end

  def gear_inches
    ratio * Wheel.new(rim, tire).diameter
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
