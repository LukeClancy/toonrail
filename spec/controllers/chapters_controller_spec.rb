require 'rails_helper'

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
            post chapters_path, params: mock_params
            expect(response.status).to eq(302)
        end
        include_context 'chapters exist'
        it "is not updateable" do
            patch chapter_path, params: mock_existing_params
            expect(response.status).to eq(302)
        end
        it 'is not destroyable' do
            delete chapter_path, params: mock_existing_params
            expect(response.status).to eq(302)
        end
    end
    context "with authenticated user" do
        include_context "authenticated user"
        it "is not creatable" do
            post chapters_path, params: mock_params
            expect(response.status).to eq(302)
        end
        include_context 'chapters exist'
        it "is not updateable" do
            patch chapter_path, params: mock_existing_params
            expect(response.status).to eq(302)
        end
        it 'is not destroyable' do
            delete chapter_path, params: mock_existing_params
            expect(response.status).to eq(302)
        end
    end
    context 'with admin user' do
        include_context 'admin user'
        it "is createable" do
            get new_chapters_path
            expect(response.status).to eq(200)
            post chapters_path :create, params: mock_params
            expect(response.status).to eq(200)
        end
        include_context 'chapters exist'
        it "is updateable" do
            patch chapter_path, params: mock_existing_params
            expect(response.status).to eq(200)
        end
        it "is destroyable" do
            delete chapter_path, params: mock_existing_params
            expect(response.status).to eq(200)
        end
    end
    let(:maybe_ordered) { Chapter.all }
    it_behaves_like 'it is ordered'
end