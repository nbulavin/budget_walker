RSpec.describe Mutations::BucketMutations::CreateMutation, type: :request do
  subject(:create_bucket_request) { -> { post '/graphql', params: { query: mutation }, headers: headers } }

  context 'with logged in user' do
    let!(:user) do
      create :user, first_name: 'First name',
                    email: 'Test@gmail.com',
                    authorization_token: 'test'
    end
    let(:headers) { { 'Authorization' => user.authorization_token } }

    context 'with correct params' do
      context 'with only required' do
        let(:mutation) do
          <<~GQL
            mutation {
              createBucket(
                name: "#{name}"
                type: #{type}
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
          let(:expected_response) {
            {
              'data' => {
                'createBucket' => {
                  'bucket' => {
                    'bucketType' => 'credit_card',
                    'id' => be,
                    'name' => 'test name'
                  },
                  'errors' => []
                }
              }
            }
          }

          it 'returns correct info' do
            create_bucket_request.call
            expect(response).to be_successful
            expect(response_json).to match(expected_response)
          end
        end
      end

      context 'with optional' do

      end
    end
  end

  context 'with not logged in user' do
    let(:mutation) do
      <<~GQL
        mutation {
          createBucket(
            name: "test"
            type: credit_card
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
            ]
          }
        ]
      }
    end

    it 'returns correct info' do
      create_bucket_request.call
      expect(response).to be_successful
      expect(response_json).to match(expected_response)
    end
  end
end
