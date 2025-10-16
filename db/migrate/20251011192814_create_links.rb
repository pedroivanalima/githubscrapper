class CreateLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :links do |t|
      t.integer :perfil_id, null: false
      t.string :url_curta
      t.string :url_original

      t.timestamps
    end

    add_index :links, :url_curta, unique: true
    add_index :links, :url_original, unique: true
  end
end
