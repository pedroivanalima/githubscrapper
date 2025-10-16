class Link < ApplicationRecord

    belongs_to :perfil

    before_validation :padronizar_url
    validates :url_original, uniqueness: true, presence: true
    validates :perfil_id, uniqueness: true, presence: true
    before_save :gerar_url_curta

    def gerar_url_curta
        begin
            self.url_curta = UrlCurtaService.new.encurtar(self.url_original)
        rescue 
            self.url_curta = link_nem_tao_curto_mas_unico
        end
    end

    private
    
    def link_nem_tao_curto_mas_unico
        "fretadissimo.com/" + Base64.encode64((Time.now - Time.parse('2025-01-01 00:00:00')).to_i.to_s(32))
    end

    # Força um padrão (https://github.com/perfil) porque existem muitas variações para chegar ao mesmo perfil e redundância não é bom
    # exemplos: 
    # up/downcase  GITHUB.COM, github.com, GiThUb.CoM
    # prefixos https://github.com/matz, https://www.github.com/matz, www.github.com/matz, github.com/matz
    # parâmetros https://github.com/matz?tab=repositories https://github.com/matz?tab=projects
    # o importante é sempre salvar com o mesmo padrão, e se mudar o padrão que salva, mudar os registros anteriores
    def padronizar_url
        if url_original.present?
            nome_perfil = self.url_original.scan(/github.com\/([a-zA-Z0-9]+)\/?/i).flatten
            raise "URL inválida" if nome_perfil.count != 1

            self.url_original = "https://github.com/#{nome_perfil.first.downcase}"
        end
    end
end
