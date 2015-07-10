#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Spiel.rb"
require "Regeln.rb"
require "Tichu.rb"
require "Entscheider.rb"
require "Entscheider_Merker.rb"

epsilon = 20
q = 1
runden = 3
anzahl = 5
kartenname, karten = tichu
regeln = Regeln.new(karten, 3, 1, 0)
spiele = anzahl * (anzahl - 1) * runden
until epsilon < 0.001
  entscheider = Array.new(5) {|i| Entscheider_Merker.new(Eroberungswerter_n.new(rand(0) * epsilon * 2 - epsilon + q), i)}
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
  epsilon /= 1.4
  puts "Sieger #{entscheider[0].entscheider.q}, Epsilon #{epsilon}"
  q = entscheider[0].entscheider.q
end
