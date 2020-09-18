RSpec.shared_context 'chapters exist' do
    before do
        x = 0; while x < 12
            #despite random number, should be ordered
            chap = attributes_for(:chapter_create_params)
            chap[:order] = rand(16)
            chap[:user_id] = get_create_admin()
            Chapter.create!(chap)
        x += 1; end
    end
end

RSpec.shared_context 'pages exist' do
    before do
        y = 0; while y < 2
            chap_at = attributes_for(:chapter_create_params)
            chap_at[:user_id] = get_create_admin()
            chap = Chapter.create(chap_at)
            x = 0; while x < 12
                page_at = attributes_for(:page_create_params)                
                page_at[:chapter_id] = chap.id
                page_at[:user_id] = get_create_admin()
                Page.create!(page_at)
            x += 1; end
        y += 1; end
    end
end
