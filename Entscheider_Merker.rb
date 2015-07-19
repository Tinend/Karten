class Entscheider_Merker
  def initialize(entscheider, nummer = 0, siege = 0, elo = 1000.0)
    @nummer = nummer.to_s
    @entscheider = entscheider
    @siege = siege
    @elo = elo
  end

  attr_reader :entscheider
  attr_accessor :siege, :elo
  
  def <=>(x)
    return -(x <=> siege)
  end

  def to_s
    return @entscheider.name + @nummer
  end

  def besiege(merker)
    @siege += 1
    if merker.elo < @elo
      elodif = 2 ** ((merker.elo - @elo) / 100.0) * 7.5
    else
      elodif = (2 - 2 ** ((@elo - merker.elo) / 100.0)) * 7.5
    end
    @elo += elodif
    merker.elo -= elodif
  end
end
