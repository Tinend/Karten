#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Spiel.rb"
require "Regeln.rb"
require "Tichu.rb"
require "Entscheider.rb"

kartenname, karten = tichu()
karten *= 3
regeln = Regeln.new(karten, 3, 1, 0)
entscheidera = entscheider_wahl.new
entscheiderb = entscheider_wahl.new
gewinner = spiel(entscheidera, entscheiderb, regeln)
puts "Der Gewinner ist..."
sleep(1)
if gewinner == 0 
  puts "#{entscheidera.name}"
else
  puts "#{entscheiderb.name}"
end
