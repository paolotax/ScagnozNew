# == Schema Information
#
# Table name: righe_movimento_magazzino
#
#  id                     :bigint           not null, primary key
#  prezzo_unitario        :decimal(12, 4)
#  quantita               :decimal(12, 3)   not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  articolo_id            :bigint           not null
#  movimento_magazzino_id :bigint           not null
#  riga_documento_id      :bigint
#
# Indexes
#
#  index_righe_movimento_magazzino_on_articolo_id             (articolo_id)
#  index_righe_movimento_magazzino_on_movimento_magazzino_id  (movimento_magazzino_id)
#  index_righe_movimento_magazzino_on_riga_documento_id       (riga_documento_id)
#
# Foreign Keys
#
#  fk_rails_...  (articolo_id => articoli.id)
#  fk_rails_...  (movimento_magazzino_id => movimenti_magazzino.id)
#  fk_rails_...  (riga_documento_id => righe_documento.id)
#
class RigaMovimentoMagazzino < ApplicationRecord
  belongs_to :movimento_magazzino
  belongs_to :articolo
  belongs_to :riga_documento, optional: true

  validates :quantita, presence: true, numericality: { greater_than: 0 }
  validates :prezzo_unitario, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def to_s
    "#{articolo.sku} - #{quantita} #{articolo.unita_misura}"
  end
end

