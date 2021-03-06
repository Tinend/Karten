
# Eine Reihe von Karten eines Spielers auf dem Feld
class Reihe
  def initialize(karten)
    @karten = karten
  end

  attr_reader :karten

  def dup
    return Reihe.new(@karten.dup)
  end

  def min
    return @karten.min
  end

  def erhalte(karte)
    @karten.push(karte)
  end

  # berechne staerke
  def staerke
    summe = 0
    @karten.each do |k|
      summe += k.wert
    end
    return summe
  end

  # testet, ob karten verloren gehen
  def abwerfen(staerke_gegner)
    staerke_eigen = staerke
    if staerke_eigen > staerke_gegner
      return [:gewonnen, []]
    elsif staerke_eigen == staerke_gegner
      return [:unentschieden, []]
    else
      if @karten.length > 0
        @karten.sort!
        @karten.reverse!
        return [:verloren, [@karten.pop]]
      else
        return [:verloren, []]
      end
    end
  end

  def ablegen
    return @karten
  end
end
