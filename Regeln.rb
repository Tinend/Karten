class Regeln
  def initialize(kartenset, hand = 3, neustrafe = 0, aufteilung = 0)
    @kartenset = kartenset.schuffle
    aufteilung += @kartenset.length / 2
    @stapela = kartenset[0.. aufteilung - 1]
    @stapelb = kartenset[aufteilung .. @kartenset.length - 1]
    @handkarten = hand
    @neustrafe = neustrafe
  end

  attr_reader :stapela, :stapelb, :handkarten, :neustrafe

  def maxlaenge(neu)
    return hand - neustrafe * neu
  end
end
