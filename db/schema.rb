# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_13_155644) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "buscas", force: :cascade do |t|
    t.integer "perfil_id"
    t.integer "status", default: 0
    t.string "mensagem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perfil_id"], name: "index_buscas_on_perfil_id"
  end

  create_table "links", force: :cascade do |t|
    t.integer "perfil_id", null: false
    t.string "url_curta"
    t.string "url_original"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url_curta"], name: "index_links_on_url_curta", unique: true
    t.index ["url_original"], name: "index_links_on_url_original", unique: true
  end

  create_table "perfils", force: :cascade do |t|
    t.string "nome", null: false
    t.string "nome_usuario"
    t.integer "seguidores"
    t.integer "seguindo"
    t.integer "estrelas"
    t.string "contribuicoes"
    t.string "url_foto"
    t.string "organizacao"
    t.string "localizacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
