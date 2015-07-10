# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Zurechtschneiden.rb"
require "Bruteforce.rb"

class Eroberungswerter_n

  KARTENWERT = 10
  ZUGWERT = 5
  Q = 2.5

  include Zurechtschneiden
  include Bruteforce

  def initialize(q = Q)
    @q = q
    @name = "Eroberungswerter_n"
    @wkeiten = []
  end
  
  # berechnet die Wkeit, dass der Gegner drüber geht. (eher pessimistisch)
  def wkeit(wert)
    if wert <= 0
      return 0.0
    end
    summe = 0.0
    @wkeiten.each_with_index do |wkeiten, i|
      if wert < wkeiten.length and i > 0
        summe += @q ** (i - 1) * wkeiten[wert]
      elsif i > 0
        summe += @q ** (i - 1)
      end
    end
    summe *= (1 - @q) / (1 - @q ** (@wkeiten.length - 1))
    return summe
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
        summe += (@gegner_schnitt - @eigener_schnitt + KARTENWERT) * (wkeit(@wisser.eigener_stapel.hand[i].wert))
        summeneu += (@gegner_schnitt - @eigener_schnitt + KARTENWERT) * (wkeit(@wisser.eigener_stapel.hand[i].wert))
      end
    end
    differenzen.each_with_index do |d, i|
      if d > 0 and @wisser.gegner_stapel.staerke(i) > 0
        summe += (@wisser.gegner_stapel.min(i).wert - @eigener_schnitt + KARTENWERT) * (wkeit(d))
        summeerobern += (@wisser.gegner_stapel.min(i).wert - @eigener_schnitt + KARTENWERT) * (wkeit(d))
      elsif d > 0
        summe += (@gegner_schnitt - @eigener_schnitt + KARTENWERT) * (wkeit(d))
        summeerobern +=(@gegner_schnitt - @eigener_schnitt + KARTENWERT) * (wkeit(d))
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

  attr_reader :name, :q

  # erfaehrt Regeln
  def erklaeren(handkarten, neustrafe, maxnamenlaenge, maxkartenwert, kartenzahl)
    @handkarten = handkarten
    @neustrafe = neustrafe
    @maxkartenwert = maxkartenwert
    @wkeiten = []
  end
  
  # erstellt einen Array mit den Wahrscheinlichkeiten, dass k Karten weniger als den Wert n erreichen.
  def erstelle_wkeiten
    @karten = @wisser.eigener_stapel.alle_karten + @wisser.gegner_stapel.alle_karten
    @karten.sort!
    @wkeiten = Array.new(@handkarten + 1) {|i| Array.new(@maxkartenwert * i + 1, 0)}
    @wkeiten[0][0] = 1
    @karten.each do |k|
      (@wkeiten.length - 1).times do |i|
        @wkeiten[@wkeiten.length - 2 - i].each_with_index do |anzahl, j|
          if @wkeiten[@wkeiten.length - 1 - i][j + k.wert]
            @wkeiten[@wkeiten.length - 1 - i][j + k.wert] += anzahl
          end
        end
      end
    end
    @wkeiten.each_with_index do |w, i|
      summe = 0
      w.collect! do |anzahl|
        summe += anzahl
        summe / (tief(@karten.length, i)).to_f
      end
    end
    @wkeiten.each do |wahr|
      wahr.each_with_index do |w,i|
      end
    end
  end

  def tief(n, k)
    erg = 1
    k.times do |i|
      erg *= (n - i)
      erg /= i + 1
    end
    erg
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
