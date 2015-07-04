# -*- coding: utf-8 -*-

# für Entscheider verantwortlich
class Spieler
  def initialize(stapel, gegner_stapel, entscheider, regeln)
    @stapel = stapel
    @gegner_stapel = gegner_stapel
    @regeln = regeln
    @verloren = false
    @entscheider = entscheider
    begin
      @entscheider.erklaeren(@regeln.handkarten, @regeln.neustrafe, @regeln.maxnamenlaenge, @regeln.maxkartenwert, @regeln.kartenzahl)
    rescue => e
      puts e.message
      puts e.backtrace     
    end
    # Ich denke, hier muss der Entscheider noch nicht verlieren
  end

  def verloren?
    return @verloren
  end

  # führt eine Runde durch
  # Falls der Entscheider eine Exception aufruft, wird diese Abgefangen. Der Entscheider dann verliert automatisch.
  def runde(wisser_selbst)
    wisser_gegner = Wisser.new
    @stapel.handfuellen(@regeln.handkarten)
    wisser_selbst.eigener_stapel = @stapel.dup
    begin
      befehle = @entscheider.befehle(wisser_selbst)
      teste(befehle)
      wisser_gegner.befehlen(befehle, @stapel.hand.dup)
      neu = @stapel.legen(befehle)
      @gegner_stapel.neulegen(neu)
    rescue => e
      puts e.message
      puts e.backtrace
      @verloren = true
    end
    @stapel.laenge.times do |pos|
      staerke = @gegner_stapel.staerke(pos)
      rueck = @stapel.abwerfen(pos, staerke)
      wisser_gegner.erfolg_haben(rueck, pos)
      @gegner_stapel.erhalten(rueck, pos)
    end
    @gegner_stapel.delete
    @stapel.delete
    wisser_gegner.gegner_stapel = @stapel.dup
    if @stapel.verloren?
      @verloren = true
    end
    return wisser_gegner
  end

  # testet den Zug auf Legalität
  def teste(befehl)
    if befehl.length > @stapel.hand.length
      raise "Länge des Befehls stimmt nicht!"
    end
    nummer = 0
    neu = 0
    max = @stapel.laenge
    befehl.each do |b|
      if b != -1
        nummer += 1
      end
      if b < -1 or b >= max
        max += 1
        neu += 1
      end
    end
    raise "Die Regeln wurden nicht beachtet! #{nummer} bei maximal #{@regeln.maxlaenge(neu)}" if nummer > @regeln.maxlaenge(neu)
  end
end
