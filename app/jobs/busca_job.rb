class BuscaJob < ApplicationJob
    def perform(busca_id)
        BuscaService.new(busca_id).executar
    end
end