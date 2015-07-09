# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Zurechtschneiden.rb"
require "Bruteforce.rb"

class Eroberungswerter_n

  KARTENWERT = 10
  ZUGWERT = 5

  include Zurechtschneiden
  include Bruteforce

  def initialize
    @name = "Eroberungswerter"
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
    summe = 0
    summewurf = 0
    summeneu = 0
    summeerobern = 0
    summegleich = 0
    summeverlieren = 0
    differenzen = Array.new(@wisser.eigener_stapel.laenge) {|i| @wisser.eigener_stapel.staerke(i) - @wisser.gegner_stapel.staerke(i)}
    lege = Array.new(@wisser.eigener_stapel.laenge, 0)
    lege_staerke = Array.new(@wisser.eigener_stapel.laenge, [])
    wahl.each_with_index do |w, i|
      if w >= 0 and w < differenzen.length
        differenzen[w] += @wisser.eigener_stapel.hand[i].wert
        lege[w] += 1
        lege_staerke[w].push(@wisser.eigener_stapel.hand[i].wert)
      elsif w == -1
        if  @wisser.eigener_stapel.hand[i] == nil
          p [@wisser.eigener_stapel.hand, i, @wisser.eigener_stapel.hand.length, wahl]
          raise "Eroberung fehlgeschlagen!"
        end
        summe += @wisser.eigener_stapel.hand[i].wert - @eigener_schnitt - ZUGWERT
        summewurf += @wisser.eigener_stapel.hand[i].wert - @eigener_schnitt - ZUGWERT
      else
        summe += (@gegner_schnitt - @eigener_schnitt + KARTENWERT) * (1 - wkeit(@wisser.eigener_stapel.hand[i].wert))
        summeneu += (@gegner_schnitt - @eigener_schnitt + KARTENWERT) * (1 - wkeit(@wisser.eigener_stapel.hand[i].wert))
      end
    end
    differenzen.each_with_index do |d, i|
      if d > 0 and @wisser.gegner_stapel.staerke(i) > 0
        summe += (@wisser.gegner_stapel.min(i).wert - @eigener_schnitt + KARTENWERT) * (1 - wkeit(d))
        summeerobern += (@wisser.gegner_stapel.min(i).wert - @eigener_schnitt + KARTENWERT) * (1 - wkeit(d))
      elsif d > 0
        summe += (@gegner_schnitt - @eigener_schnitt + KARTENWERT) * (1 - wkeit(d))
        summeerobern +=(@gegner_schnitt - @eigener_schnitt + KARTENWERT) * (1 - wkeit(d))
      elsif d == 0
        summe += @wisser.eigener_stapel.staerke(i) + summiere(lege_staerke[i]) - @eigener_schnitt * (@wisser.eigener_stapel.feld.reihen[i].karten.length + lege[i])
        summe -= @wisser.gegner_stapel.staerke(i) - @gegner_schnitt * @wisser.gegner_stapel.feld.reihen[i].karten.length
        summegleich += @wisser.eigener_stapel.staerke(i) + summiere(lege_staerke[i]) - @eigener_schnitt * (@wisser.eigener_stapel.feld.reihen[i].karten.length + lege[i])
        summegleich -= @wisser.gegner_stapel.staerke(i) - @gegner_schnitt * @wisser.gegner_stapel.feld.reihen[i].karten.length
      elsif @wisser.eigener_stapel.staerke(i) > 0
        summe -= @wisser.eigener_stapel.min(i).wert - @gegner_schnitt + KARTENWERT
        summeverlieren -= @wisser.eigener_stapel.min(i).wert - @gegner_schnitt + KARTENWERT
      else
        summe -= @eigener_schnitt - @gegner_schnitt + KARTENWERT
        summeverlieren -= @eigener_schnitt - @gegner_schnitt + KARTENWERT
      end
    end
    #staerken = Array.new(@handkarten) {|i| @wisser.eigener_stapel.hand[i].wert}
    #p [@name, staerken, wahl, differenzen, summe, summewurf, summeneu, "s", summeerobern, summegleich, summeverlieren]
    #gets if rand(1000) == 0
    return summe
  end

  attr_reader :name

  # erfaehrt Regeln
  def erklaeren(handkarten, neustrafe, maxnamenlaenge, maxkartenwert, kartenzahl)
    @handkarten = handkarten
    @neustrafe = neustrafe
    @maxkartenwert = maxkartenwert
    @wkeiten = []
  end
  
  def wkeit_n(n, wert)
    wahrscheinlichkeit = 0.0
    if n == 0
      wahrscheinlichkeit = 1.0
    elsif n == 1
      karten.each do |k|
        if (k <=> wert) == 1
          wahrscheinlichkeit += 1.0
        elsif (k <=> wert) == 0
          wahrscheinlichkeit += 0.5
        end
      end
      wahrscheinlichkeit / karten.length
    elsif n == 2
      pos = @karten.length - 1
      @karten.each do |k|
        while k.wert + @karten[pos].wert > wert and pos > 0
          pos -= 1
        end
        wahrscheinlichkeit += (@karten.length - 1 - pos)
        while k.wert +  @karten[pos].wert == wert and pos > 0
          pos -= 1
          wahrscheinlichkeit += 0.5
        end
      end
      wahrscheinlichkeit /= @karten.length ** 2
    else
      @karten.each do |k|
        wahrscheinlichkeit += wkeit_n(n - 1, wert - k.wert)
      end
      wahrscheinlichkeit /= @karten.length
    end
    return wahrscheinlichkeit
  end

  #erstellt einen Array mit den Wahrscheinlichkeiten, wie hoch es ist einen bestimmten Wert überschreiten zu können (eher pessimistisch)
  def erstelle_wkeiten
    @karten = @wisser.eigener_stapel.alle_karten + @wisser.gegner_stapel.alle_karten
    @karten.sort!
    @wkeiten = Array.new(2 * @maxkartenwert + 1) do |wert|
      wahrscheinlichkeit = 0.0
      @handkarten.times do |i|
        wahrscheinlichkeit += 2 ** -i / (2 - 2 ** (-@handkarten + 1)) * wkeit_n(i + 1, wert)
      end
    end
  end

  # macht einen Zug
  def befehle(wisser)
    @wisser = wisser
    @eigener_schnitt = @wisser.eigener_stapel.stapelschnitt
    @gegner_schnitt = @wisser.gegner_stapel.stapelschnitt
    if @wkeiten == []
      erstelle_wkeiten
    end
    return brute
  end

end
