# Design a cost-effective test

# [x] 9.1
# [x] 9.2
# [x] 9.3
# [x] 9.4
# [ ] 9.5 p.270

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
  attr_reader :chainring, :cog, :wheel, :observer

  def initialize(args)
    @chainring = args[:chainring]
    @cog = args[:cog]
    @wheel = args[:wheel]
    @observer = args[:observer]
  end

  def gear_inches
    ratio * wheel.diameter
  end

  def ratio
    chainring / cog.to_f
  end

  def set_cog(new_cog)
    @cog = new_cog
    changed
  end

  def set_chainring(new_chainring)
    @chainring = new_chainring
    changed
  end

  def changed
    observer.changed(chainring, cog)
  end
end
