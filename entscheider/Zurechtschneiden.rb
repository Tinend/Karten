module Zurechtschneiden
  # schneidet Eingabe zurecht, damit diese keine Fehler erzeugt.
  def zurechtschneiden(eingabe, neustrafe, max, laenge)
    i = 0
    while i < laenge and i < eingabe.length
      if eingabe[i] < -1 or eingabe[i] >= max
        laenge -= neustrafe
        max += 1
      elsif eingabe[i] == -1
        laenge += 1
      end
      i += 1
    end
    eingabe[0..[laenge - 1, eingabe.length - 1].min]
  end
end
