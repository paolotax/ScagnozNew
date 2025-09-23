# == Schema Information
#
# Table name: movimenti_magazzino
#
#  id                   :bigint           not null, primary key
#  data_movimento       :date             not null
#  note                 :text
#  riferimento_esterno  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  causale_magazzino_id :bigint           not null
#  documento_id         :bigint
#  magazzino_id         :bigint           not null
#
# Indexes
#
#  index_movimenti_magazzino_on_causale_magazzino_id  (causale_magazzino_id)
#  index_movimenti_magazzino_on_documento_id          (documento_id)
#  index_movimenti_magazzino_on_magazzino_id          (magazzino_id)
#
# Foreign Keys
#
#  fk_rails_...  (causale_magazzino_id => causali_magazzino.id)
#  fk_rails_...  (documento_id => documenti.id)
#  fk_rails_...  (magazzino_id => magazzini.id)
#
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

