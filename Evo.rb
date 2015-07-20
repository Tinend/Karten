#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$:.unshift File.dirname(__FILE__)
require "Spiel.rb"
require "Regeln.rb"
require "Tichu.rb"
require "Entscheider.rb"
require "Entscheider_Merker.rb"

puts "Warnung, dieses Programm strüzt bei der Wahl der falschen Entscheider ab! Es funktioniert nur, falls die Entscheider die Wahl eines Parameters unterstützen."
teste = entscheider_wahl
puts "Wähle epsilon. (Empfohlen: 0.3)"
epsilon = gets.to_f
puts "Wähle Startwert. (Empfohlen: 0.8)"
q = gets.to_f
puts "Wähle die Anzahl der Runden. (Empfohlen: 1)"
runden = gets.to_i
puts "Wähle die Spielerzahl. (Empfohlen: 11)"
anzahl = gets.to_i
puts "Wähle den Faktor. (Empfohlen: 1.15) Warnug! Das Programm funktioniert nur mit Werten > 1!"
faktor = gets.to_f
puts "Wie genau soll der Wert ermittelt werden? (Empfohlen: 0.02)"
minepsilon = gets.to_f
kartenname, karten = tichu
regeln = Regeln.new(karten, 3, 1, 0)
spiele = anzahl * (anzahl - 1) * runden
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
