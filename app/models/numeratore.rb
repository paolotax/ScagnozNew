class Numeratore < ApplicationRecord
  validates :anno, presence: true
  validates :progressivo, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tipo, presence: true
  validates :anno, uniqueness: { scope: :tipo }

  enum :tipo, {
    ordine_cliente: 0,
    ordine_fornitore: 1,
    ddt: 2,
    fattura: 3,
    nota_credito: 4,
    reso_fornitore: 5,
    reso_cliente: 6,
    ddt_trasferimento: 7
  }

  def self.next!(tipo:)
    year = Date.today.year
    rec = lock.where(anno: year, tipo: Documento.tipi[tipo]).first_or_create!(progressivo: 0)
    rec.with_lock do
      rec.progressivo += 1
      rec.save!
      rec.progressivo
    end
  end

  def to_s
    "#{tipo} - #{anno}/#{progressivo}"
  end
end
