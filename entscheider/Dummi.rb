# -*- coding: utf-8 -*-
class Dummi
  def initialize
    @name = dummi
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
      elsif wisser.gegner_stapel.feld.reihen[i].staerke > wisser.eigen_stapel.feld.reihen[i].staerke
        eingabe.push(i)
      end
      i += 1
    end
    laenge = @handkarten
    i = 0
    max = wisser.eigener_stapel.laenge
    while i < laenge and i < eingabe.length
      if eingabe[i] < -1 or eingabe[i] >= max
        laenge -= @neustrafe
        max += 1
      elsif eingabe[i] == -1
        laenge += 1
      end
      i += 1
    end
    eingabe[0..[laenge - 1, eingabe.length - 1].min]
  end

end
