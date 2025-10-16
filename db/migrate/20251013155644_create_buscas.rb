class CreateBuscas < ActiveRecord::Migration[8.0]
  def change
    create_table :buscas do |t|
      t.integer :perfil_id
      t.integer :status, default: 0
      t.string :mensagem

      t.timestamps
    end
    add_index :buscas, :perfil_id
  end
end
