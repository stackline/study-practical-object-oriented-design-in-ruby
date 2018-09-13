# Combine objects by composition

# [x] 8 intro
# [ ] 8.1 p.208

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
  def spares
    'spare is hogehoge.'
  end
end

parts = Parts.new
bike = Bicycle.new(size: 'S', parts: parts)
p bike.spares
