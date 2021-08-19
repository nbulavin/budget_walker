# frozen_string_literal: true

RSpec.describe Mutations::BucketMutations::UpdateMutation, type: :request do
  subject(:update_bucket_request) { -> { post '/graphql', params: { query: mutation }, headers: headers } }

  context 'with logged in user' do
    let!(:user) do
      create :user, first_name: 'First name',
                    email: 'Test@gmail.com',
                    authorization_token: 'test'
    end
    let!(:bucket) { create :bucket, user: user }

    let(:headers) { { 'Authorization' => user.authorization_token } }

    context 'with successful update' do
      context 'with type' do
        let(:mutation) do
          <<~GQL
            mutation {
              updateBucket(
                id: #{bucket.id}
                name: "test name"
                bucketType: #{type}
              ) {
                bucket {
                  id
                  name
                  bucketType
                }
                errors
              }
            }
          GQL
        end
        let(:type) { 'account' }
        let(:expected_response) do
          {
            'data' => {
              'updateBucket' => {
                'bucket' => {
                  'bucketType' => 'account',
                  'id' => be,
                  'name' => 'test name'
                },
                'errors' => '{}'
              }
            }
          }
        end

        it 'updates bucket' do
          expect { update_bucket_request.call }
            .to change { bucket.reload.name }.to('test name').and change { bucket.reload.bucket_type }.to('account')
        end

        it 'returns correct info' do
          update_bucket_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end

      context 'with expectedEnrollment' do
        let(:mutation) do
          <<~GQL
            mutation {
              updateBucket(
                id: #{bucket.id}
                expectedEnrollment: "2021-05-12"
              ) {
                bucket {
                  id
                  name
                  bucketType
                  expectedEnrollment
                }
                errors
              }
            }
          GQL
        end
        let(:expected_response) do
          {
            'data' => {
              'updateBucket' => {
                'bucket' => {
                  'bucketType' => 'credit_card',
                  'id' => bucket.id,
                  'name' => 'First Bucket',
                  'expectedEnrollment' => 1_620_777_600
                },
                'errors' => '{}'
              }
            }
          }
        end

        it 'does not create bucket' do
          expect { update_bucket_request.call }.to change { bucket.reload.expected_enrollment }.to(1_620_777_600)
        end

        it 'returns correct info' do
          update_bucket_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end
    end

    context 'with failed update' do
      context 'when expected enrollment fails' do
        let(:mutation) do
          <<~GQL
            mutation {
              updateBucket(
                id: #{bucket.id}
                expectedEnrollment: "5891-1951-051"
              ) {
                bucket {
                  id
                  name
                  bucketType
                  expectedEnrollment
                }
                errors
              }
            }
          GQL
        end
        let(:expected_response) do
          {
            'data' => {
              'updateBucket' => {
                'bucket' => nil,
                'errors' => '{"expectedEnrollment":["должно содержать время"]}'
              }
            }
          }
        end

        it 'does not create bucket' do
          expect { update_bucket_request.call }.not_to change(Bucket, :count)
        end

        it 'returns correct info' do
          update_bucket_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end

      context 'when creation fails' do
        let(:mutation) do
          <<~GQL
            mutation {
              updateBucket(
                id: #{bucket.id}
                name: "test"
                bucketType: credit_card
              ) {
                bucket {
                  id
                  name
                  bucketType
                }
                errors
              }
            }
          GQL
        end
        let(:expected_response) do
          {
            'data' => {
              'updateBucket' => {
                'bucket' => nil,
                'errors' => '{"common":"Упс! Не удалось обновить запись. Проверьте данные и попробуйте снова."}'
              }
            }
          }
        end

        before do
          allow_any_instance_of(Bucket).to receive(:update!).and_raise(RuntimeError)
        end

        it 'does not update bucket' do
          expect { update_bucket_request.call }.not_to change(Bucket, :count)
        end

        it 'returns correct info' do
          update_bucket_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end
    end
  end

  context 'with not logged in user' do
    let(:mutation) do
      <<~GQL
        mutation {
          updateBucket(
            id: 0
            name: "test"
            bucketType: credit_card
          ) {
            bucket {
              id
              name
              bucketType
            }
            errors
          }
        }
      GQL
    end
    let(:name) { 'test name' }
    let(:type) { 'credit_card' }
    let(:headers) { {} }
    let(:expected_response) do
      {
        'data' => {
          'updateBucket' => nil
        },
        'errors' => [
          {
            'message' => 'Вы не авторизованы',
            'locations' => [
              {
                'line' => be,
                'column' => be
              }
            ],
            'path' => [
              'updateBucket'
            ]
          }
        ]
      }
    end

    it 'does not update bucket' do
      expect { update_bucket_request.call }.not_to change(Bucket, :count)
    end

    it 'returns correct info' do
      update_bucket_request.call
      expect(response).to be_successful
      expect(response_json).to match(expected_response)
    end
  end
end
