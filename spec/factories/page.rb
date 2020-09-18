include ActionDispatch::TestProcess

FactoryBot.define do
    factory :page_update_params, class: Page do
        order {
            if Page.first.nil?
                raise StandardError("no page to update")
            end
            page_to_update = Page.all.order(:order).first
            page_to_update.order
        }
        chapter_id { 
            page_to_update = Page.all.order(:order).first
            page_to_update.chapter_id
        }
        title { "test chapter update" }
    end
    factory :page_create_params, class: Page do
        media { fixture_file_upload(Rails.root.to_s + '/spec/fixtures/test_pic.png') }
        order { 10 }
        title { "test page create" }
        text { "<b>test page text</b>" }
        chapter_id { Chapter.first.id }
    end
    factory :page_create_should_fail_params, class: Page do
        media { fixture_file_upload( Rails.root.to_s + '/spec/fixtures/test_pic.png') }
        order { 10 }
        chapter_id { Chapter.first.id }
        title { "test chapter create should fail" }
        text { "<b>test page text</b>" }
    end
    factory :page_update_should_fail_params, class: Page do
        order {
            if Page.first.nil?
                raise StandardError("no page to update")
            end
            page_to_update = Page.all.order(:order).first
            page_to_update.order
        }
        chapter_id { 
            page_to_update = Page.all.order(:order).first
            page_to_update.chapter_id
        }
        title { "test page update should fail" }
    end
    factory :page_delete_params, class: Page do
        order {
            if Page.first.nil?
                raise StandardError("no page to update")
            end
            Page.first.order
        }
        chapter_id {
            Page.first.chapter_id
        }
    end
end