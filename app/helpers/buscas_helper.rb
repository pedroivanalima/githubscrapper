module BuscasHelper

    def circulo_status(status)
        case status
        when "pendente"
            "&#x1F7E1"
        when "processando"
            "&#x1F7E0"
        when "completa"
            "&#x1F7E2"
        when "erro"
            "&#x1F534"
        end.html_safe
    end
end
