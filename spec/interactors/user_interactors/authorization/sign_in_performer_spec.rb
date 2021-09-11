# frozen_string_literal: true

RSpec.describe UserInteractors::Authorization::SignInPerformer do
  describe '#call' do
    subject(:sign_in_service) { -> { described_class.call(payload: params) } }

    context 'with correct params' do
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
                token: user.authorization_token,
                errors: []
              }
            end

            it 'returns correct info' do
              result = sign_in_service.call
              expect(result.success?).to eq(true)
              expect(result.me).to eq(user)
              expect(result.token).to eq(user.reload.authorization_token)
              expect(result.errors).to eq({})
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
                token: 'test2test',
                errors: []
              }
            end

            before { allow(SecureRandom).to receive(:uuid).and_return('test2test') }

            it 'returns correct info' do
              result = sign_in_service.call
              expect(result.success?).to eq(true)
              expect(result.me).to eq(user)
              expect(result.token).to eq(user.reload.authorization_token)
              expect(result.errors).to eq({})
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
              token: nil,
              errors: ['Oops, unable to log in']
            }
          end

          it 'returns correct info' do
            result = sign_in_service.call
            expect(result.success?).to eq(false)
            expect(result.me).to be_nil
            expect(result.token).to be_nil
            expect(result.errors).to eq({ common: ['Упс! Проверьте email и пароль и попробуйте снова.'] })
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
            token: nil,
            errors: ['Oops, unable to log in']
          }
        end

        it 'returns correct info' do
          result = sign_in_service.call
          expect(result.success?).to eq(false)
          expect(result.me).to be_nil
          expect(result.token).to be_nil
          expect(result.errors).to eq({ common: ['Упс! Проверьте email и пароль и попробуйте снова.'] })
        end

        it 'does not update auth token' do
          expect { sign_in_service.call }.not_to(change { user.reload.authorization_token })
        end
      end
    end

    context 'with incorrect params' do
      context 'when email is incorrect' do
        let(:params) do
          {
            email: 'testcom',
            password: 'test'
          }
        end

        it 'returns correct info' do
          result = sign_in_service.call
          expect(result.success?).to eq(false)
          expect(result.me).to be_nil
          expect(result.token).to be_nil
          expect(result.errors).to eq({ email: ['имеет неправильный формат'] })
        end
      end

      context 'when password is incorrect' do
        let(:params) do
          {
            email: 'test@email.com',
            password: 'tes'
          }
        end

        it 'returns correct info' do
          result = sign_in_service.call
          expect(result.success?).to eq(false)
          expect(result.me).to be_nil
          expect(result.token).to be_nil
          expect(result.errors).to eq({ password: ['должен быть не короче 4 символов'] })
        end
      end

      context 'when both are incorrect' do
        let(:params) do
          {
            email: 'testcom',
            password: 'tes'
          }
        end
        let(:expected_errors) do
          {
            email: ['имеет неправильный формат'],
            password: ['должен быть не короче 4 символов']
          }
        end

        it 'returns correct info' do
          result = sign_in_service.call
          expect(result.success?).to eq(false)
          expect(result.me).to be_nil
          expect(result.token).to be_nil
          expect(result.errors).to eq(expected_errors)
        end
      end
    end
  end
end
