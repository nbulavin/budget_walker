# frozen_string_literal: true

RSpec.describe BucketInteractors::CreationPerformer do
  describe '#call' do
    subject(:bucket_creation_service) { -> { described_class.call(payload: payload) } }

    let!(:user) { create :user }

    context 'when user provided' do
      context 'with valid params' do
        let(:payload) do
          {
            user: user,
            name: 'New name for bucket',
            bucket_type: 'credit_card'
          }
        end
        let(:expected_attributes) do
          {
            bucket_type: 'credit_card',
            created_at: be,
            expected_enrollment: nil,
            id: be,
            name: 'New name for bucket',
            updated_at: be,
            user_id: user.id,
            color: nil,
            current_balance: 0,
            description: nil,
            provider: nil,
            sort_order: 0
          }.stringify_keys
        end

        it('creates correct bucket') do
          bucket_creation_service.call
          expect(Bucket.first.attributes).to match(expected_attributes)
        end

        it('returns correct info') do
          result = bucket_creation_service.call
          expect(result.success?).to eq(true)
          expect(result.bucket).to eq(Bucket.first)
          expect(result.errors).to eq({})
        end
      end

      context 'with incorrect params' do
        let(:payload) do
          {
            user: user,
            name: nil,
            bucket_type: 'credit_card'
          }
        end

        it('does not create bucket') do
          expect { bucket_creation_service.call }.not_to change(Bucket, :count)
        end

        it('returns correct info') do
          result = bucket_creation_service.call
          expect(result.success?).to eq(false)
          expect(result.bucket).to be_nil
          expect(result.errors).to match({ name: ['должно быть заполнено'] })
        end
      end

      context 'with error during creation' do
        let(:payload) do
          {
            user: user,
            name: 'New name for bucket',
            bucket_type: 'credit_card'
          }
        end

        before { allow_any_instance_of(described_class).to receive(:create_bucket).and_raise(RuntimeError) }

        it('does not create bucket') do
          expect { bucket_creation_service.call }.not_to change(Bucket, :count)
        end

        it('returns correct info') do
          result = bucket_creation_service.call
          expect(result.success?).to eq(false)
          expect(result.bucket).to be_nil
          expect(result.errors)
            .to match({ common: ['Упс! Не удалось создать запись. Проверьте данные и попробуйте снова.'] })
        end
      end
    end
  end
end
