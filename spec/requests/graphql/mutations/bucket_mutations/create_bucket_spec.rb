# frozen_string_literal: true

RSpec.describe Mutations::BucketMutations::CreateBucket, type: :request do
  subject(:create_bucket_request) { -> { post '/graphql', params: { query: mutation }, headers: headers } }

  context 'with logged in user' do
    let!(:user) do
      create :user, first_name: 'First name',
                    email: 'Test@gmail.com',
                    authorization_token: 'test'
    end
    let(:headers) { { 'Authorization' => user.authorization_token } }

    context 'with successful creation' do
      context 'with only required' do
        let(:mutation) do
          <<~GQL
            mutation {
              createBucket(
                name: "#{name}"
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
        let(:name) { 'test name' }

        context 'when type = credit_card' do
          let(:type) { 'credit_card' }
          let(:expected_response) do
            {
              'data' => {
                'createBucket' => {
                  'bucket' => {
                    'bucketType' => 'credit_card',
                    'id' => be,
                    'name' => 'test name'
                  },
                  'errors' => {}
                }
              }
            }
          end

          it 'does not create bucket' do
            expect { create_bucket_request.call }.to change(Bucket, :count).by(1)
          end

          it 'returns correct info' do
            create_bucket_request.call
            expect(response).to be_successful
            expect(response_json).to match(expected_response)
          end
        end
      end

      context 'with optional' do
        let(:mutation) do
          <<~GQL
            mutation {
              createBucket(
                name: "test"
                bucketType: credit_card
                expectedEnrollment: 123
                color: "#ffffff"
                description: "test"
                provider: "provider"
              ) {
                bucket {
                  id
                  name
                  bucketType
                  expectedEnrollment
                  color
                  description
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
              'createBucket' => {
                'bucket' => {
                  'bucketType' => 'credit_card',
                  'id' => be,
                  'name' => 'test',
                  'expectedEnrollment' => 123,
                  'color' => '#ffffff',
                  'description' => 'test',
                  'provider' => 'provider'
                },
                'errors' => {}
              }
            }
          }
        end

        it 'does not create bucket' do
          expect { create_bucket_request.call }.to change(Bucket, :count).by(1)
        end

        it 'returns correct info' do
          create_bucket_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end
    end

    context 'with failed creation' do
      context 'when expected enrollment fails' do
        let(:mutation) do
          <<~GQL
            mutation {
              createBucket(
                name: "test"
                bucketType: credit_card
                expectedEnrollment: "string"
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
            'errors' => [
              {
                'extensions' => {
                  'argumentName' => 'expectedEnrollment',
                  'code' => 'argumentLiteralsIncompatible',
                  'typeName' => 'Field'
                },
                'locations' => [
                  {
                    'column' => be,
                    'line' => be
                  }
                ],
                'message' => "Argument 'expectedEnrollment' on Field 'createBucket' has an invalid " \
                             "value (\"string\"). Expected type 'Int'.",
                'path' => %w[mutation createBucket expectedEnrollment]
              }
            ]
          }
        end

        it 'does not create bucket' do
          expect { create_bucket_request.call }.not_to change(Bucket, :count)
        end

        it 'returns correct info' do
          create_bucket_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end

      context 'when provider fails' do
        let(:mutation) do
          <<~GQL
            mutation {
              createBucket(
                name: "test"
                bucketType: credit_card
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
                  "Argument 'provider' on Field 'createBucket' has an invalid value ([]). Expected type 'String'.",
                'path' => %w[mutation createBucket provider]
              }
            ]
          }
        end

        it 'does not create bucket' do
          expect { create_bucket_request.call }.not_to change(Bucket, :count)
        end

        it 'returns correct info' do
          create_bucket_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end

      context 'when color fails' do
        let(:mutation) do
          <<~GQL
            mutation {
              createBucket(
                name: "test"
                bucketType: credit_card
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
                  "Argument 'color' on Field 'createBucket' has an invalid value ([]). Expected type 'String'.",
                'path' => %w[mutation createBucket color]
              }
            ]
          }
        end

        it 'does not create bucket' do
          expect { create_bucket_request.call }.not_to change(Bucket, :count)
        end

        it 'returns correct info' do
          create_bucket_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end

      context 'when description fails' do
        let(:mutation) do
          <<~GQL
            mutation {
              createBucket(
                name: "test"
                bucketType: credit_card
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
                  "Argument 'description' on Field 'createBucket' has an invalid value ([]). Expected type 'String'.",
                'path' => %w[mutation createBucket description]
              }
            ]
          }
        end

        it 'does not create bucket' do
          expect { create_bucket_request.call }.not_to change(Bucket, :count)
        end

        it 'returns correct info' do
          create_bucket_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end

      context 'when creation fails' do
        let(:mutation) do
          <<~GQL
            mutation {
              createBucket(
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
              'createBucket' => {
                'bucket' => nil,
                'errors' => {
                  'common' => ['Упс! Не удалось создать запись. Проверьте данные и попробуйте снова.']
                }
              }
            }
          }
        end

        before do
          allow_any_instance_of(BucketInteractors::CreationPerformer).to receive(:create_bucket).and_raise(RuntimeError)
        end

        it 'does not create bucket' do
          expect { create_bucket_request.call }.not_to change(Bucket, :count)
        end

        it 'returns correct info' do
          create_bucket_request.call
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
          createBucket(
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
          'createBucket' => nil
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
              'createBucket'
            ],
            'extensions' => {
              'code' => 'unauthorized'
            }
          }
        ]
      }
    end

    it 'does not create bucket' do
      expect { create_bucket_request.call }.not_to change(Bucket, :count)
    end

    it 'returns correct info' do
      create_bucket_request.call
      expect(response).to be_successful
      expect(response_json).to match(expected_response)
    end
  end
end
