require 'rails_helper'

def cpar(tag) #character param
    return {
        chapter: attributes_for(tag)
    }
end
def cpar_order(tag)
    #used when order is in the url of the request
    attribs = attributes_for(tag)
    return {
        chapter: attribs,
        order: attribs[:order]
    }
end

RSpec.describe ChaptersController, type: :controller do
    let(:mock_params) { {
        chapter: attributes_for(:chapter_create_params)
    } }
    let(:mock_existing_params) {{
        chapter: attributes_for(:chapter_update_params)
    }}

    context 'with unauthenticated user' do
        include_context 'unauthenticated user'
        it "is not creatable" do
            post :create, params: cpar(:chapter_create_should_fail_params)
            expect(response).to have_http_status(:forbidden)
            expect(Chapter.where("title like ?", "should fail").first).to be_nil
        end
        include_context 'chapters exist'
        it "is not updateable" do
            patch :update, params: cpar_order(:chapter_update_should_fail_params) 
            expect(response).to have_http_status(:forbidden)
            expect(Chapter.where("title like ?", "should fail").first).to be_nil
        end
        it 'is not destroyable' do
            Rails.logger.info("AUTH USERRRRR")
            Rails.logger.info "#{@user.inspect}"
            chapter_order = cpar_order(:chapter_delete_params)[:order]
            prev_id = Chapter.find_by(order: chapter_order).id
            delete :destroy, params: { order: chapter_order }
            expect(response).to have_http_status(:forbidden)
            expect(Chapter.where(id: prev_id).first).to_not be_nil
        end
    end

    context "with authenticated user" do
        include_context "authenticated user"
        it "is not creatable" do
            post :create, params: cpar(:chapter_create_should_fail_params)
            expect(response).to have_http_status(:forbidden)
            expect(Chapter.where("title like ?", "should fail").first).to be_nil
        end
        include_context 'chapters exist'
        it "is not updateable" do
            patch :update, params: cpar_order(:chapter_update_should_fail_params) 
            expect(response).to have_http_status(:forbidden)
            expect(Chapter.where("title like ?", "should fail").first).to be_nil
        end
        it 'is not destroyable' do
            Rails.logger.info("AUTH USERRRRR")
            Rails.logger.info "#{@user.inspect}"
            chapter_order = cpar_order(:chapter_delete_params)[:order]
            prev_id = Chapter.find_by(order: chapter_order).id
            delete :destroy, params: { order: chapter_order }
            expect(response).to have_http_status(:forbidden)
            expect(Chapter.where(id: prev_id).first).to_not be_nil
        end
    end

    context 'with admin user' do
        include_context 'admin user'
        it "is createable" do
            chap_count = Chapter.count
            post :create, params: cpar(:chapter_create_params)
            expect(response).to have_http_status(:found)
            expect(Chapter.count).to eq(chap_count + 1)
        end
        include_context 'chapters exist'
        it "is updateable" do
            oldlog = ActiveRecord::Base.logger
            ActiveRecord::Base.logger = nil
            para = cpar_order(:chapter_update_params) 
            Rails.logger.info("chapters exists is updateable")
            Rails.logger.info(para.inspect)
            for c in Chapter.all
                Rails.logger.info(c.inspect)
            end
            Rails.logger.info("_________________________________________")
            patch :update, params: para
            expect(response).to have_http_status(:found)
            for c in Chapter.all
                Rails.logger.info(c.inspect)
            end
            ActiveRecord::Base.logger = oldlog
            expect(Chapter.find_by(order: para[:order]).title).to include("update")
        end
        it "is destroyable" do
            chapter_order = cpar_order(:chapter_delete_params)[:order]
            prev_id = Chapter.find_by(order: chapter_order).id
            delete :destroy, params: { order: chapter_order }
            expect(response).to have_http_status(:found)
            expect(Chapter.where(id: prev_id).first).to be_nil
        end
    end

    context 'where multiple chapters exist' do
        include_context 'chapters exist'
        let(:maybe_ordered) { Chapter.all }
        it_behaves_like 'it is ordered'
    end
end