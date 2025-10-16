class BuscaService
    def initialize(busca_id)
        @busca = Busca.find(busca_id)
        @busca.update(status: 'processando')
    end

    def executar
        begin
            resp = faraday.get "/user/#{github_login}"

            paginaInicial()
            estrelando()
            #contribuicoes()
            perfil.save!

            @busca.update(status: 'completa', mensagem: nil)
        rescue => e
            @busca.update(status: 'erro', mensagem: e.message)
            @busca.perfil.update(nome_usuario: nil, seguidores: nil, seguindo: nil, estrelas: nil, contribuicoes: nil, url_foto: nil, organizacao: nil, localizacao: nil)
        end
    end

    

    def paginaInicial
        conteudo = get("/users/#{github_login}", "Página Inicial")
        perfil.nome_usuario = conteudo.dig("login")
        perfil.seguidores = conteudo.dig("followers")
        perfil.seguindo = conteudo.dig("following")
        perfil.url_foto = conteudo.dig("avatar_url")
        perfil.organizacao = conteudo.dig("company")
        perfil.localizacao = conteudo.dig("location")
    end

    # overkill trazer tudo, mas é assim que o github decidiu fazer
    def estrelando
        conteudo = get("/users/#{github_login}/starred", "Starred")
        perfil.estrelas = conteudo.count
    end

    # esta informação está no perfil público, porém usando o cliente github
    def contribucoes
        ano = Date.today.year
        conteudo = get("/#{github_login}?tab=overview&from=#{ano}-01-01&to=#{ano}-12-31", "Contribuições", true)
    end

    def github_login
        @busca.perfil.link.url_original.split("/").last
    end

    def faraday
        @faraday ||= Faraday.new("https://api.github.com/")
    end

    def github_faraday
        @github_faraday ||= Faraday.new("https://github.com")
    end

    def get(pagina, nome, outro = false)
        resp = outro ? github_faraday.get(pagina) : faraday.get(pagina)
        raise "#{nome} retornou  #{resp.status}: #{resp.reason_phrase} para #{pagina}" unless resp.success?

        if outro
            resp.body
        else
            JSON.parse(resp.body)
        end
    end

    def perfil
        @busca.perfil
    end
end