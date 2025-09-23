# == Schema Information
#
# Table name: causali_magazzino
#
#  id                 :bigint           not null, primary key
#  attiva             :boolean          default(TRUE), not null
#  codice             :string(6)        not null
#  descrizione        :text
#  di_sistema         :boolean          default(FALSE), not null
#  nome               :string           not null
#  richiede_cliente   :boolean          default(FALSE), not null
#  richiede_fornitore :boolean          default(FALSE), not null
#  segno_movimento    :integer          default(0), not null
#  tipo_movimento     :integer          default("carico"), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_causali_magazzino_on_codice  (codice) UNIQUE
#
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
