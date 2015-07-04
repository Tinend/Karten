class Regeln
  def initialize(kartenset, hand = 3, neustrafe = 0, aufteilung = 0)
    @kartenset = kartenset.schuffle
    aufteilung += @kartenset.length / 2
    @stapela = kartenset[0.. aufteilung - 1]
    @stapelb = kartenset[aufteilung .. @kartenset.length - 1]
    @handkarten = hand
    @neustrafe = neustrafe
    @maxnamenlaenge = 0
    @maxkartenwert = 0
    @kartenset.each do |k|
      @maxnamenlaenge = [k.name.length, @maxnamenlaenge].max
      @maxkartenwert = [k.wert, @maxkartenwert].max
    end
  end

  def neues_spiel(aufteilung = 0)
    @kartenset.schuffle!
    aufteilung += @kartenset.length / 2
    @stapela = kartenset[0.. aufteilung - 1]
    @stapelb = kartenset[aufteilung .. @kartenset.length - 1]
  end

  attr_reader :stapela, :stapelb, :handkarten, :neustrafe, :maxnamenlaenge, :maxkartenwert

  def kartenzahl
    return @set.length
  end

  def maxlaenge(neu)
    return hand - neustrafe * neu
  end
end
