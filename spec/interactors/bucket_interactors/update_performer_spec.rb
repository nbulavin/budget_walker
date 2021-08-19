# frozen_string_literal: true

RSpec.describe BucketInteractors::UpdatePerformer do
  describe '#call' do
    subject(:bucket_creation_service) { -> { described_class.call(payload: payload) } }

    let!(:user) { create :user }

    context 'when user provided' do
      context 'when bucket exists' do
        context 'when bucket belongs to user' do
          let!(:bucket) { create :bucket, user: user }

          context 'with valid params' do
            let(:payload) do
              {
                id: bucket.id,
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
                id: bucket.id,
                name: 'New name for bucket',
                updated_at: be,
                user_id: user.id
              }.stringify_keys
            end

            it('correctly updates bucket') do
              bucket_creation_service.call
              expect(bucket.reload.attributes).to match(expected_attributes)
            end

            it('returns correct info') do
              result = bucket_creation_service.call
              expect(result.success?).to eq(true)
              expect(result.bucket).to eq(bucket)
              expect(result.errors).to eq({})
            end
          end

          context 'with incorrect params' do
            let(:payload) do
              {
                id: bucket.id,
                user: user,
                name: nil,
                bucket_type: 'credit_card'
              }
            end

            it('does not create bucket') do
              expect { bucket_creation_service.call }.not_to(change { bucket.reload.name })
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
                id: bucket.id,
                user: user,
                name: 'New name for bucket',
                bucket_type: 'credit_card'
              }
            end

            before { allow_any_instance_of(described_class).to receive(:update_bucket).and_raise(RuntimeError) }

            it('does not update bucket') do
              expect { bucket_creation_service.call }.not_to(change { bucket.reload.name })
            end

            it('returns correct info') do
              result = bucket_creation_service.call
              expect(result.success?).to eq(false)
              expect(result.bucket).to be_nil
              expect(result.errors)
                .to match({ common: 'Упс! Не удалось обновить запись. Проверьте данные и попробуйте снова.' })
            end
          end
        end

        context 'when bucket does not belong to user' do
          let!(:another_user) { create :user }
          let!(:bucket) { create :bucket, user: another_user }
          let(:payload) do
            {
              id: bucket.id,
              user: user,
              name: 'New name for bucket',
              bucket_type: 'credit_card'
            }
          end

          it('does not update bucket') do
            expect { bucket_creation_service.call }.not_to(change { bucket.reload.name })
          end

          it('returns correct info') do
            result = bucket_creation_service.call
            expect(result.success?).to eq(false)
            expect(result.bucket).to be_nil
            expect(result.errors)
              .to match({ common: 'Упс! Запись не найдена. Проверьте данные и попробуйте снова.' })
          end
        end
      end

      context 'when bucket does not exist' do
        let!(:another_user) { create :user }
        let!(:bucket) { create :bucket, user: another_user }
        let(:payload) do
          {
            id: 0,
            user: user,
            name: 'New name for bucket',
            bucket_type: 'credit_card'
          }
        end

        it('does not update bucket') do
          expect { bucket_creation_service.call }.not_to(change { bucket.reload.name })
        end

        it('returns correct info') do
          result = bucket_creation_service.call
          expect(result.success?).to eq(false)
          expect(result.bucket).to be_nil
          expect(result.errors)
            .to match({ common: 'Упс! Запись не найдена. Проверьте данные и попробуйте снова.' })
        end
      end
    end
  end
end
