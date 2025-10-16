class UrlCurtaService

    URL_SERVICO = ENV["servico_encurtamento"]

    def encurtar(url_longa)
        adayfar = Faraday.new
        resp = adayfar.post(URL_SERVICO, { url: url_longa }) 
        page = Nokogiri.parse(resp.body)
        # usar Accept: application/json não funcionou :(  parse na classe
        page.at_css('.short-url')&.attributes&.dig("value")&.value 
    end
end