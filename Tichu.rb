# -*- coding: utf-8 -*-
def tichu
  set = []
  set = Array.new(36) {|i|
    Karte.new((i / 4 + 2).to_s, (i / 4 + 2))
  }
  4.times {set.push(Karte.new("Bube", 12))}
  4.times {set.push(Karte.new("Dame", 13))}
  4.times {set.push(Karte.new("König", 15))}
  4.times {set.push(Karte.new("Ass", 20))}
  set.push(Karte.new("Eins", 21))
  set.push(Karte.new("Hund", 25))
  set.push(Karte.new("Phoenix", 30))
  set.push(Karte.new("Drache", 40))
  return ["Tichu", set]
end
