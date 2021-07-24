# frozen_string_literal: true

RSpec.describe UserServices::Authorization::SignInPerformer do
  describe '#call' do
    subject(:sign_in_service) { -> { described_class.new(**params).call } }

    let!(:user) do
      create :user, email: 'test@email.com',
                    password: 'test',
                    password_confirmation: 'test',
                    authorization_token: authorization_token
    end

    context 'when user found' do
      context 'when password matches' do
        let(:params) do
          {
            email: 'test@email.com',
            password: 'test'
          }
        end

        context 'when user already has auth token' do
          let(:authorization_token) { 'testtest' }
          let(:expected_hash) do
            {
              me: user,
              errors: []
            }
          end

          it 'returns correct info' do
            expect(sign_in_service.call).to match(expected_hash)
          end

          it 'does not update auth token' do
            sign_in_service.call
            expect(user.reload.authorization_token).to eq('testtest')
          end
        end

        context 'when user does not have auth token' do
          let(:authorization_token) { nil }
          let(:expected_hash) do
            {
              me: user,
              errors: []
            }
          end

          before { allow(SecureRandom).to receive(:uuid).and_return('test2test') }

          it 'returns correct info' do
            expect(sign_in_service.call).to match(expected_hash)
          end

          it 'does not update auth token' do
            sign_in_service.call
            expect(user.reload.authorization_token).to eq('test2test')
          end
        end
      end

      context 'when password does not match' do
        let(:authorization_token) { nil }
        let(:params) do
          {
            email: 'test@email.com',
            password: 'test23'
          }
        end
        let(:expected_hash) do
          {
            me: nil,
            errors: ['Oops, unable to log in']
          }
        end

        it 'returns correct info' do
          expect(sign_in_service.call).to match(expected_hash)
        end

        it 'does not update auth token' do
          expect { sign_in_service.call }.not_to(change { user.reload.authorization_token })
        end
      end
    end

    context 'when user not found' do
      let(:authorization_token) { nil }
      let(:params) do
        {
          email: 'test@email2.com',
          password: 'test'
        }
      end
      let(:expected_hash) do
        {
          me: nil,
          errors: ['Oops, unable to log in']
        }
      end

      it 'returns correct info' do
        expect(sign_in_service.call).to match(expected_hash)
      end

      it 'does not update auth token' do
        expect { sign_in_service.call }.not_to(change { user.reload.authorization_token })
      end
    end
  end
end
