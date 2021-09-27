# frozen_string_literal: true

RSpec.describe Queries::IncomeCategoryQueries::IncomeCategoryListQuery, type: :request do
  describe 'me' do
    subject(:graphql_test_request) { -> { post '/graphql', params: { query: query }, headers: headers } }

    let(:query) do
      <<~GQL
        query {
          getIncomeCategoryList {
            list {
              id
              name
              expectedRevenue
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
        let!(:first_category) { create :income_category, user: user }
        let(:expected_buckets_list) do
          {
            'data' => {
              'getIncomeCategoryList' => {
                'totalCount' => 1,
                'list' => [
                  {
                    'id' => first_category.id,
                    'name' => 'FirstCategory',
                    'expectedRevenue' => 123
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
              'getIncomeCategoryList' => {
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
            'getIncomeCategoryList' => nil
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
                'getIncomeCategoryList'
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
