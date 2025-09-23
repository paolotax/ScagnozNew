class MovimentoMagazzino < ApplicationRecord
  include AggiornaGiacenze

  belongs_to :magazzino
  belongs_to :causale_magazzino
  belongs_to :documento, optional: true
  has_many :righe_movimento_magazzino, dependent: :destroy

  validates :data_movimento, presence: true

  scope :per_magazzino, ->(magazzino) { where(magazzino: magazzino) }
  scope :per_causale, ->(causale) { where(causale_magazzino: causale) }
  scope :per_data, ->(data) { where(data_movimento: data) }

  def applica!(reverse: false)
    factor = reverse ? -1 : 1
    righe_movimento_magazzino.includes(:articolo).find_each do |r|
      Giacenza.appllica_variazione!(magazzino_id, r.articolo_id, r.quantita * causale_magazzino.segno_movimento * factor)
    end
  end

  def to_s
    "#{causale_magazzino.codice} - #{magazzino.nome} (#{data_movimento})"
  end
end

