class Busca < ApplicationRecord
    belongs_to :perfil
    enum :status, [:pendente, :processando, :completa, :erro]
end
