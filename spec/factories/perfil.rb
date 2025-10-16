FactoryBot.define do
    factory :perfil do
        nome { Faker::Name.first_name }
        nome_usuario { Faker::Alphanumeric.alpha(number: 5) }
    end
end