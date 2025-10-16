require 'rails_helper'

RSpec.describe PerfilsController, type: :controller do
    let!(:perfis) {
        [
            create(:perfil, nome: 'Perfil 1', nome_usuario: Faker::Alphanumeric.alpha(number: 10), organizacao: 'Eagles', localizacao: "Send location"),
            create(:perfil, nome: 'Perfil 2', nome_usuario: Faker::Alphanumeric.alpha(number: 10), organizacao: '???', localizacao: "No location"),
            create(:perfil, nome: 'Perfil 3', nome_usuario: Faker::Alphanumeric.alpha(number: 10), organizacao: nil, localizacao: nil)
        ]
    }
    describe 'GET #index' do
        context 'sem parametro' do
            it 'deve retornar todos os registros' do
                get :index
                expect(assigns(:perfils)).to match(perfis)
            end
        end

        context 'com parametro' do
            it 'deve filtrar baseado no nome' do
                get :index, params: { texto: perfis[1].nome }
                expect(assigns(:perfils)).to match([perfis[1]])
            end

            it 'deve filtrar baseado no nome_usuario' do
                get :index, params: { texto: perfis[2].nome_usuario }
                expect(assigns(:perfils)).to match([perfis[2]])
            end

            it 'deve filtrar baseado na organização' do
                get :index, params: { texto: '?' }
                expect(assigns(:perfils)).to match([perfis[1]])
            end

            it 'deve filtrar baseado na localização' do
                get :index, params: { texto: 'send location' }
                expect(assigns(:perfils)).to match([perfis[0]])
            end

            it 'deve devolver várias ocorrências' do 
                get :index, params: { texto: 'Perfil' }
                expect(assigns(:perfils)).to match(perfis)
            end

            it 'deve filtrar por palavras parciais ou no meio/final do texto' do
                get :index, params: { texto: 'cation' }
                expect(assigns(:perfils)).to match(perfis[0..1])
            end

            it 'deve ignorar up/downcase' do 
                get :index, params: { texto: 'ErFiL' }
                expect(assigns(:perfils)).to match(perfis)
            end

            it 'deve retornar conjunto vazio se não achar nada' do
                get :index, params: { texto: '123456789' }
                expect(assigns(:perfils)).to be_empty
            end
        end
    end

    describe 'GET #show' do
        it 'deve retornar o objeto relacionado ao id' do
            get :show, params: { id: perfis[1] }
            expect(assigns(:perfil)).to eq(perfis[1])
        end

        it 'deve falhar ao pedir id inexistente' do
            expect { get :show, params: { id: Perfil.maximum(:id) + 1 } }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'get #edit' do
        it 'deve retornar o objeto relacionado ao id' do
            get :edit, params: { id: perfis[1] }
            expect(assigns(:perfil)).to eq(perfis[1])
        end

        it 'deve falhar ao pedir id inexistente' do
            expect { get :edit, params: { id: Perfil.maximum(:id) + 1 } }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'POST #create' do
        it 'deve criar e retornar' do
            expect(PerfilInteractor).to receive(:call).and_return(Interactor::Context.build(perfil: perfis[0], status: true))
            post :create, params: { perfil: { nome: perfis[0].nome } }
            expect(response.status).to eq(302)
        end
    end
end