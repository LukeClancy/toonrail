require 'rails_helper'

def ppar(tag) #page_param
    at = attributes_for(tag)
    ord = Chapter.find(at[:chapter_id]).order
    return {
        page: at,
        chapter_order: ord
    }
end
def ppar_order(tag)
    #used when order is in the url of the request
    attribs = attributes_for(tag)
    chap_ord = Chapter.find(attribs[:chapter_id]).order
    attribs.except!(:chapter_id)
    return {
        page: attribs,
        order: attribs[:order],
        chapter_order: chap_ord
    }
end

RSpec.describe PagesController, type: :controller do
    context 'with authenticated user' do
        include_context 'authenticated user'
        include_context 'pages exist'
        it "is not creatable" do
            post :create, params: ppar(:page_create_should_fail_params)
            expect(response).to have_http_status(:forbidden)
            expect(Page.where("title like ?", "should fail").first).to be_nil
        end
        it "is not updateable" do
            patch :update, params: ppar_order(:page_update_should_fail_params) 
            expect(response).to have_http_status(:forbidden)
            expect(Page.where("title like ?", "should fail").first).to be_nil
        end
        it 'is not destroyable' do
            params = ppar_order(:page_delete_params)
            prev_id = Page.find_by(order: params[:order]).id
            delete :destroy, params: params.except(:page)
            expect(response).to have_http_status(:forbidden)
            expect(Page.where(id: prev_id).first).to_not be_nil
        end
    end

    context "with unauthenticated user" do
        include_context 'pages exist'
        include_context "unauthenticated user"
        it "is not creatable" do
            post :create, params: ppar(:page_create_should_fail_params)
            expect(response).to have_http_status(:forbidden)
            expect(Page.where("title like ?", "should fail").first).to be_nil
        end
    end

    context 'with admin user' do
        include_context 'admin user'
        include_context 'pages exist'
        it "is createable" do
            page_count = Page.count
            post :create, params: ppar(:page_create_params)
            expect(response).to have_http_status(:found)
            expect(Page.count).to eq(page_count + 1)
        end
        it "is updateable" do
            para = ppar_order(:page_update_params)
            page_id = Page.find_by(order: para[:order], chapter_id: Chapter.find_by(order: para[:chapter_order]).id).id
            patch :update, params: para
            expect(response).to have_http_status(:found)
            expect(Page.find(page_id).title).to include("update")
        end
        it "is destroyable" do
            par = ppar_order(:page_delete_params)
            order = par[:order]
            chapter_order = par[:chapter_order]
            chapter_id = Chapter.find_by(order: chapter_order).id
            prev_id = Page.find_by(order: order, chapter_id: chapter_id).id
            delete :destroy, params: { order: order, chapter_order: chapter_order}
            expect(response).to have_http_status(:found)
            expect(Page.where(id: prev_id).first).to be_nil
        end
    end

    context 'where multiple pages exist' do
        include_context 'pages exist'
        let(:parent_column_name) { :chapter_id }
        let(:maybe_ordered) { Page.all }
        it_behaves_like 'it is ordered on parent'
    end
end