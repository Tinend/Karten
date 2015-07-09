class Entscheider_Merker
  def initialize(entscheider, nummer = 0, siege = 0)
    @nummer = nummer.to_s
    @entscheider = entscheider
    @siege = siege
  end

  attr_reader :entscheider
  attr_accessor :siege
  
  def <=>(x)
    return -(x <=> siege)
  end

  def to_s
    return @entscheider.name + @nummer
  end
end
