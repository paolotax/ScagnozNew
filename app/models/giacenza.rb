# == Schema Information
#
# Table name: giacenze
#
#  id           :bigint           not null, primary key
#  quantita     :decimal(14, 3)   default(0.0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  articolo_id  :bigint           not null
#  magazzino_id :bigint           not null
#
# Indexes
#
#  index_giacenze_on_articolo_id                   (articolo_id)
#  index_giacenze_on_magazzino_id                  (magazzino_id)
#  index_giacenze_on_magazzino_id_and_articolo_id  (magazzino_id,articolo_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (articolo_id => articoli.id)
#  fk_rails_...  (magazzino_id => magazzini.id)
#
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

