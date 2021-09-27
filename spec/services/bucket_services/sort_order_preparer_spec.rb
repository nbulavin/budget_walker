# frozen_string_literal: true

RSpec.describe BucketServices::SortOrderPreparer do
  describe '#call' do
    subject(:sort_rank_preparer) { -> { described_class.new(user).call } }

    let!(:user) { create :user }

    context 'when user has buckets' do
      let!(:bucket) { create :bucket, user: user, sort_order: 11 }

      it 'returns correct sort_rank' do
        expect(sort_rank_preparer.call).to eq(12)
      end
    end

    context 'when user does not have buckets' do
      it 'returns correct sort_rank' do
        expect(sort_rank_preparer.call).to eq(0)
      end
    end
  end
end
