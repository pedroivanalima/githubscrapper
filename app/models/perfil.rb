class Perfil < ApplicationRecord
    has_one :link, dependent: :destroy
    has_many :buscas, dependent: :destroy
    accepts_nested_attributes_for :link

    def self.procurar(texto)
        ilike = formar_ilike(texto)
        self.where("nome ilike ? or nome_usuario ilike ? or organizacao ilike ? or localizacao ilike ?", ilike, ilike, ilike, ilike)
    end

    def ultima_busca
        Busca.where(perfil_id: self.id).order(created_at: :desc).limit(1).first
    end

    private

    def self.formar_ilike(texto)
        "%" + sanitize_sql_like(texto) + "%"
    end
end
