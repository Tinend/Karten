#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Karte.rb"
require "Wisser.rb"
require "Spieler"
require "Feld.rb"
require "Reihe.rb"
require "Stapel.rb"

# führt ein Spiel durch und gibt den Gewinner zurück
def spiel(entscheidera, entscheiderb, regeln)
  stapela = regeln.stapela
  stapelb = regeln.stapelb
  spieler = [
             Spieler.new(stapela, stapelb, entscheidera, regeln),
             Spieler.new(stapelb, stapela, entscheiderb, regeln)
            ]
  nummer = 0
  #
  wisser = Wisser.new
  wisser.stapel_gegner = stapela.dup
  until spieler[nummer].verloren?
    nummer += 1
    nummer %= 2
    wisser = spieler[nummer].runde(wisser)
  end
  return nummer
end
