FactoryBot.define do
    factory :chapter_update_params, class: Chapter do
        is_meta { false }
        media { nil }
        order { Chapter.first[:order] }
        title { "a test" }
        id { Chapter.first.id }
    end
    factory :chapter_create_params, class: Chapter do 
        is_meta { false }
        media { nil }
        order { 10 }
        title { "a test" }
    end
end