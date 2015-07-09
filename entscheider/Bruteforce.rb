module Bruteforce

  # bruteforce alles durchprobieren
  def brute
    handkarten = @wisser.eigener_stapel.hand.length
    laenge = @wisser.eigener_stapel.laenge + 2
    maxwahl = [-1, -1, -1]
    max = bewerte(maxwahl)
    (laenge ** handkarten).times do |wahlzahl|
      wahl = Array.new(handkarten) {|i| (wahlzahl / (laenge ** i) % laenge) - 2}
      wahl = zurechtschneiden(wahl, laenge, @wisser.eigener_stapel.hand.length)
      bew = bewerte(wahl)
      if (bew <=> max) == 1
        max = bew
        maxwahl = wahl
      end
    end
    maxwahl
  end
end
