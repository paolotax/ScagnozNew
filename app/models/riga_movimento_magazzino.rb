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

