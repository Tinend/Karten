# -*- coding: utf-8 -*-

# Für alles, was von einem Spieler auf dem Feld liegt verantwortlich
class Feld

  def initialize(reihen)
    @reihen = reihen
    @neu = 0
    @loeschen = 0
  end

  attr_reader :reihen

  def dup
    reihen = Array.new(@reihen.length) {|i| @reihen[i].dup}
    return Feld.new(reihen)
  end

  # legt eine Karte an die Position x
  def legen(pos, karte)
    # -1 bedeutet abwerfen!
    pos -= @loeschen
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
    @loeschen = 0
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
    pos -= @loeschen
    @reihen[pos].staerke
  end
  
  # testet, ob Karten verloren gehen
  def abwerfen(pos, staerke_gegner)
    pos -= @loeschen
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
    pos -= @loeschen
    ablage = @reihen[pos].ablegen
    @reihen.delete_at(pos)
    @loeschen += 1
    return ablage
  end
end
