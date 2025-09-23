# == Schema Information
#
# Table name: soggetti
#
#  id              :bigint           not null, primary key
#  codice_fiscale  :string
#  email           :string
#  partita_iva     :string
#  ragione_sociale :string           not null
#  telefono        :string
#  tipo            :string           default("generico"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_soggetti_on_tipo_and_ragione_sociale  (tipo,ragione_sociale)
#
class Soggetto < ApplicationRecord
  has_many :documenti, dependent: :restrict_with_error

  validates :ragione_sociale, presence: true
  validates :tipo, presence: true, inclusion: { in: %w[cliente fornitore generico] }
  validates :partita_iva, format: { with: /\A\d{11}\z/, message: "deve essere di 11 cifre" }, allow_blank: true
  validates :codice_fiscale, format: { with: /\A[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]\z/, message: "formato non valido" }, allow_blank: true

  scope :clienti, -> { where(tipo: 'cliente') }
  scope :fornitori, -> { where(tipo: 'fornitore') }
  scope :generici, -> { where(tipo: 'generico') }

  def to_s
    ragione_sociale
  end

  def cliente?
    tipo == 'cliente'
  end

  def fornitore?
    tipo == 'fornitore'
  end
end

