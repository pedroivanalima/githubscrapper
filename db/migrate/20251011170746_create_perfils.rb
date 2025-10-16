class CreatePerfils < ActiveRecord::Migration[8.0]
  def change
    create_table :perfils do |t|
      t.string :nome, null: false
      t.string :nome_usuario
      t.integer :seguidores
      t.integer :seguindo
      t.integer :estrelas
      t.string :contribuicoes
      t.string :url_foto
      t.string :organizacao
      t.string :localizacao

      t.timestamps
    end
  end
end
