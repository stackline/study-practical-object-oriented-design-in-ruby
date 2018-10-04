require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative 'ch09'

class WheelTest < MiniTest::Test
  def setup
    @wheel = Wheel.new(26, 1.5)
  end

  def test_implements_the_diameterizable_interface
    assert_respond_to(@wheel, :diameter)
  end

  def test_calculates_diameter
    assert_in_delta(29, @wheel.diameter, 0.01)
  end
end

class DiameterDouble
  def diameter
    10
  end
end

class GearTest < MiniTest::Test
  def setup
    wheel = DiameterDouble.new
    @observer = MiniTest::Mock.new
    @gear = Gear.new(chainring: 52, cog: 11, wheel: wheel, observer: @observer)
  end

  def test_calculates_gear_inches
    assert_in_delta(47.27, @gear.gear_inches, 0.01)
  end

  def test_notifies_observers_when_cogs_change
    @observer.expect(:changed, true, [52, 27])
    @gear.cog = 27
    assert_equal true, @observer.verify
  end

  def test_notifies_observers_when_chainrings_change
    @observer.expect(:changed, true, [42, 11])
    @gear.chainring = 42
    assert_equal true, @observer.verify
  end
end
