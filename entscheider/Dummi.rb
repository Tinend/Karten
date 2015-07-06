# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Zurechtschneiden.rb"

class Dummi

  include Zurechtschneiden

  def initialize
    @name = "Dummi"
  end
  
  attr_reader :name

  # erfaehrt Regeln
  def erklaeren(handkarten, neustrafe, maxnamenlaenge, maxkartenwert, kartenzahl)
    @handkarten = handkarten
    @neustrafe = neustrafe
  end
  
  # macht einen Zug
  def befehle(wisser)
    eingabe = []
    i = 0
    until eingabe.length == @handkarten
      if wisser.gegner_stapel.laenge <= i
        eingabe.push(i)
      elsif wisser.gegner_stapel.feld.reihen[i].staerke > wisser.eigener_stapel.feld.reihen[i].staerke
        eingabe.push(i)
      end
      i += 1
    end
    zurechtschneiden(eingabe, @neustrafe, wisser.eigener_stapel.laenge, @handkarten)
  end

end
