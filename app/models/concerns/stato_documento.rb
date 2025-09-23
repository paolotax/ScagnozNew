module StatoDocumento
  extend ActiveSupport::Concern

  included do
    after_commit :ricalcola_stato!
  end

  def ricalcola_stato!
    return if tipo == 'ddt' # lo stato DDT lo gestisci con conferma/annullo
    if righe_documento.all?(&:evasa?)
      update_column(:stato, 'evaso')
    elsif righe_documento.any? { |r| r.parzialmente_evasa? }
      update_column(:stato, 'evaso_parzialmente')
    else
      update_column(:stato, 'confermato')
    end
  end
end

