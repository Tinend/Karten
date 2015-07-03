# -*- coding: utf-8 -*-

# Für alles, was von einem Spieler auf dem Feld liegt verantwortlich
class Feld

  def initialize(reihen)
    @reihen = reihen
  end

  def dup
    ar = Array.new(@reihen.length) {|i| @reihen[i].dup}
    return Feld.new(reihen)
  end

  # legt eine Karte an die Position x
  def legen(pos, karte)
    # -1 bedeutet abwerfen!
    if pos < -1 or pos > @reihen.length
      @reihen.push(Reihe.new([karte]))
    elsif pos == -1
      return karte
    else
      @reihen[pos].erhalte(karte)
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
    return @feld.length
  end

  # legt eine Reihe ab
  def ablegen(pos)
    ablage = @feld[pos].ablegen
    @feld.delete_at(pos)
    return ablage
  end
end
