# frozen_string_literal: true

RSpec.describe Queries::IncomeCategoryQueries::IncomeCategoryShowQuery, type: :request do
  describe 'me' do
    subject(:graphql_test_request) { -> { post '/graphql', params: { query: query }, headers: headers } }

    let(:query) do
      <<~GQL
        query {
          getIncomeCategoryDetails(
            id: #{category_id}
          ) {
            id
            name
            expectedRevenue
            actualRevenue
            revenuePercent
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

      context 'with category in database' do
        context 'with correct base fields in response' do
          let!(:first_category) { create :income_category, user: user }
          let(:category_id) { first_category.id }
          let(:expected_category_details) do
            {
              'data' => {
                'getIncomeCategoryDetails' => {
                  'id' => first_category.id,
                  'name' => 'FirstCategory',
                  'expectedRevenue' => 123,
                  'actualRevenue' => nil,
                  'revenuePercent' => 0
                }
              }
            }
          end

          it 'returns correct info' do
            graphql_test_request.call
            expect(response).to be_successful
            expect(response_json).to match(expected_category_details)
          end
        end

        context 'with correct computed fields' do
          let!(:first_category) do
            create :income_category, user: user, expected_revenue: expected_revenue, actual_revenue: actual_revenue
          end
          let(:category_id) { first_category.id }

          context 'when revenue_percent' do
            context 'with expected_revenue filled in' do
              let(:expected_revenue) { 123 }

              context 'with actual_revenue filled in' do
                context 'with zero' do
                  let(:actual_revenue) { 0 }

                  it 'returns correct info' do
                    graphql_test_request.call
                    expect(response).to be_successful
                    expect(response_json_object.data.getIncomeCategoryDetails.revenuePercent).to eq(0)
                  end
                end

                context 'with less than expected_revenue' do
                  let(:actual_revenue) { 11 }

                  it 'returns correct info' do
                    graphql_test_request.call
                    expect(response).to be_successful
                    expect(response_json_object.data.getIncomeCategoryDetails.revenuePercent).to eq(8)
                  end
                end

                context 'with expected_revenue' do
                  let(:actual_revenue) { 123 }

                  it 'returns correct info' do
                    graphql_test_request.call
                    expect(response).to be_successful
                    expect(response_json_object.data.getIncomeCategoryDetails.revenuePercent).to eq(100)
                  end
                end

                context 'with more than expected_revenue' do
                  let(:actual_revenue) { 1300 }

                  it 'returns correct info' do
                    graphql_test_request.call
                    expect(response).to be_successful
                    expect(response_json_object.data.getIncomeCategoryDetails.revenuePercent).to eq(100)
                  end
                end
              end

              context 'with actual_revenue not filled in' do
                let(:actual_revenue) { nil }

                it 'returns correct info' do
                  graphql_test_request.call
                  expect(response).to be_successful
                  expect(response_json_object.data.getIncomeCategoryDetails.revenuePercent).to eq(0)
                end
              end
            end

            context 'with expected_revenue not filled in' do
              let(:expected_revenue) { nil }
              let(:actual_revenue) { 100 }

              it 'returns correct info' do
                graphql_test_request.call
                expect(response).to be_successful
                expect(response_json_object.data.getIncomeCategoryDetails.revenuePercent).to be_nil
              end
            end
          end
        end
      end

      context 'without category in database' do
        let(:category_id) { 0 }
        let(:expected_category_details) do
          {
            'data' => {
              'getIncomeCategoryDetails' => nil
            },
            'errors' => [
              {
                'locations' => [
                  {
                    'column' => be,
                    'line' => be
                  }
                ],
                'message' => 'Упс! Мы не нашли то, что вы искали. Проверьте правильность и повторите запрос',
                'path' => [
                  'getIncomeCategoryDetails'
                ]
              }
            ]
          }
        end

        it 'returns correct info' do
          graphql_test_request.call
          expect(response).to be_successful
          expect(response_json).to match(expected_category_details)
        end
      end
    end

    context 'with not logged in user' do
      let(:category_id) { 0 }
      let(:headers) { {} }
      let(:expected_response) do
        {
          'data' => {
            'getIncomeCategoryDetails' => nil
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
                'getIncomeCategoryDetails'
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
