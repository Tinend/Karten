# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Zurechtschneiden.rb"

class Mensch

  include Zurechtschneiden

  def initialize
    puts "Wie willst du heissen?"
    @name = gets.chomp
  end
  
  attr_reader :name

  # erfaehrt Regeln
  def erklaeren(handkarten, neustrafe, maxnamenlaenge, maxkartenwert, kartenzahl)
    @handkarten = handkarten
    @neustrafe = neustrafe
    @maxnamenlaenge = [maxnamenlaenge, "Nichts".length].max
    @maxkartenwert = maxkartenwert
    @kartenzahl = kartenzahl
    @laengen = [
               [@maxnamenlaenge, "Kleinste".length].max,
               [@kartenzahl.to_s.length, "Anzahl".length].max,
               [(@maxkartenwert * @kartenzahl).to_s.length, "Summe".length].max
              ]
    @gesammtlaenge = 5 
    @laengen.each do |l|
      @gesammtlaenge += l
    end
  end

  # gibt Name oder "Nichts" zurück
  def benennen(karte)
    if karte
      return karte.name
    else
      return "Nichts"
    end
  end
  
  # macht einen Zug
  def befehle(wisser)
    puts "Die Runde von #{@name} beginnt."
    wisser.befehle.each_with_index do |b, i|
      puts "Der Gegner legte die Karte #{wisser.gegner_hand[wisser.gegner_hand.length - i - 1].name} an den Ort #{b + 1}."
    end
    puts "Du hast noch #{wisser.eigener_stapel.vorrat} Karten in deinem Stapel. (Mit Hand)"
    puts "Dein Gegner hat noch #{wisser.gegner_stapel.vorrat} Karten in seinem Stapel."
    print " " * (3 + wisser.eigener_stapel.laenge.to_s.length)
    print " " * ((@gesammtlaenge - "Gegner".length) / 2) + "Gegner" + " " * ((@gesammtlaenge - "Gegner".length + 1) / 2)
    print "|"
    print " " * ((@gesammtlaenge - "Deine".length) / 2) + "Deine" + " " * ((@gesammtlaenge - "Deine".length + 1) / 2)
    puts
    print " " * (3 + wisser.eigener_stapel.laenge.to_s.length)
    print schreibe(@laengen[0], "Kleinste")
    print schreibe(@laengen[1] + 2, "Anzahl")
    print schreibe(@laengen[2] + 2, "Summe")
    print " | "
    print schreibe(@laengen[2], "Summe")
    print schreibe(@laengen[1] + 2, "Anzahl")
    print schreibe(@laengen[0] + 2, "Kleinste")
    puts
    wisser.gegner_stapel.feld.reihen.each_with_index do |gegreihe, i|
      print schreibe(wisser.eigener_stapel.laenge.to_s.length + 1, (i + 1).to_s + ".")
      eigreihe = wisser.eigener_stapel.feld.reihen[i]
      print schreibe(@laengen[0] + 2, benennen(gegreihe.min))
      print schreibe(@laengen[1] + 2, gegreihe.karten.length.to_s)
      print schreibe(@laengen[2] + 2, gegreihe.staerke.to_s)
      print " | "
      print schreibe(@laengen[2], eigreihe.staerke.to_s)
      print schreibe(@laengen[1] + 2, eigreihe.karten.length.to_s)
      print schreibe(@laengen[0] + 2, benennen(eigreihe.min))
      puts
    end
    puts "Deine Handkarten sind:"
    wisser.eigener_stapel.hand.reverse.each do |h|
      puts "#{benennen(h)} (#{h.wert})"
    end
    puts "Wie willst du auslegen?"
    puts "Trenne durch Leerzeichen. 0 = Abwerfen. Ansonsten nimm einfach die Zahlen der entsprechenden Reihen."
    eingabe = gets.chomp.split(" ")
    eingabe.collect! {|e|
      e.to_i - 1
    }
    zurechtschneiden(eingabe, @neustrafe, wisser.eigener_stapel.laenge, @handkarten)
  end

  def schreibe(laenge, string)
    return " " * (laenge - string.length) + string
  end
end
