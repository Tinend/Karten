#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Spiel.rb"
require "Regeln.rb"
require "Tichu.rb"
require "entscheider/Mensch.rb"

karten = tichu()
regeln = Regeln.new(karten, 3, 0, 0)
entscheidera = Mensch.new
entscheiderb = Mensch.new
gewinner = spiel(entscheidera, entscheiderb, regeln)
puts "Der Gewinner ist..."
sleep(1)
if gewinner == 0 
  puts "#{entscheidera.name}"
else
  puts "#{entscheiderb.name}"
end
