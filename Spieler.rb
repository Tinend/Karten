# -*- coding: utf-8 -*-

# für Entscheider verantwortlich
class Spieler
  def initialize(stapel, gegnerstapel, entscheider, regeln)
    @stapel = stapel
    @gegnerstapel = gegnerstapel
    @regeln = regeln
    @verloren = false
    @entscheider = entscheider
    @entscheider.erklaeren(@regeln.handkarten, @regeln.neustrafe)
  end

  def verloren?
    return @verloren
  end

  # führt eine Runde durch
  # Falls der Entscheider eine Exception aufruft, wird diese Abgefangen. Der Entscheider dann verliert automatisch.
  def runde(wisser_selbst)
    wisser_gegner = Wisser.new
    @stapel.handfuellen(regeln.handkarten)
    wisser_selbst.eigener_stapel = @stapel.dup
    begin
      befehle = @entscheider.befehle(wisser_selbst)
      teste(befehle)
      @wisser.befehlen(befehle, @stapel.hand.dup)
      @stapel.legen(befehle)
    rescue => e
      puts e.message
      puts e.backtrace
      @verloren = true
    end
    @stapel.laenge.times do |pos|
      staerke = @gegnerstapel.staerke(pos)
      rueck = @stapel.abwerfen(pos, staerke)
      wisser_gegner.erfolg_haben(rueck, pos)
      @gegnerstapel.erhalten(rueck, pos)
    end
    wisser_gegner.gegner_stapel = @stapel.dup
    if @stapel.verloren?
      @verloren = true
    end
    return wisser_gegner
  end

  # testet den Zug auf Legalität
  def testen(befehl)
    if befehl.length > @stapel.hand.length
      raise "Länge des Befehls stimmt nicht!"
    end
    nummer = 0
    neu = 0
    befehl.each do |b|
      if b != -1
        nummer += 1
      end
      if b < -1 or b >= @stapel.laenge
        neu += 1
      end
    end
    raise if nummer > @regeln.maxlaenge(neu)
  end
end
