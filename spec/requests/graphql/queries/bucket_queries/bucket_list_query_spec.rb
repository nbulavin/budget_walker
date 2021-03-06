# frozen_string_literal: true

RSpec.describe Queries::BucketQueries::BucketListQuery, type: :request do
  describe 'me' do
    subject(:graphql_test_request) { -> { post '/graphql', params: { query: query }, headers: headers } }

    let(:query) do
      <<~GQL
        query {
          getBucketsList {
            list {
              id
              name
              bucketType
            }
            totalCount
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
        let(:expected_buckets_list) do
          {
            'data' => {
              'getBucketsList' => {
                'totalCount' => 1,
                'list' => [
                  {
                    'bucketType' => 'credit_card',
                    'id' => first_bucket.id,
                    'name' => 'First Bucket'
                  }
                ]
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
        let(:expected_buckets_list) do
          {
            'data' => {
              'getBucketsList' => {
                'totalCount' => 0,
                'list' => []
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
    end

    context 'with not logged in user' do
      let(:headers) { {} }
      let(:expected_response) do
        {
          'data' => {
            'getBucketsList' => nil
          },
          'errors' => [
            {
              'message' => '???? ???? ????????????????????????',
              'locations' => [
                {
                  'line' => be,
                  'column' => be
                }
              ],
              'path' => [
                'getBucketsList'
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
