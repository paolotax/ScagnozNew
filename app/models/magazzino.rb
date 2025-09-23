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

