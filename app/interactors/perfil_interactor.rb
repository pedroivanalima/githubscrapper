class PerfilInteractor
    include Interactor

    # Perfil sempre tem um link associado
    # Todo perfil novo gera uma busca
    # E toda vez que muda o link.url_original também é feita uma nova busca
    def call
        cria_busca = false
        context.perfil = if context.id
                            p = Perfil.find(context.id)
                            # se não desmembrar o nested ele tenta salvar direto
                            p.assign_attributes context[:perfil_params].except(:link_attributes)
                            p.link.assign_attributes context[:perfil_params][:link_attributes]
                            cria_busca = p.link.will_save_change_to_url_original?
                            p
                        else
                            cria_busca = true
                            Perfil.new context[:perfil_params].to_h
                        end

        if context.perfil.save            
            # e é criação ou mudando url_original
            if cria_busca
                context.perfil.buscas << Busca.new
                BuscaJob.new.perform(context.perfil.buscas[-1].id)
            end
            context.status = true
        else
            context.status = false
            context.errors = perfil.errors
        end
    rescue => e
        context.status = false
        context.errors = context.perfil.errors
    end
end