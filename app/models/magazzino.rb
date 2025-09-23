# == Schema Information
#
# Table name: magazzini
#
#  id         :bigint           not null, primary key
#  attivo     :boolean          default(TRUE), not null
#  codice     :string(10)       not null
#  nome       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_magazzini_on_codice  (codice) UNIQUE
#
class Magazzino < ApplicationRecord
  has_many :documenti, dependent: :restrict_with_error
  has_many :movimenti_magazzino, dependent: :restrict_with_error
  has_many :giacenze, dependent: :destroy

  validates :nome, presence: true
  validates :codice, presence: true, uniqueness: true, length: { maximum: 10 }
  validates :attivo, inclusion: { in: [true, false] }

  scope :attivi, -> { where(attivo: true) }

  def to_s
    "#{codice} - #{nome}"
  end
end

