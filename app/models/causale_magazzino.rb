class CausaleMagazzino < ApplicationRecord
  has_many :movimenti_magazzino, dependent: :restrict_with_error

  validates :codice, presence: true, uniqueness: true, length: { maximum: 6 }
  validates :nome, presence: true
  validates :descrizione, presence: true
  validates :tipo_movimento, presence: true # 0=carico 1=scarico 2=trasferimento

  validates :segno_movimento, presence: true, inclusion: { in: [ -1, 0, 1 ] }
  validates :attiva, inclusion: { in: [ true, false ] }
  validates :di_sistema, inclusion: { in: [ true, false ] }
  validates :richiede_fornitore, inclusion: { in: [ true, false ] }
  validates :richiede_cliente, inclusion: { in: [ true, false ] }

  scope :attive, -> { where(attiva: true) }
  scope :di_sistema, -> { where(di_sistema: true) }

  enum :tipo_movimento, { carico: 0, scarico: 1, trasferimento: 2 }

  def to_s
    "#{codice} - #{nome}"
  end

  def carico?
    segno_movimento > 0
  end

  def scarico?
    segno_movimento < 0
  end

  def neutro?
    segno_movimento == 0
  end
end
