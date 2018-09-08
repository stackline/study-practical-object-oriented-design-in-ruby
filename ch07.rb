# Share role behavior with module

# [ ] 7.1 p.186

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

# test
class TestSchedule < Minitest::Test
  def setup
    @schedule = Schedule.new
    @object = Class.new
  end

  def test_scheduled?
    assert_equal(false,
                 @schedule.scheduled?(@object, '2018-01-01', '2018-01-02'))
  end
end
