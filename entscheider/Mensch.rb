class Mensch
  def initialize
    puts "Wie willst du heissen?"
    @name = gets.chomp
  end
  
  # erfaehrt Regeln
  def erklaeren(handkarten, neustrafe, maxnamenlaenge, maxkartenwert, kartenzahl)
    @handkarten = handkarten
    @neustrafe = neustrafe
    @maxnamenlaenge = maxnamenlaenge
    @maxkartenwert = maxkartenwert
    @kartenzahl = kartenzahl
    @laengen = [
               [@maxnamenlaenge, "Karte".length].max,
               [@kartenzahl.to_s.length, "Anzahl".length].max,
               [(@maxkartenwert * @kartenzahl).to_s.length, "Summe".length].max
              ]
    @gesammtlaenge = 5 
    @laenge.each do |l|
      @gesammtlaenge += l
    end
  end

  # macht einen Zug
  def befehle(wisser)
    puts "Die Runde von #{@name} beginnt."
    wisser.befehle.each_with_index do |b, i|
      puts "Der Gegner legte die Karte #{wisser.hand[i].name} an den Ort #{b}."
    end
    puts "Du hast noch #{wisser.eigener_stapel.vorrat} Karten in deinem Stapel. (Mit Hand)"
    puts "Dein Gegner hat noch #{wisser.gegener_stapel.vorrat} Karten in seinem Stapel."
    print " " * (3 + wisser.eigener_stapel.laenge.to_s.length)
    print " " * ((@gesammtlaenge - "Gegner".length) / 2) + "Gegner" + " " * ((@gesammtlaenge - "Gegner".length + 1) / 2)
    print "|"
    print " " * ((@gesammtlaenge - "Deine".length) / 2) + "Deine" + " " * ((@gesammtlaenge - "Deine".length + 1) / 2)
    puts
    wisser.gegner_stapel.feld.reihen.each_with_index do |gegreihe, i|
      print schreibe(wisser.eigener_stapel.laenge.to_s.length + 1, (i + 1).to_s + ".")
      eigreihe = wisser.eigener_stapel.feld.reihen[i]
      print schreibe(@laengen[0] + 2, gegreihe.min.name)
      print schreibe(@laengen[1] + 2, gegreihe.karten.length.to_s)
      print schreibe(@laengen[2] + 2, gegreihe.staerke.to_s)
      print " | "
      print schreibe(@laengen[2], eigreihe.staerke.to_s)
      print schreibe(@laengen[1] + 2, eigreihe.karten.length.to_s)
      print schreibe(@laengen[0], eigreihe.min.name)
      puts
    end
    puts "Deine Handkarten sind:"
    wisser.hand.each do |h|
      puts "#{h.name} (#{h.wert})"
    end
    puts "Wie willst du auslegen?"
    puts "Trenne durch Leerzeichen. 0 = Abwerfen. Ansonsten nimm einfach die Zahlen der entsprechenden Reihen."
    eingabe = gets.chomp.split(" ")
    eingabe.collect! {|e|
      e.to_i - 1
    }
    eingabe
  end

  def schreibe(laenge, string)
    return " " * (laenge - string.length) + string
  end
end
