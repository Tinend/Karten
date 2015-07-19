# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Zurechtschneiden.rb"
require "Bruteforce.rb"

class KamikazeHochstapler

  KARTENWERT = 10
  ZUGWERT = 5

  include Zurechtschneiden
  include Bruteforce

  def initialize
    @name = "Kamikaze Hochstapler"
    @wkeiten = []
  end
  
  # berechnet die Wkeit, dass der Gegner drüber geht. (eher pessimistisch)
  def wkeit(wert)
    if wert <= 0
      return 1.0
    elsif wert >= @wkeiten.length
      return 0.0
    else
      return @wkeiten[wert]
    end
  end
  
  # berechnet die Summe der Werte eines Zahlenarrays
  def summiere(array)
    summe = 0
    array.each do |wert|
      summe += wert
    end
    return summe
  end

  #bewertet einen Zug
  def bewerte(wahl)
    wert = 0
    differenzen = Array.new(@wisser.eigener_stapel.laenge) {|i| @wisser.eigener_stapel.staerke(i) - @wisser.gegner_stapel.staerke(i)}
    wahl.each_with_index do |w, i|
      if w >= 0 and w < differenzen.length
        differenzen[w] += @wisser.eigener_stapel.hand[i].wert
      elsif w == -2
        wert += 1
      end
    end
    differenzen.each do |d|
      if d > @maxkartenwert
        wert += 10
      elsif d > 0
        wert += 1
      end
    end
     return wert
  end

  attr_reader :name

  # erfaehrt Regeln
  def erklaeren(handkarten, neustrafe, maxnamenlaenge, maxkartenwert, kartenzahl)
    @handkarten = handkarten
    @neustrafe = neustrafe
    @maxkartenwert = maxkartenwert
    @wkeiten = []
  end
  
  #erstellt einen Array mit den Wahrscheinlichkeiten, wie hoch es ist einen bestimmten Wert überschreiten zu können (eher pessimistisch)
  def erstelle_wkeiten
    karten = @wisser.eigener_stapel.alle_karten + @wisser.gegner_stapel.alle_karten
    karten.sort!
    @wkeiten = Array.new(2 * @maxkartenwert + 1) do |wert|
      wahrscheinlichkeit = 0.0
      pos = karten.length - 1
      karten.each do |k|
        while k.wert + karten[pos].wert > wert and pos > 0
          pos -= 1
        end
        wahrscheinlichkeit += (karten.length - 1 - pos) * 0.2
        while k.wert +  karten[pos].wert == wert and pos > 0
          pos -= 1
          wahrscheinlichkeit += 0.1
        end
      end
      wahrscheinlichkeit /= karten.length
      karten.each do |k|
        if (k <=> wert) == 1
          wahrscheinlichkeit += 0.8
        elsif (k <=> wert) == 0
          wahrscheinlichkeit += 0.4
        end
      end
      wahrscheinlichkeit / karten.length
    end
  end

  # macht einen Zug
  def befehle(wisser)
    @wisser = wisser
    if @wkeiten == []
      erstelle_wkeiten
    end
    return brute
  end

end
