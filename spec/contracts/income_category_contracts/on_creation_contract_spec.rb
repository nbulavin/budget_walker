# frozen_string_literal: true

RSpec.describe IncomeCategoryContracts::OnCreationContract do
  describe '#call' do
    subject(:create_category_contract) { -> { described_class.new.call(**params) } }

    let!(:user) { create :user }

    context 'with valid params' do
      context 'with only required params' do
        let(:params) do
          {
            name: 'test',
            user: user
          }
        end

        it {
          result = create_category_contract.call
          expect(result).to be_success
          expect(result.errors).to be_empty
        }
      end

      context 'with optional params' do
        context 'when filled in' do
          let(:params) do
            {
              name: 'test',
              expected_revenue: 123,
              user: user
            }
          end

          it {
            result = create_category_contract.call
            expect(result).to be_success
            expect(result.errors).to be_empty
          }
        end

        context 'when nil' do
          let(:params) do
            {
              name: 'test',
              expected_revenue: nil,
              user: user
            }
          end

          it {
            result = create_category_contract.call
            expect(result).to be_success
            expect(result.errors).to be_empty
          }
        end
      end
    end

    context 'with incorrect params' do
      context 'when name' do
        context 'when missing' do
          let(:params) do
            {
              bucket_type: 'credit_card',
              user: user
            }
          end

          it {
            result = create_category_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h).to eq({ name: ['Название отсутствует'] })
          }
        end

        context 'when empty' do
          let(:params) do
            {
              name: '',
              bucket_type: 'credit_card',
              user: user
            }
          end

          it {
            result = create_category_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h).to eq({ name: ['Название должно быть заполнено'] })
          }
        end
      end

      context 'when user' do
        context 'when missing' do
          let(:params) do
            {
              name: 'test',
              bucket_type: 'credit_card'
            }
          end

          it {
            result = create_category_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h).to eq({ user: ['Пользователь отсутствует'] })
          }
        end

        context 'when not User' do
          let(:params) do
            {
              name: 'test',
              bucket_type: 'credit_card',
              user: 'string'
            }
          end

          it {
            result = create_category_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h).to eq({ user: ['Пользователь должен быть типом User'] })
          }
        end

        context 'when empty' do
          let(:params) do
            {
              name: 'test',
              bucket_type: 'credit_card',
              user: nil
            }
          end

          it {
            result = create_category_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h).to eq({ user: ['Пользователь должен быть заполнен'] })
          }
        end
      end

      context 'when expected_revenue' do
        context 'when not in integer format' do
          let(:params) do
            {
              name: 'test',
              user: user,
              expected_revenue: [123]
            }
          end

          it {
            result = create_category_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h)
              .to eq({ expected_revenue: ['Ожидаемый доход должен быть числом'] })
          }
        end
      end
    end
  end
end
