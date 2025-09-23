class Giacenza < ApplicationRecord
  belongs_to :magazzino
  belongs_to :articolo

  validates :quantita, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :magazzino_id, uniqueness: { scope: :articolo_id }

  scope :per_magazzino, ->(magazzino) { where(magazzino: magazzino) }
  scope :per_articolo, ->(articolo) { where(articolo: articolo) }
  scope :con_giacenza, -> { where('quantita > 0') }
  scope :esaurite, -> { where(quantita: 0) }

  def self.appllica_variazione!(magazzino_id, articolo_id, variazione)
    giacenza = find_or_initialize_by(magazzino_id: magazzino_id, articolo_id: articolo_id)
    giacenza.quantita = (giacenza.quantita || 0) + variazione
    giacenza.save!
  end

  def to_s
    "#{articolo.sku} - #{quantita} #{articolo.unita_misura} (#{magazzino.nome})"
  end
end

