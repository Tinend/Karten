module Zurechtschneiden
  # schneidet Eingabe zurecht, damit diese keine Fehler erzeugt.
  def zurechtschneiden(eingabe, max, handlaenge)
    i = 0
    laenge = @handkarten
    while i < laenge and i < eingabe.length
      if eingabe[i] < -1 or eingabe[i] >= max
        laenge -= @neustrafe
        max += 1
      elsif eingabe[i] == -1
        laenge += 1
      end
      i += 1
    end
    return [] if [laenge - 1, eingabe.length - 1, handlaenge - 1].min <= 0
    eingabe[0..[laenge - 1, eingabe.length - 1, handlaenge - 1].min]
  end
end
