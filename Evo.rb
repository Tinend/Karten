#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Spiel.rb"
require "Regeln.rb"
require "Tichu.rb"
require "Entscheider.rb"
require "Entscheider_Merker.rb"

epsilon = 0.3
q = 0.77
runden = 1
anzahl = 11
faktor = 1.15
minepsilon = 0.025
kartenname, karten = tichu
regeln = Regeln.new(karten, 3, 1, 0)
spiele = anzahl * (anzahl - 1) * runden
teste = entscheider_wahl
until epsilon < minepsilon
  entscheider = Array.new(anzahl) {|i| teste.new(Eroberungswerter_n.new(epsilon * 2 * i / (anzahl - 1) - epsilon + q), i)}
  entscheider.shuffle!
  runden.times do
    entscheider.each do |enta|
      entscheider.shuffle.each do |entb|
        if enta != entb
          regeln.neues_spiel
          gewinner = spiel(enta.entscheider, entb.entscheider, regeln, true)
          if gewinner == 0
            enta.besiege(entb)
          else
            entb.besiege(enta)
          end
        end
      end
    end
  end
  q = 0
  summe = 0
  entscheider.each do |e|
    p [e.entscheider.q, e.elo]
    q += 2 ** (e.elo / 100.0) * e.entscheider.q
    summe += 2 ** (e.elo / 100.0)
  end
  q /= summe
  entscheider.sort!.reverse!
  epsilon /= faktor
  puts "Neues Q: #{q}, Epsilon #{epsilon}"
end
