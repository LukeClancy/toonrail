def is_ordered?(maybe_ordered)
    maybe_ordered = maybe_ordered.sort { |a, b| a.order <=> b.order }
    x = 1
    maybe_ordered.each do |ob|
        if ob.order != x
            return false
        end
        x+=1
    end
    return true
end

RSpec.shared_examples "it is ordered" do
    it "includes #s 1 to x where x is object count" do
        expect(is_ordered?(maybe_ordered)).to eq(true)
    end
    it "is being tested on at least 10 objects" do
        expect(maybe_ordered.length).to be > 9
    end
end

RSpec.shared_examples "it is ordered on parent" do
    let(:grouped_maybe_ordered) { maybe_ordered.group_by(parent_name_id) }
    it "its groups are ordered from 1 to x where x is group member count" do
        group_orders = []
        for maybe_ordered in grouped_maybe_ordered
            group_orders << is_ordered?(maybe_ordered)
        end
        expect(group_orders).to_not include(false)
    end
end