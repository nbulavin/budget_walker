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

      context 'with provider' do
        let(:mutation) do
          <<~GQL
            mutation {
              updateBucket(
                id: #{bucket.id}
                provider: "test"
              ) {
                bucket {
                  id
                  name
                  bucketType
                  provider
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
                  'provider' => 'test'
                },
                'errors' => '{}'
              }
            }
          }
        end

        it 'does not create bucket' do
          expect { update_bucket_request.call }.to change { bucket.reload.provider }.to('test')
        end

        it 'returns correct info' do
          update_bucket_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end

      context 'with color' do
        let(:mutation) do
          <<~GQL
            mutation {
              updateBucket(
                id: #{bucket.id}
                color: "#ffffff"
              ) {
                bucket {
                  id
                  name
                  bucketType
                  color
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
                  'color' => '#ffffff'
                },
                'errors' => '{}'
              }
            }
          }
        end

        it 'does not create bucket' do
          expect { update_bucket_request.call }.to change { bucket.reload.color }.to('#ffffff')
        end

        it 'returns correct info' do
          update_bucket_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end

      context 'with description' do
        let(:mutation) do
          <<~GQL
            mutation {
              updateBucket(
                id: #{bucket.id}
                description: "test"
              ) {
                bucket {
                  id
                  name
                  bucketType
                  description
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
                  'description' => 'test'
                },
                'errors' => '{}'
              }
            }
          }
        end

        it 'does not create bucket' do
          expect { update_bucket_request.call }.to change { bucket.reload.description }.to('test')
        end

        it 'returns correct info' do
          update_bucket_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end
    end

    context 'with failed update' do
      context 'when expected_enrollment fails' do
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

      context 'when provider fails' do
        let(:mutation) do
          <<~GQL
            mutation {
              updateBucket(
                id: #{bucket.id}
                provider: []
              ) {
                bucket {
                  id
                  name
                  bucketType
                  provider
                }
                errors
              }
            }
          GQL
        end
        let(:expected_response) do
          {
            'errors' => [
              {
                'extensions' => {
                  'argumentName' => 'provider',
                  'code' => 'argumentLiteralsIncompatible',
                  'typeName' => 'Field'
                },
                'locations' => [
                  {
                    'column' => be,
                    'line' => be
                  }
                ],
                'message' =>
                  "Argument 'provider' on Field 'updateBucket' has an invalid value ([]). Expected type 'String'.",
                'path' => %w[mutation updateBucket provider]
              }
            ]
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

      context 'when color fails' do
        let(:mutation) do
          <<~GQL
            mutation {
              updateBucket(
                id: #{bucket.id}
                color: []
              ) {
                bucket {
                  id
                  name
                  bucketType
                  color
                }
                errors
              }
            }
          GQL
        end
        let(:expected_response) do
          {
            'errors' => [
              {
                'extensions' => {
                  'argumentName' => 'color',
                  'code' => 'argumentLiteralsIncompatible',
                  'typeName' => 'Field'
                },
                'locations' => [
                  {
                    'column' => be,
                    'line' => be
                  }
                ],
                'message' =>
                  "Argument 'color' on Field 'updateBucket' has an invalid value ([]). Expected type 'String'.",
                'path' => %w[mutation updateBucket color]
              }
            ]
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

      context 'when description fails' do
        let(:mutation) do
          <<~GQL
            mutation {
              updateBucket(
                id: #{bucket.id}
                description: []
              ) {
                bucket {
                  id
                  name
                  bucketType
                  description
                }
                errors
              }
            }
          GQL
        end
        let(:expected_response) do
          {
            'errors' => [
              {
                'extensions' => {
                  'argumentName' => 'description',
                  'code' => 'argumentLiteralsIncompatible',
                  'typeName' => 'Field'
                },
                'locations' => [
                  {
                    'column' => be,
                    'line' => be
                  }
                ],
                'message' =>
                  "Argument 'description' on Field 'updateBucket' has an invalid value ([]). Expected type 'String'.",
                'path' => %w[mutation updateBucket description]
              }
            ]
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
