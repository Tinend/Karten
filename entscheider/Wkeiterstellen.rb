  # erstellt einen Array mit den Wahrscheinlichkeiten, dass k Karten weniger als den Wert n erreichen.
module Wkeiten
  def erstelle_wkeiten
    @karten = @wisser.eigener_stapel.alle_karten + @wisser.gegner_stapel.alle_karten
    @karten.sort!
    @wkeiten = Array.new(@handkarten + 1) {|i| Array.new(@maxkartenwert * i + 1, 0)}
    @wkeiten[0][0] = 1
    @karten.each do |k|
      (@wkeiten.length - 1).times do |i|
        @wkeiten[@wkeiten.length - 2 - i].each_with_index do |anzahl, j|
          if @wkeiten[@wkeiten.length - 1 - i][j + k.wert]
            @wkeiten[@wkeiten.length - 1 - i][j + k.wert] += anzahl
          end
        end
      end
    end
    @wkeiten.each_with_index do |w, i|
      summe = 0
      w.collect! do |anzahl|
        summe += anzahl
        summe / (tief(@karten.length, i)).to_f
      end
    end
    @wkeiten.each do |wahr|
      wahr.each_with_index do |w,i|
      end
    end
  end

  def tief(n,k)
    resultat = 1
    (n - k).times do |i|
      resultat *= n - i
      resultat /= i + 1
    end
    resultat
  end

end
