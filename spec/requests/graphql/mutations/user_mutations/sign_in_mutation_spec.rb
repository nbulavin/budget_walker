# frozen_string_literal: true

RSpec.describe Mutations::UserMutations::SignInMutation, type: :request do
  subject(:sign_in_request) { -> { post '/graphql', params: { query: mutation } } }

  let!(:user) do
    create :user, email: 'test@email.com',
                  authorization_token: 'test',
                  password: 'Password',
                  password_confirmation: 'Password'
  end

  context 'when credentials fully provided' do
    context 'when correct' do
      let(:mutation) do
        <<~GQL
          mutation SignMeIn {
            signIn(
              email: "test@email.com"
              password: "Password"
            ) {
              errors
              me {
                firstName
                email
                authorizationToken
              }
            }
          }
        GQL
      end
      let(:expected_response) do
        {
          'errors' => [],
          'me' => {
            'authorizationToken' => 'test',
            'email' => 'test@email.com',
            'firstName' => 'FirstName'
          }
        }
      end

      it {
        sign_in_request.call
        expect(response).to be_successful
        expect(response_json['data']['signIn']).to match(expected_response)
      }
    end

    context 'when not correct' do
      let(:mutation) do
        <<~GQL
          mutation SignMeIn {
            signIn(
              email: "test@email.com"
              password: "test"
            ) {
              errors
              me {
                firstName
                email
                authorizationToken
              }
            }
          }
        GQL
      end
      let(:expected_response) do
        {
          'errors' => ['Oops, unable to log in'],
          'me' => nil
        }
      end

      it {
        sign_in_request.call
        expect(response).to be_successful
        expect(response_json['data']['signIn']).to match(expected_response)
      }
    end
  end

  context 'when credentials partially provided' do
    let(:mutation) do
      <<~GQL
        mutation SignMeIn {
          signIn(
            email: "test@email.com"
          ) {
            errors
            me {
              firstName
              email
              authorizationToken
            }
          }
        }
      GQL
    end
    let(:expected_response) do
      {
        'errors' => [
          {
            'extensions' => {
              'arguments' => 'password',
              'className' => 'Field',
              'code' => 'missingRequiredArguments',
              'name' => 'signIn'
            },
            'locations' => [
              {
                'column' => 3,
                'line' => 2
              }
            ],
            'message' => "Field 'signIn' is missing required arguments: password",
            'path' => [
              'mutation SignMeIn',
              'signIn'
            ]
          }
        ]
      }
    end

    it {
      sign_in_request.call
      expect(response).to be_successful
      expect(response_json).to match(expected_response)
    }
  end

  context 'when credentials not provided' do
    let(:mutation) do
      <<~GQL
        mutation SignMeIn {
          signIn {
            errors
            me {
              firstName
              email
              authorizationToken
            }
          }
        }
      GQL
    end
    let(:expected_response) do
      {
        'errors' => [
          {
            'extensions' => {
              'arguments' => 'email, password',
              'className' => 'Field',
              'code' => 'missingRequiredArguments',
              'name' => 'signIn'
            },
            'locations' => [
              {
                'column' => 3,
                'line' => 2
              }
            ],
            'message' => "Field 'signIn' is missing required arguments: email, password",
            'path' => [
              'mutation SignMeIn',
              'signIn'
            ]
          }
        ]
      }
    end

    it {
      sign_in_request.call
      expect(response).to be_successful
      expect(response_json).to match(expected_response)
    }
  end
end
