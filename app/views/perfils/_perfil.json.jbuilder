json.extract! perfil, :id, :nome, :url, :nome_usuario, :seguidores, :seguindo, :estrelas, :contribuicoes, :url_foto, :organizacao, :localizacao, :created_at, :updated_at
json.url perfil_url(perfil, format: :json)
