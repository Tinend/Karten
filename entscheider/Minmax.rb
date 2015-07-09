# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Zurechtschneiden.rb"
require "Bruteforce.rb"

class Minmax

  ZUGWERT = 10

  include Zurechtschneiden
  include Bruteforce

  def initialize
    @name = "Minmax"
  end
  
  def bewerte(wahl)
    schnitt = @wisser.eigener_stapel.stapelschnitt
    wert = 0
    kleinwert = 0
    positionen = wahl.uniq
    positionen.delete_if {|x| x < 0}
    werte = Array.new(positionen.length) {|i| @wisser.eigener_stapel.staerke(positionen[i]) - @wisser.gegner_stapel.staerke(positionen[i])}
    werte.each do |w|
      if w < 0
        wert += 6
      elsif w > 0
        wert -= 4
      end
    end
    wahl.each_with_index do |w, i|
      if w == -2
        wert += 1
      end
      if w >= 0
        positionen.each_with_index do |p,j|
          werte[j] += @wisser.eigener_stapel.hand[i].wert if p == w
        end
      end
    end
    werte.each do |w|
      if w < 0
        wert -= 6
      elsif w > 0
        wert += 4
      end
    end
    wahl.each_with_index do |w, j|
      if w >= 0
        positionen.each_with_index do |p,i|
          if p == w and werte[i] < @wisser.gegner_stapel.staerke(w)
            wert += schnitt - ZUGWERT
          end
        end
      elsif w == -1
        if @wisser.eigener_stapel.hand[j] == nil
          p @wisser.eigener_stapel.hand
          p j
          raise
        end
        kleinwert += @wisser.eigener_stapel.hand[j].wert - ZUGWERT
      end
    end
    return Minmaxbewertung.new(wert, kleinwert)
  end

  attr_reader :name

  # erfaehrt Regeln
  def erklaeren(handkarten, neustrafe, maxnamenlaenge, maxkartenwert, kartenzahl)
    @handkarten = handkarten
    @neustrafe = neustrafe
  end
  
  # macht einen Zug
  def befehle(wisser)
    @wisser = wisser
    return brute()
  end

end


class Minmaxbewertung
  def initialize(wert, kleinwert)
    @wert = wert
    @kleinwert = kleinwert
  end
  attr_reader :wert, :kleinwert

  def <=>(x)
    if x.class != Minmaxbewertung
      raise "Minmaxbewertung nur mit Minmaxbewertung vergleichbar!"
    end
    if (@wert <=> x.wert) != 0
      return @wert <=> x.wert
    else
      return @kleinwert <=> x.kleinwert
    end
  end

end
