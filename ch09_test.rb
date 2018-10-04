require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative 'ch09'

module DiameterizableInterfaceTest
  def test_implements_the_diameterizable_interface
    assert_respond_to(@object, :width)
  end
end

class WheelTest < MiniTest::Test
  include DiameterizableInterfaceTest

  def setup
    @wheel = @object = Wheel.new(26, 1.5)
  end

  def test_calculates_diameter
    assert_in_delta(29, @wheel.width, 0.01)
  end
end

class DiameterDouble
  def width
    10
  end
end

class DiameterDoubleTest < MiniTest::Test
  include DiameterizableInterfaceTest

  def setup
    @object = DiameterDouble.new
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

module PreparerInterfaceTest
  def test_implements_the_preparer_interface
    assert_respond_to(@object, :prepare_trip)
  end
end

class MechanicTest < MiniTest::Test
  include PreparerInterfaceTest

  def setup
    @mechanic = @object = Mechanic.new
  end
end

class TripCoordinatorTest < MiniTest::Test
  include PreparerInterfaceTest

  def setup
    @trip_coordinator = @object = TripCoordinator.new
  end
end

class DriverTest < MiniTest::Test
  include PreparerInterfaceTest

  def setup
    @driver = @object = Driver.new
  end
end

class TripTest < MiniTest::Test
  def test_requests_trip_preparation
    preparer = MiniTest::Mock.new
    trip = Trip.new
    preparer.expect(:prepare_trip, 3, [trip])

    trip.prepare([preparer])
    assert_equal true, preparer.verify
  end
end
