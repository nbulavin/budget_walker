# frozen_string_literal: true

RSpec.describe Mutations::IncomeCategoryMutations::CreateIncomeCategory, type: :request do
  subject(:create_category_request) { -> { post '/graphql', params: { query: mutation }, headers: headers } }

  context 'with logged in user' do
    let!(:user) do
      create :user, first_name: 'First name',
                    email: 'Test@gmail.com',
                    authorization_token: 'test'
    end
    let(:headers) { { 'Authorization' => user.authorization_token } }

    context 'with successful creation' do
      context 'with only required' do
        let(:mutation) do
          <<~GQL
            mutation {
              createIncomeCategory(
                name: "#{name}"
              ) {
                incomeCategory {
                  id
                  name
                }
                errors
              }
            }
          GQL
        end
        let(:name) { 'test name' }
        let(:expected_response) do
          {
            'data' => {
              'createIncomeCategory' => {
                'incomeCategory' => {
                  'id' => be,
                  'name' => 'test name'
                },
                'errors' => {}
              }
            }
          }
        end

        it 'does not create bucket' do
          expect { create_category_request.call }.to change(IncomeCategory, :count).by(1)
        end

        it 'returns correct info' do
          create_category_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end

      context 'with optional' do
        let(:mutation) do
          <<~GQL
            mutation {
              createIncomeCategory(
                name: "test"
                expectedRevenue: 123
              ) {
                incomeCategory {
                  id
                  name
                  expectedRevenue
                }
                errors
              }
            }
          GQL
        end
        let(:expected_response) do
          {
            'data' => {
              'createIncomeCategory' => {
                'incomeCategory' => {
                  'id' => be,
                  'name' => 'test',
                  'expectedRevenue' => 123
                },
                'errors' => {}
              }
            }
          }
        end

        it 'does not create bucket' do
          expect { create_category_request.call }.to change(IncomeCategory, :count).by(1)
        end

        it 'returns correct info' do
          create_category_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end
    end

    context 'with failed creation' do
      context 'when expected revenue fails' do
        let(:mutation) do
          <<~GQL
            mutation {
              createIncomeCategory(
                name: "test"
                expectedRevenue: "string"
              ) {
                incomeCategory {
                  id
                  name
                  expectedRevenue
                }
                errors
              }
            }
          GQL
        end
        let(:expected_response) do
          {
            'errors' => [
              {
                'extensions' => {
                  'argumentName' => 'expectedRevenue',
                  'code' => 'argumentLiteralsIncompatible',
                  'typeName' => 'Field'
                },
                'locations' => [
                  {
                    'column' => be,
                    'line' => be
                  }
                ],
                'message' => "Argument 'expectedRevenue' on Field 'createIncomeCategory' has an invalid " \
                             "value (\"string\"). Expected type 'Int'.",
                'path' => %w[mutation createIncomeCategory expectedRevenue]
              }
            ]
          }
        end

        it 'does not create bucket' do
          expect { create_category_request.call }.not_to change(IncomeCategory, :count)
        end

        it 'returns correct info' do
          create_category_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end

      context 'when creation fails' do
        let(:mutation) do
          <<~GQL
            mutation {
              createIncomeCategory(
                name: "test"
              ) {
                incomeCategory {
                  id
                  name
                }
                errors
              }
            }
          GQL
        end
        let(:expected_response) do
          {
            'data' => {
              'createIncomeCategory' => {
                'incomeCategory' => nil,
                'errors' => {
                  'common' => ['Упс! Не удалось создать запись. Проверьте данные и попробуйте снова.']
                }
              }
            }
          }
        end

        before do
          allow_any_instance_of(IncomeCategoryInteractors::CreationPerformer)
            .to receive(:create_income_category)
                  .and_raise(RuntimeError)
        end

        it 'does not create bucket' do
          expect { create_category_request.call }.not_to change(IncomeCategory, :count)
        end

        it 'returns correct info' do
          create_category_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_response)
        end
      end
    end
  end

  context 'with not logged in user' do
    let(:mutation) do
      <<~GQL
        mutation {
          createIncomeCategory(
            name: "test"
          ) {
            incomeCategory {
              id
              name
            }
            errors
          }
        }
      GQL
    end
    let(:name) { 'test name' }
    let(:type) { 'credit_card' }
    let(:headers) { {} }
    let(:expected_response) do
      {
        'data' => {
          'createIncomeCategory' => nil
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
              'createIncomeCategory'
            ],
            'extensions' => {
              'code' => 'unauthorized'
            }
          }
        ]
      }
    end

    it 'does not create bucket' do
      expect { create_category_request.call }.not_to change(IncomeCategory, :count)
    end

    it 'returns correct info' do
      create_category_request.call
      expect(response).to be_successful
      expect(response_json).to match(expected_response)
    end
  end
end
