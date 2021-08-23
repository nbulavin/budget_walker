# frozen_string_literal: true

RSpec.describe BucketContracts::OnCreationContract do
  describe '#call' do
    subject(:create_bucket_contract) { -> { described_class.new.call(**params) } }

    let!(:user) { create :user }

    context 'with valid params' do
      context 'with only required params' do
        let(:params) do
          {
            name: 'test',
            bucket_type: 'credit_card',
            user: user
          }
        end

        it {
          result = create_bucket_contract.call
          expect(result).to be_success
          expect(result.errors).to be_empty
        }
      end

      context 'with optional params' do
        context 'when filled in' do
          let(:params) do
            {
              name: 'test',
              bucket_type: 'credit_card',
              expected_enrollment: '2021-12-17',
              provider: 'test',
              color: '#ffffff',
              description: 'test description',
              user: user
            }
          end

          it {
            result = create_bucket_contract.call
            expect(result).to be_success
            expect(result.errors).to be_empty
          }
        end

        context 'when nil' do
          let(:params) do
            {
              name: 'test',
              bucket_type: 'credit_card',
              expected_enrollment: nil,
              provider: nil,
              color: nil,
              description: nil,
              user: user
            }
          end

          it {
            result = create_bucket_contract.call
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
            result = create_bucket_contract.call
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
            result = create_bucket_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h).to eq({ name: ['Название должно быть заполнено'] })
          }
        end
      end

      context 'when bucket_type' do
        context 'when missing' do
          let(:params) do
            {
              name: 'test',
              user: user
            }
          end

          it {
            result = create_bucket_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h).to eq({ bucket_type: ['Тип счета отсутствует'] })
          }
        end

        context 'when empty' do
          let(:params) do
            {
              name: 'test',
              bucket_type: '',
              user: user
            }
          end

          it {
            result = create_bucket_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h)
              .to eq({ bucket_type: ['Тип счета должен иметь одно из значений: credit_card, account, cash'] })
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
            result = create_bucket_contract.call
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
            result = create_bucket_contract.call
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
            result = create_bucket_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h).to eq({ user: ['Пользователь должен быть заполнен'] })
          }
        end
      end

      context 'when expected_enrollment' do
        context 'when not in date format' do
          let(:params) do
            {
              name: 'test',
              bucket_type: 'credit_card',
              user: user,
              expected_enrollment: '5891-1951-051'
            }
          end

          it {
            result = create_bucket_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h)
              .to eq({ expected_enrollment: ['Ожидаемое зачисление должно содержать время'] })
          }
        end
      end

      context 'when provider' do
        context 'when not in string format' do
          let(:params) do
            {
              name: 'test',
              bucket_type: 'credit_card',
              user: user,
              provider: ['string']
            }
          end

          it {
            result = create_bucket_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h)
              .to eq({ provider: ['Провайдер должен быть текстом'] })
          }
        end
      end

      context 'when color' do
        context 'when not in string format' do
          let(:params) do
            {
              name: 'test',
              bucket_type: 'credit_card',
              user: user,
              color: ['#ffffff']
            }
          end

          it {
            result = create_bucket_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h)
              .to eq({ color: ['Цвет должен быть текстом'] })
          }
        end
      end

      context 'when description' do
        context 'when not in string format' do
          let(:params) do
            {
              name: 'test',
              bucket_type: 'credit_card',
              user: user,
              description: []
            }
          end

          it {
            result = create_bucket_contract.call
            expect(result).not_to be_success
            expect(result.errors(full: true).to_h)
              .to eq({ description: ['Описание должно быть текстом'] })
          }
        end
      end
    end
  end
end
