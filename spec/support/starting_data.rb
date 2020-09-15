RSpec.shared_context 'chapters exist' do
    include_context 'admin user'
    let(:mock_params) { {
        chapter: attributes_for(:chapter_create_params)
    } }

    before do
        x = 0
        while x < 50
            #despite random number, should be ordered
            mock_params[:chapter][:order] = rand(60)
            post :create, params: mock_params
            x += 1
        end
    end
end