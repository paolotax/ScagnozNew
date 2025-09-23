# == Schema Information
#
# Table name: articoli
#
#  id           :bigint           not null, primary key
#  attivo       :boolean          default(TRUE), not null
#  autore       :string
#  barcode      :string
#  editore      :string
#  sku          :string(32)       not null
#  titolo       :string           not null
#  unita_misura :string           default("pz"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_articoli_on_sku  (sku) UNIQUE
#
class Articolo < ApplicationRecord
  has_many :righe_documento, dependent: :restrict_with_error
  has_many :righe_movimento_magazzino, dependent: :restrict_with_error
  has_many :giacenze, dependent: :destroy

  validates :sku, presence: true, uniqueness: true, length: { maximum: 32 }
  validates :titolo, presence: true
  validates :unita_misura, presence: true
  validates :attivo, inclusion: { in: [ true, false ] }

  scope :attivi, -> { where(attivo: true) }

  def to_s
    "#{sku} - #{titolo}"
  end

  def giacenza_totale
    giacenze.sum(:quantita)
  end

  def giacenza_in_magazzino(magazzino)
    giacenze.find_by(magazzino: magazzino)&.quantita || 0
  end
end
