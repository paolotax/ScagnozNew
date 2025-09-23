class NumerazioneService
  # Restituisce es. "DDT-2025/001"
  def self.prossimo_numero(tipo:)
    prog = Numeratore.next!(tipo: tipo)
    prefix = case tipo.to_sym
             when :ddt then 'DDT'
             when :fattura then 'FA'
             when :nota_credito then 'NC'
             when :ordine_cliente then 'OC'
             when :ordine_fornitore then 'OF'
             else tipo.to_s.upcase
             end
    sprintf("%s-%d/%03d", prefix, Date.today.year, prog)
  end
end

