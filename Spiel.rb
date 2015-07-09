#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Karte.rb"
require "Wisser.rb"
require "Spieler.rb"
require "Feld.rb"
require "Reihe.rb"
require "Stapel.rb"

# führt ein Spiel durch und gibt den Gewinner zurück
def spiel(entscheidera, entscheiderb, regeln, schweigen = false)
  stapela = Stapel.new(regeln.stapela)
  stapelb = Stapel.new(regeln.stapelb)
  spieler = [
             Spieler.new(stapela, stapelb, entscheidera, regeln),
             Spieler.new(stapelb, stapela, entscheiderb, regeln)
            ]
  nummer = 0
  stapela.auslegen(4)
  stapelb.auslegen(3)
  stapelb.neulegen(1)
  stapela.feld.neu
  stapelb.feld.neu
  wisser = Wisser.new
  wisser.gegner_stapel = stapela.dup
  runde = 0 unless schweigen
  until spieler[nummer].verloren?
    unless schweigen
      runde += 1
      puts "Runde #{runde} beginnt!"
    end
    nummer += 1
    nummer %= 2
    wisser = spieler[nummer].runde(wisser)
  end
  nummer += 1
  nummer %= 2
  return nummer
end
