namespace :magazzino do
  desc 'Ricostruisce le giacenze sommando i movimenti (ATTENZIONE: sovrascrive i valori)'
  task rebuild_giacenze: :environment do
    puts '⏳ Rebuild giacenze...'
    Giacenza.delete_all

    MovimentoMagazzino.find_each do |mov|
      segno = mov.causale_magazzino.segno_movimento
      mov.righe_movimento_magazzino.find_each do |r|
        Giacenza.appllica_variazione!(mov.magazzino_id, r.articolo_id, r.quantita * segno)
      end
    end

    puts "✅ Giacenze ricostruite: #{Giacenza.count} righe"
  end

  desc 'Mostra le giacenze per magazzino'
  task :giacenze, [:magazzino_id] => :environment do |t, args|
    if args[:magazzino_id]
      magazzino = Magazzino.find(args[:magazzino_id])
      puts "Giacenze per magazzino: #{magazzino.nome}"
      puts "=" * 50
      magazzino.giacenze.includes(:articolo).each do |g|
        puts "#{g.articolo.sku} - #{g.articolo.titolo}: #{g.quantita} #{g.articolo.unita_misura}"
      end
    else
      puts "Tutte le giacenze:"
      puts "=" * 50
      Giacenza.includes(:magazzino, :articolo).each do |g|
        puts "#{g.magazzino.nome} - #{g.articolo.sku}: #{g.quantita} #{g.articolo.unita_misura}"
      end
    end
  end
end

