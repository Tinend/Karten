class Karte
  def initialize(name, wert)
    @name = name
    @wert = wert
  end
  attr_reader :wert, :name

  def <=>(x)
    r = (x <=> @wert)
    return -r
  end

end
