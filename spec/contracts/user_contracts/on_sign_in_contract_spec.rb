# frozen_string_literal: true

RSpec.describe UserContracts::OnSignInContract do
  describe '#call' do
    subject(:sign_in_contract) { -> { described_class.new.call(**params) } }

    context 'with valid params' do
      let(:params) do
        {
          email: 'qa@qa.qa',
          password: 'test'
        }
      end

      it {
        result = sign_in_contract.call
        expect(result).to be_success
        expect(result.errors).to be_empty
      }
    end

    context 'with incorrect params' do
      context 'when email' do
        context 'when not email' do
          let(:params) do
            {
              email: 'string',
              password: 'test'
            }
          end

          it {
            result = sign_in_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h)
              .to eq({ email: ['Почтовый ящик имеет неправильный формат'] })
          }
        end

        context 'when empty' do
          let(:params) do
            {
              email: '',
              password: 'test'
            }
          end

          it {
            result = sign_in_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h)
              .to eq({ email: ['Почтовый ящик должен быть заполнен'] })
          }
        end

        context 'when nil' do
          let(:params) do
            {
              email: nil,
              password: 'test'
            }
          end

          it {
            result = sign_in_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h)
              .to eq({ email: ['Почтовый ящик должен быть заполнен'] })
          }
        end
      end

      context 'when password' do
        context 'when too short' do
          let(:params) do
            {
              email: 'qa@qa.qa',
              password: 'tes'
            }
          end

          it {
            result = sign_in_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h)
              .to eq({ password: ['Пароль должен быть не короче 4 символов'] })
          }
        end

        context 'when empty' do
          let(:params) do
            {
              email: 'qa@qa.qa',
              password: ''
            }
          end

          it {
            result = sign_in_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h)
              .to eq({ password: ['Пароль должен быть заполнен'] })
          }
        end

        context 'when nil' do
          let(:params) do
            {
              email: 'qa@qa.qa',
              password: nil
            }
          end

          it {
            result = sign_in_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h)
              .to eq({ password: ['Пароль должен быть заполнен'] })
          }
        end
      end
    end
  end
end
