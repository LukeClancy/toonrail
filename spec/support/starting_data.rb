RSpec.shared_context 'chapters exist' do
    before do
        x = 0
        Rails.logger.info("CHAPTER CREATION")
        while x < 12
            #despite random number, should be ordered
            chap = attributes_for(:chapter_create_params)
            chap[:order] = rand(16)
            Rails.logger.info("chap - #{chap.inspect}")
            Chapter.create(chap)
            for a in Chapter.all.order(:order)
                Rails.logger.info("#{a.order}: #{a.inspect()}")
            end
            x += 1
        end
    end
end