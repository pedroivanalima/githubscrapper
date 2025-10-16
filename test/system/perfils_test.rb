require "application_system_test_case"

class PerfilsTest < ApplicationSystemTestCase
  setup do
    @perfil = perfils(:one)
  end

  test "visiting the index" do
    visit perfils_url
    assert_selector "h1", text: "Perfils"
  end

  test "should create perfil" do
    visit perfils_url
    click_on "New perfil"

    fill_in "Nome Usuário", with: @perfil.nome_usuario
    fill_in "Contribuicoes", with: @perfil.contribuicoes
    fill_in "Estrelas", with: @perfil.estrelas
    fill_in "Localizacao", with: @perfil.localizacao
    fill_in "Nome", with: @perfil.nome
    fill_in "Organizacao", with: @perfil.organizacao
    fill_in "Seguidores", with: @perfil.seguidores
    fill_in "Seguindo", with: @perfil.seguindo
    fill_in "Url", with: @perfil.url
    fill_in "Url foto", with: @perfil.url_foto
    click_on "Create Perfil"

    assert_text "Perfil was successfully created"
    click_on "Back"
  end

  test "should update Perfil" do
    visit perfil_url(@perfil)
    click_on "Edit this perfil", match: :first

    fill_in "Nome Usuário", with: @perfil.nome_usuario
    fill_in "Contribuicoes", with: @perfil.contribuicoes
    fill_in "Estrelas", with: @perfil.estrelas
    fill_in "Localizacao", with: @perfil.localizacao
    fill_in "Nome", with: @perfil.nome
    fill_in "Organizacao", with: @perfil.organizacao
    fill_in "Seguidores", with: @perfil.seguidores
    fill_in "Seguindo", with: @perfil.seguindo
    fill_in "Url", with: @perfil.url
    fill_in "Url foto", with: @perfil.url_foto
    click_on "Update Perfil"

    assert_text "Perfil was successfully updated"
    click_on "Back"
  end

  test "should destroy Perfil" do
    visit perfil_url(@perfil)
    click_on "Destroy this perfil", match: :first

    assert_text "Perfil was successfully destroyed"
  end
end
