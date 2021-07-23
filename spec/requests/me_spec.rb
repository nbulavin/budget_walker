RSpec.describe Types::QueryType, type: :request do
  describe 'me' do
    subject { -> { post '/graphql', params: { query: query }, headers: headers } }

    let!(:user) {
      create :user, first_name: 'First name',
                    last_name: 'Last name',
                    email: 'Test@gmail.com',
                    authorization_token: 'test'
    }

    let(:query) do
      %(query {
        me {
          firstName
          email
          authorizationToken
        }
      })
    end

    context 'when authorization token provided' do
      let(:headers) { { 'Authorization' => authorization_header } }

      context 'when token exists' do
        let(:authorization_header) { 'test' }
        let(:expected_user_info) {
          {
            "data" => {
              "me" => {
                "firstName" => "First name",
                "email" => "Test@gmail.com",
                "authorizationToken" => "test"
              }
            }
          }
        }

        it 'returns correct info' do
          subject.call
          expect(response).to be_successful
          expect(response_json).to match(expected_user_info)
        end
      end

      context 'when token does no exist' do
        let(:authorization_header) { 'test2' }
        let(:expected_user_info) {
          {
            'data' => {
              "me" => nil
            }
          }
        }

        it 'returns correct info' do
          subject.call
          expect(response).to be_successful
          expect(response_json).to match(expected_user_info)
        end
      end
    end

    context 'when authorization token not provided' do
      let(:headers) { {} }
      let(:expected_user_info) {
        {
          'data' => {
            "me" => nil
          }
        }
      }

      it 'returns correct info' do
        subject.call
        expect(response).to be_successful
        expect(response_json).to match(expected_user_info)
      end
    end

  end
end