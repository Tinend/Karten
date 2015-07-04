# -*- coding: utf-8 -*-

# Für alles, was von einem Spieler auf dem Feld liegt verantwortlich
class Feld

  def initialize(reihen)
    @reihen = reihen
    @neu = 0
    @loeschen = []
  end

  attr_reader :reihen

  #löscht überflüssige Reihen
  def delete
    while @loeschen.length > 0
      l = @loeschen.pop
      @reihen.delete_at(l)
      @loeschen.collect!{|loe|
        if loe > l
          loe - 1
        else
          loe
        end
      }
    end
  end

  def dup
    reihen = Array.new(@reihen.length) {|i| @reihen[i].dup}
    return Feld.new(reihen)
  end

  # legt eine Karte an die Position x
  def legen(pos, karte)
    # -1 bedeutet abwerfen!
    if pos < -1 or pos >= @reihen.length
      @reihen.push(Reihe.new([karte]))
      @neu += 1
    elsif pos == -1
      return karte
    else
      @reihen[pos].erhalte(karte)
    end
  end

  # gibt zurück, wie viele neue Reihen gelegt wurden
  def neu
    n = @neu
    @neu = 0
    @loeschen = []
    return n
  end

  # legt neue Reihen an
  def neulegen(neu)
    neu.times do
      @reihen.push(Reihe.new([]))
    end
  end

  # rechnet die Stärke an der Stelle pos aus
  def staerke(pos)
    @reihen[pos].staerke
  end
  
  # testet, ob Karten verloren gehen
  def abwerfen(pos, staerke_gegner)
    rueck = @reihen[pos].abwerfen(staerke_gegner)
    if rueck[0] == :unentschieden
      rueck[1] = ablegen(pos)
    end
    return rueck
  end

  def laenge
    return @reihen.length
  end

  # legt eine Reihe ab
  def ablegen(pos)
    ablage = @reihen[pos].ablegen
    @loeschen.push(pos)
    return ablage
  end
end
