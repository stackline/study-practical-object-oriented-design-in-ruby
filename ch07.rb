# Share role behavior with module

# [x] 7.1
# [x] 7.2

require 'minitest/autorun'

# schedule
class Schedule
  def scheduled?(schedulable, start_date, end_date)
    puts "This #{schedulable.class} is not scheduled\n" \
         " between #{start_date} and #{end_date}"
    false
  end

  # interface
  def add(target, starting, ending) end

  def remove(target, starting, ending) end
end

# schedulable module
module Schedulable
  attr_writer :schedule

  def schedule
    @schedule ||= ::Schedule.new
  end

  def schedulable?(start_date, end_date)
    !scheduled?(start_date - lead_days, end_date)
  end

  def scheduled?(start_date, end_date)
    schedule.scheduled?(self, start_date, end_date)
  end

  def lead_days
    0
  end
end

# bicycle
class Bicycle
  include Schedulable

  attr_reader :schedule, :size, :chain, :tire_size

  def initialize(args = {})
    @schedule = args[:schedule] || Schedule.new
  end

  private

  def lead_days
    1
  end
end

# vehicle
class Vehicle
  include Schedulable

  def lead_days
    3
  end
end

# mechanic
class Mechanic
  include Schedulable

  def lead_days
    4
  end
end

require 'date'

# schedule class test
class TestSchedule < Minitest::Test
  def setup
    puts "\n# Schedule class test"
    @schedule = Schedule.new
    @object = Class.new
  end

  def test_scheduled?
    assert_equal(false,
                 @schedule.scheduled?(@object, '2018-01-01', '2018-01-02'))
  end
end

# bicycle class test
class TestBicycle < Minitest::Test
  def setup
    puts "\n# Bicycle class test"
    @bike = Bicycle.new
  end

  def test_schedulable?
    starting = Date.parse('2015/09/04')
    ending = Date.parse('2015/09/10')
    assert_equal(true, @bike.schedulable?(starting, ending))
  end
end

# vehicle class test
class TestVehicle < Minitest::Test
  def setup
    puts "\n# Vehicle class test"
    @vehicle = Vehicle.new
  end

  def test_schedulable?
    starting = Date.parse('2015/09/04')
    ending = Date.parse('2015/09/10')
    assert_equal(true, @vehicle.schedulable?(starting, ending))
  end
end

# mechanic class test
class TestMechanic < Minitest::Test
  def setup
    puts "\n# Mechanic class test"
    @mechanic = Mechanic.new
  end

  def test_schedulable?
    starting = Date.parse('2015/09/04')
    ending = Date.parse('2015/09/10')
    assert_equal(true, @mechanic.schedulable?(starting, ending))
  end
end
