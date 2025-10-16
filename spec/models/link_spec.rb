require 'rails_helper'
require 'rspec/rails'

RSpec.describe Link, type: :model do
    let(:perfil) { create(:perfil) }
    let(:link) { build(:link, perfil_id: perfil.id) }
    let(:link_vazio) { build(:link, :vazio)}
    let(:url_original) { 'github.com/matz' }
    describe 'validações' do
        it 'perfil_id present?' do
            expect(link_vazio.save).to be false
            # o segundo include é um string.include? 
            expect(link_vazio.errors[:perfil_id]).to include(include("blank"))
        end

        it 'url_original present?' do
            expect(link_vazio.save).to be false
            expect(link_vazio.errors[:url_original]).to include(include("blank"))
        end

        it 'url_original do github?' do
            link.url_original = 'nao_github.com'
            expect { link.save }.to raise_error("URL inválida")
        end

        let(:url_padronizada) { 'https://github.com/matz' }
        it 'url_padronizada?' do
            expect {
                link.update(url_original: 'github.com/matz')
            }.to change { link.url_original }.to(url_padronizada)

            # testa um monte só no método
            ["www.github.com/matz", "GITHUB.com/MATZ", "github.com/matz?ahn=chama", "http://github.com/matz"].each do |url|
                link.url_original = url
                expect(link.send(:padronizar_url)).to eq(url_padronizada)
            end
        end
    end

    describe 'url_curta' do 
        let(:url_curta_service) { instance_double(UrlCurtaService) }
        before do
            allow(UrlCurtaService).to receive(:new).and_return(url_curta_service)
        end
        it 'gera pelo serviço' do 
            url_padronizada = link.send(:padronizar_url)
            expect(url_curta_service).to receive(:encurtar).with(url_padronizada).and_return('funcionou.curto/url')
            link.save
        end

        it 'gera pelo backup' do
            url_padronizada = link.send(:padronizar_url)
            allow(url_curta_service).to receive(:encurtar).with(url_padronizada).and_raise(StandardError)
            expect(link).to receive(:link_nem_tao_curto_mas_unico)
            link.save
        end
    end
end