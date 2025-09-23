class AddConstraintsAndIndexes < ActiveRecord::Migration[8.1]
  def change
    # CHECK constraints utili (PostgreSQL)
    if connection.adapter_name.downcase.include?("postgres")
      execute <<~SQL
        ALTER TABLE righe_documento
        ADD CONSTRAINT righe_documento_qta_pos_chk CHECK (quantita >= 0),
        ADD CONSTRAINT righe_documento_evasa_le_quantita_chk CHECK (quantita_evasa >= 0 AND quantita_evasa <= quantita);

        ALTER TABLE righe_movimento_magazzino
        ADD CONSTRAINT righe_mov_mag_qta_pos_chk CHECK (quantita > 0);

        ALTER TABLE causali_magazzino
        ADD CONSTRAINT causali_segno_chk CHECK (segno_movimento IN (-1,0,1));
      SQL
    end

    add_index :documenti, :stato
    # add_index :righe_movimento_magazzino, :riga_documento_id
  end
end
