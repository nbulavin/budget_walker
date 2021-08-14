# frozen_string_literal: true

RSpec.describe Queries::UserQueries::MeQuery, type: :request do
  describe 'me' do
    subject(:graphql_test_request) { -> { post '/graphql', params: { query: query }, headers: headers } }

    let!(:user) do
      create :user, first_name: 'First name',
                    email: 'Test@gmail.com',
                    authorization_token: 'test'
    end

    let(:query) do
      <<~GQL
        query {
          me {
            firstName
            email
            authorizationToken
          }
        }
      GQL
    end

    context 'when authorization token provided' do
      let(:headers) { { 'Authorization' => authorization_header } }

      context 'when token exists' do
        let(:authorization_header) { 'test' }
        let(:expected_user_info) do
          {
            'data' => {
              'me' => {
                'firstName' => 'First name',
                'email' => 'Test@gmail.com',
                'authorizationToken' => 'test'
              }
            }
          }
        end

        it 'returns correct info' do
          graphql_test_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_user_info)
        end
      end

      context 'when token does no exist' do
        let(:authorization_header) { 'test2' }
        let(:expected_user_info) do
          {
            'data' => {
              'me' => nil
            }
          }
        end

        it 'returns correct info' do
          graphql_test_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_user_info)
        end
      end
    end

    context 'when authorization token not provided' do
      let(:headers) { {} }
      let(:expected_user_info) do
        {
          'data' => {
            'me' => nil
          }
        }
      end

      it 'returns correct info' do
        graphql_test_request.call
        expect(response).to be_successful
        expect(response_json).to match(expected_user_info)
      end
    end
  end
end
