# frozen_string_literal: true

RSpec.describe Queries::BucketQueries::ShowQuery, type: :request do
  describe 'me' do
    subject(:graphql_test_request) { -> { post '/graphql', params: { query: query }, headers: headers } }

    let(:query) do
      <<~GQL
        query {
          getBucketDetails(
            id: #{bucket_id}
          ) {
            id
            name
            bucketType
          }
        }
      GQL
    end

    context 'with logged in user' do
      let!(:user) do
        create :user, first_name: 'First name',
                      email: 'Test@gmail.com',
                      authorization_token: 'test'
      end
      let(:headers) { { 'Authorization' => user.authorization_token } }

      context 'with buckets in database' do
        let!(:first_bucket) { create :bucket, bucket_type: 0, user: user }
        let(:bucket_id) { first_bucket.id }
        let(:expected_buckets_list) do
          {
            'data' => {
              'getBucketDetails' => {
                'bucketType' => 'credit_card',
                'id' => first_bucket.id,
                'name' => 'First Bucket'
              }
            }
          }
        end

        it 'returns correct info' do
          graphql_test_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_buckets_list)
        end
      end

      context 'without buckets in database' do
        let(:bucket_id) { 0 }
        let(:expected_buckets_list) do
          {
            'data' => {
              'getBucketDetails' => nil
            },
            'errors' => [
              {
                'locations' => [
                  {
                    'column' => be,
                    'line' => be
                  }
                ],
                'message' => 'Упс! Мы не нашли то, что вы искали. Проверьте правильность и повторите запрос',
                'path' => [
                  'getBucketDetails'
                ]
              }
            ]
          }
        end

        it 'returns correct info' do
          graphql_test_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_buckets_list)
        end
      end
    end

    context 'with not logged in user' do
      let(:bucket_id) { 0 }
      let(:headers) { {} }
      let(:expected_response) do
        {
          'data' => {
            'getBucketDetails' => nil
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
                'getBucketDetails'
              ],
              'extensions' => {
                'code' => 'unauthorized'
              }
            }
          ]
        }
      end

      it 'returns correct info' do
        graphql_test_request.call
        expect(response).to be_successful
        expect(response_json).to match(expected_response)
      end
    end
  end
end
