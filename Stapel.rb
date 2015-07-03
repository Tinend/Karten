# -*- coding: utf-8 -*-

# für alle Karten eines Spielers verantwortlich
class Stapel

  def initialize(karten, feld, ablage = [], hand = [])
    @nachziestapel = karten
    @ablage = ablage
    @feld = feld
    @hand = hand
    @verloren = false
  end

  attr_reader :feld, :ablage, :nachziestapel, :hand

  def verloren?
    @verloren
  end

  #erstellt Clon
  def dup
    return Stapel.new(@nachziestapel.shuffle, @feld.dup, @ablage.dup, @hand.dup)
  end

  #zieht eine Karte, falls möglich
  def ziehen
    if @nachziehstapel.length > 0
      @hand.push(@nachziehstapel.pop)
    elsif @ablage.length > 0 
      @nachziehstapel = @ablage.shuffle
      @ablage = []
      @hand.push(@nachziehstapel.pop)
    end
  end

  #zieht eine Karte und wirft sie ab, falls möglich, andernfalls verliert diese Seite
  def abwerfen!
    if @nachziehstapel.length > 0
      return @nachziehstapel.pop
    elsif @ablage.length > 0 
      @nachziehstapel = @ablage.shuffle
      @ablage = []
      return @nachziehstapel.pop
    else
      @verloren = true
      # Das Spiel endet erst, wenn es merkt, dass ein Spieler verloren hat.
      # Falls die zurückgegebene Karte noch verwendet wird, würde es andernfalls ein Error geben
      return Karte.new("Siegerkarte", 0)
    end
  end

  # zieht n Karten
  def handfuellen(n)
    n.times {ziehen}
  end

  # legt die Handkarten hin
  def legen(befehle)
    befehle.each do |b|
      ablegen = @feld.legen(b, @hand.pop)
      @ablage.push(ablegen) if ablegen
    end
    @ablage += @hand
    @hand = []
  end
  
  # gibt die Stärke einer Reihe auf dem Feld zurück
  def staerke(pos)
    return @feld.staerke(pos)
  end

  # testet, ob Karten verloren werden
  # Bei Geichstand werden beide Reihen abgeräumt
  # verliert einer, so verliert er eine Karte aus dieser Reihe
  # ist die Reihe jedoch leer, so verliert er einen vom Nachziehstapel
  def abwerfen(pos, staerke_gegner)
    rueck = @feld.abwerfen(pos, staerke_gegner)
    if rueck[0] == :unendschieden
      @ablage += rueck[1]
    elsif rueck[0] == :verloren and rueck[1].length == 0
      rueck[1].push(abwerfen!)
    end
    return rueck
  end

  # legt die Reihe an der Stelle pos auf dem Feld ab
  def ablegen(pos)
    @ablage += @feld.ablegen(pos)
  end

  #erhält rueckgabe von abwerfen. Nimmt entsprechende Karten
  def erhalten(rueck, pos)
    if rueck[0] == :verloren
      @ablage += rueck[1]
    elsif rueck[0] == :unentschieden
      ablegen(pos)
    end
  end

  def laenge
    return @feld.laenge
  end
end