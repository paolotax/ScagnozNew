module AggiornaGiacenze
  extend ActiveSupport::Concern

  included do
    after_create_commit :applica_giacenze!
    before_destroy :rollback_giacenze!
  end

  private

  def applica_giacenze!
    righe_movimento_magazzino.includes(:articolo).find_each do |r|
      Giacenza.appllica_variazione!(magazzino_id, r.articolo_id, r.quantita * causale_magazzino.segno_movimento)
    end
  end

  def rollback_giacenze!
    # Operazione inversa: utile se annulli un movimento confermato
    righe_movimento_magazzino.includes(:articolo).find_each do |r|
      Giacenza.appllica_variazione!(magazzino_id, r.articolo_id, -r.quantita * causale_magazzino.segno_movimento)
    end
  end
end

