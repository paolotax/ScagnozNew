# == Schema Information
#
# Table name: righe_documento
#
#  id              :bigint           not null, primary key
#  aliquota_iva    :decimal(5, 2)    default(0.0), not null
#  note            :string
#  prezzo_unitario :decimal(12, 4)   default(0.0), not null
#  quantita        :decimal(12, 3)   not null
#  quantita_evasa  :decimal(12, 3)   default(0.0), not null
#  stato           :integer          default("in_attesa"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  articolo_id     :bigint           not null
#  documento_id    :bigint           not null
#
# Indexes
#
#  index_righe_documento_on_articolo_id   (articolo_id)
#  index_righe_documento_on_documento_id  (documento_id)
#
# Foreign Keys
#
#  fk_rails_...  (articolo_id => articoli.id)
#  fk_rails_...  (documento_id => documenti.id)
#
class RigaDocumento < ApplicationRecord
  belongs_to :documento
  belongs_to :articolo

  validates :quantita, presence: true, numericality: { greater_than: 0 }
  validates :quantita_evasa, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :prezzo_unitario, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :aliquota_iva, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :stato, presence: true, inclusion: { in: [ 0, 1, 2 ] }

  enum :stato, {
    in_attesa: 0,
    parzialmente_evasa: 1,
    evasa: 2
  }

  scope :evase, -> { where(stato: :evasa) }
  scope :parzialmente_evase, -> { where(stato: :parzialmente_evasa) }
  scope :in_attesa, -> { where(stato: :in_attesa) }

  def residuo
    quantita - quantita_evasa
  end

  def evasa?
    stato == "evasa"
  end

  def parzialmente_evasa?
    stato == "parzialmente_evasa"
  end

  def in_attesa?
    stato == "in_attesa"
  end

  def totale_netto
    quantita * prezzo_unitario
  end

  def totale_imposta
    totale_netto * aliquota_iva / 100
  end

  def totale_lordo
    totale_netto + totale_imposta
  end

  def aggiorna_stato!
    if quantita_evasa >= quantita
      update!(stato: :evasa)
    elsif quantita_evasa > 0
      update!(stato: :parzialmente_evasa)
    else
      update!(stato: :in_attesa)
    end
  end
end
