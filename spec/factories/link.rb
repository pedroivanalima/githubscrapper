FactoryBot.define do
    factory :link do
        url_original { 'github.com/matz' }
        perfil_id { build :perfil }

        trait :vazio do
            perfil_id { nil }
            url_original { nil }
        end
    end
end