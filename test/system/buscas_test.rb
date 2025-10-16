require "application_system_test_case"

class BuscasTest < ApplicationSystemTestCase
  setup do
    @busca = buscas(:one)
  end

  test "visiting the index" do
    visit buscas_url
    assert_selector "h1", text: "Buscas"
  end

  test "should create busca" do
    visit buscas_url
    click_on "New busca"

    fill_in "Dados", with: @busca.dados
    fill_in "Mensagem", with: @busca.mensagem
    fill_in "Perfil", with: @busca.perfil_id
    fill_in "Status", with: @busca.status
    click_on "Create Busca"

    assert_text "Busca was successfully created"
    click_on "Back"
  end

  test "should update Busca" do
    visit busca_url(@busca)
    click_on "Edit this busca", match: :first

    fill_in "Dados", with: @busca.dados
    fill_in "Mensagem", with: @busca.mensagem
    fill_in "Perfil", with: @busca.perfil_id
    fill_in "Status", with: @busca.status
    click_on "Update Busca"

    assert_text "Busca was successfully updated"
    click_on "Back"
  end

  test "should destroy Busca" do
    visit busca_url(@busca)
    click_on "Destroy this busca", match: :first

    assert_text "Busca was successfully destroyed"
  end
end
