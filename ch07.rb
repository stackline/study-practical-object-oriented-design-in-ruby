# Share role behavior with module

# [ ] 7.1 p.181

require 'minitest/autorun'

# Preparer is preparable
class Mechanic
  def prepare_trip
    'aaa'
  end
end
class TripCoordinator
  def prepare_trip
    'bbb'
  end
end
class Driver
  def prepare_trip
    'ccc'
  end
end
