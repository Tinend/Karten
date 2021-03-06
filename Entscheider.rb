# -*- coding: utf-8 -*-
$:.unshift File.dirname(__FILE__)
require "entscheider/Mensch.rb"
require "entscheider/Dummi.rb"
require "entscheider/Minmax.rb"
require "entscheider/Eroberungswerter.rb"
require "entscheider/Eroberungswerter_n.rb"
require "entscheider/Hochstapler.rb"
require "entscheider/Kamikaze_Hochstapler.rb"
require "entscheider/Wasserdrache.rb"

ENTSCHEIDER = [Mensch, Dummi, Minmax, Eroberungswerter, Hochstapler, Wasserdrache]
VERSTECKT = [Kamikaze_Hochstapler, Eroberungswerter_n]
def entscheider_wahl
  puts "Welchen Entscheider wählst du?"
  ENTSCHEIDER.each_with_index do |e, i|
    puts "#{i + 1} = #{e.to_s}"
  end
  wahl = gets.to_i - 1
  if wahl < 0 or wahl >= ENTSCHEIDER.length
    wahl = 0
  end
  return ENTSCHEIDER[wahl]
end
