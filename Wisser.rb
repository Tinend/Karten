class Wisser
  def initialize
    @eigener_stapel = nil
    @gegner_stapel = nil
    @befehle = []
    @gegner_hand = []
    @erfolge = []
  end
  attr_accessor :eigener_stapel, :gegner_stapel
  attr_reader :befehle, :gegner_hand, :erfolge

  def befehlen(befehle, hand)
    @gegner_hand = hand
    @befehle = befehle
  end

  def erfolg_haben(rueck, pos)
    @erfolge.push([rueck, pos])
  end
end
