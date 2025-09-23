# == Schema Information
#
# Table name: documenti
#
#  id             :bigint           not null, primary key
#  data_documento :date             not null
#  numero         :string           not null
#  stato          :string           default("bozza"), not null
#  tipo           :integer          default("ordine_cliente"), not null
#  totale_imposta :decimal(12, 2)   default(0.0), not null
#  totale_lordo   :decimal(12, 2)   default(0.0), not null
#  totale_netto   :decimal(12, 2)   default(0.0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  magazzino_id   :bigint
#  soggetto_id    :bigint
#
# Indexes
#
#  index_documenti_on_magazzino_id     (magazzino_id)
#  index_documenti_on_soggetto_id      (soggetto_id)
#  index_documenti_on_stato            (stato)
#  index_documenti_on_tipo_and_numero  (tipo,numero) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (magazzino_id => magazzini.id)
#  fk_rails_...  (soggetto_id => soggetti.id)
#
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
