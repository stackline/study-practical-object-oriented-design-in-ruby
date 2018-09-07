# Share role behavior with module

# [ ] 7.1 p.186

require 'minitest/autorun'

# schedule
class Schedule
  # interface
  def scheduled?(target, starting, ending) end

  def add(target, starting, ending) end

  def remove(target, starting, ending) end
end
