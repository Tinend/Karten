#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Spiel.rb"
require "Regeln.rb"
require "Tichu.rb"
require "Entscheider.rb"
require "Entscheider_Merker.rb"

entscheider = Array.new((ENTSCHEIDER.length - 1) * 2) {|i| Entscheider_Merker.new(ENTSCHEIDER[i / 2 + 1].new, i)}
kartenname, karten = tichu
regeln = Regeln.new(karten, 3, 1, 0)
runden = 10
spiele = entscheider.length * (entscheider.length - 1) * runden
runden.times do
  entscheider.each_with_index do |enta, i|
    entscheider.each_with_index do |entb, j|
      if i != j
        regeln.neues_spiel
        gewinner = spiel(enta.entscheider, entb.entscheider, regeln, true)
        if gewinner == 0
          enta.siege += 1
        else
          entb.siege += 1
        end
      end
    end
  end
end
entscheider.sort!.reverse!
puts "Es wurden #{spiele} Spiele gespielt."
puts "Die Plätze sind folgendermassen:"
entscheider.each_with_index do |e, i|
  puts "#{i + 1}. #{e.to_s} mit #{e.siege} Siegen!"
end
