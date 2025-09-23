class Documento < ApplicationRecord
  include AggiornaGiacenze
  include StatoDocumento

  belongs_to :soggetto, optional: true
  belongs_to :magazzino, optional: true
  has_many :righe_documento, dependent: :destroy

  validates :numero, presence: true
  validates :data_documento, presence: true
  validates :tipo, presence: true
  validates :stato, presence: true, inclusion: { in: %w[bozza confermato evaso evaso_parzialmente annullato] }
  validates :totale_netto, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :totale_imposta, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :totale_lordo, presence: true, numericality: { greater_than_or_equal_to: 0 }

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

  enum :stato, {
    bozza: "bozza",
    confermato: "confermato",
    evaso: "evaso",
    evaso_parzialmente: "evaso_parzialmente",
    annullato: "annullato"
  }

  scope :per_tipo, ->(tipo) { where(tipo: tipo) }
  scope :per_stato, ->(stato) { where(stato: stato) }
  scope :confermati, -> { where(stato: "confermato") }
  scope :evasi, -> { where(stato: [ "evaso", "evaso_parzialmente" ]) }

  def to_s
    "#{numero} - #{soggetto&.ragione_sociale}"
  end

  def evaso?
    righe_documento.all?(&:evasa?)
  end

  def parzialmente_evaso?
    righe_documento.any? { |r| r.parzialmente_evasa? } && !evaso?
  end

  def ricalcola_totali!
    netto = righe_documento.sum { |r| r.quantita * r.prezzo_unitario }
    imposta = righe_documento.sum { |r| r.quantita * r.prezzo_unitario * r.aliquota_iva / 100 }
    lordo = netto + imposta

    update!(
      totale_netto: netto,
      totale_imposta: imposta,
      totale_lordo: lordo
    )
  end
end
