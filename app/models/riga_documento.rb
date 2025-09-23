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
