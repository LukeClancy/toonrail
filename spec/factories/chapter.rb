FactoryBot.define do
    factory :chapter_update_params, class: Chapter do
        order {
            if Chapter.first.nil?
                raise StandardError("no chapter to update")
            end
            chapter_to_update = Chapter.all.order(order: :desc).first #get the last in the order
            chapter_to_update.order
        }
        title { "test chapter update" }
    end
    factory :chapter_create_params, class: Chapter do
        is_meta {false}
        media { nil }
        order { 10 }
        title { "test chapter create" }
    end
    factory :chapter_create_should_fail_params, class: Chapter do
        is_meta { false }
        media { nil }
        order { 10 }
        title { "test chapter create should fail" }
    end
    factory :chapter_update_should_fail_params, class: Chapter do
        order {
            if Chapter.first.nil?
                raise StandardError("no chapter to update")
            end
            chapter_to_update = Chapter.all.order(order: :desc).first #get the last in the order
            chapter_to_update.order
        }
        title { "test chapter update should fail" }
    end
    factory :chapter_delete_params, class: Chapter do
        order {
            if Chapter.first.nil?
                raise StandardError("no chapter to update")
            end
            chapter_to_update = Chapter.all.order(order: :desc).first #get the last in the order
            chapter_to_update.order
        }
    end
end