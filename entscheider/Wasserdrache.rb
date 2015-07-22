# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Zurechtschneiden.rb"
require "Bruteforce.rb"
require "Wkeiterstellen.rb"

class Wasserdrache

  KARTENWERT = 10
  ZUGWERT = 5
  FAKTOR = 0.9

  include Zurechtschneiden
  include Bruteforce
  include Wkeiten

  def initialize(faktor = FAKTOR)
    @faktor = faktor
    @name = "Wasserdrache"
    @wkeiten = []
  end
  
  # berechnet die Wkeit, dass der Gegner drüber geht. (eher pessimistisch)
  def wkeit(wert, karten)
    if wert <= 0
      return 0.0
    elsif wert >= @wkeiten.length
      return 1.0
    else
      # ueberarbeitung nötig
      return @wkeiten[karten][wert]
    end
  end

  def wkeit_summe(wert)
    # ueberarbeitung nötig
    return wkeit(wert, 1)
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
    neu = []
    wahl.each_with_index do |w, i|
      if w >= 0 and w < differenzen.length
        differenzen[w] += @wisser.eigener_stapel.hand[i].wert
        unless neu.any? {|n| n.positionieren(@wisser.eigener_stapel.hand[i], w)}
          neu.push(Neu.new(w, [@wisser.eigener_stapel.hand[i]]))
        end
      elsif w == -2
        wert += 1.0 / (1 - @faktor) * @gegner_schnitt * wkeit_summe(@wisser.eigener_stapel.hand[i].wert)
      end      
    end
    nuetzlich_eigen = @nuetzlich_eigen.dup
    neu.each do |n|
      i = n.position
      nuetzlich_eigen[i] = nuetzlich(@wisser.eigener_stapel.feld.reihen[i].karten + n.karten, true)
    end
    differenzen.each_with_index do |d, i|
      if d > 0
        wert += @nuetzlich_gegner[i] * wkeit_summe(d)
      elsif d < 0
        wert -= nuetzlich_eigen[i]
      else
        wert += nuetzlich_eigen[i] - @nuetzlich_gegner[i]
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

  # bewertet, wie nützlich ein Sieg bei einem gegebenen Kartenstapel ist.
  def nuetzlich(stapel, eigen)
    if @faktor >= 1
      wert = 0
    else
      wert = 1.0 / (1 - @faktor)
    end
    if eigen
      wert *= @eigener_schnitt + KARTENWERT
    else
      wert *= @gegner_schnitt + KARTENWERT
    end
    stapel.sort.reverse_each do |karte|
      wert *= @faktor
      wert += karte.wert
    end
    wert
  end

  # macht einen Zug
  def befehle(wisser)
    @wisser = wisser
    @eigener_schnitt = @wisser.eigener_stapel.stapelschnitt
    @gegner_schnitt = @wisser.gegner_stapel.stapelschnitt

    #erstellt Array, der Bewertet, wie schlimm ein Verlust hier ist.
    @nuetzlich_eigen = Array.new(@wisser.eigener_stapel.laenge) do |i|
      nuetzlich(@wisser.eigener_stapel.feld.reihen[i].karten, true)
    end

    #erstellt Array, der Bewertet, wie nuetzlich ein Sieg hier ist.
    @nuetzlich_gegner = Array.new(@wisser.gegner_stapel.laenge) do |i|
      nuetzlich(@wisser.gegner_stapel.feld.reihen[i].karten, false)
    end
    if @wkeiten == []
      erstelle_wkeiten
    end
    return brute
  end

end


class Neu
  def initialize(position, karten = [])
    @position = position
    @karten = karten
  end

  attr_reader :position, :karten

  def positionieren(karte, pos)
    if pos == @position
      @karten.push(karte)
      return true
    end
    return false
  end
end
