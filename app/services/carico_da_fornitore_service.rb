class CaricoDaFornitoreService
  def initialize(ordine_fornitore:, magazzino:, righe:)
    @ordine = ordine_fornitore
    @magazzino = magazzino
    @righe = righe # [{ riga_documento:, quantita: }]
  end

  def call!
    Documento.transaction do
      ddt_num = NumerazioneService.prossimo_numero(tipo: :ddt)
      ddt = Documento.create!(
        tipo: :ddt, 
        numero: ddt_num, 
        data_documento: Date.today, 
        soggetto: @ordine.soggetto, 
        magazzino: @magazzino, 
        stato: 'confermato'
      )
      causale_carico = CausaleMagazzino.find_by!(codice: 'CA')
      mov = MovimentoMagazzino.create!(
        data_movimento: Date.today, 
        magazzino: @magazzino, 
        causale_magazzino: causale_carico, 
        documento: ddt
      )

      @righe.each do |h|
        riga = h[:riga_documento]
        qty = h[:quantita].to_d
        raise ArgumentError, 'Quantità > residuo' if qty > riga.residuo
        mov.righe_movimento_magazzino.create!(
          articolo: riga.articolo, 
          quantita: qty, 
          riga_documento: riga
        )
        riga.update!(
          quantita_evasa: riga.quantita_evasa + qty, 
          stato: riga.residuo - qty > 0 ? :parzialmente_evasa : :evasa
        )
      end

      mov.respond_to?(:applica!) ? mov.applica! : nil # se non usi il concern
      @ordine.update!(stato: @ordine.evaso? ? 'evaso' : 'evaso_parzialmente')
      ddt
    end
  end
end

