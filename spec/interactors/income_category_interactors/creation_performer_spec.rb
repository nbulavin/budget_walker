# frozen_string_literal: true

RSpec.describe IncomeCategoryInteractors::CreationPerformer do
  describe '#call' do
    subject(:category_creation_service) { -> { described_class.call(payload: payload) } }

    let!(:user) { create :user }

    context 'when user provided' do
      context 'with valid params' do
        let(:payload) do
          {
            user: user,
            name: 'New name for category'
          }
        end
        let(:expected_attributes) do
          {
            created_at: be,
            expected_revenue: nil,
            id: be,
            name: 'New name for category',
            updated_at: be,
            user_id: user.id
          }.stringify_keys
        end

        it('creates correct bucket') do
          category_creation_service.call
          expect(IncomeCategory.first.attributes).to match(expected_attributes)
        end

        it('returns correct info') do
          result = category_creation_service.call
          expect(result.success?).to eq(true)
          expect(result.income_category).to eq(IncomeCategory.first)
          expect(result.errors).to eq({})
        end
      end

      context 'with incorrect params' do
        let(:payload) do
          {
            user: user,
            name: nil
          }
        end

        it('does not create bucket') do
          expect { category_creation_service.call }.not_to change(IncomeCategory, :count)
        end

        it('returns correct info') do
          result = category_creation_service.call
          expect(result.success?).to eq(false)
          expect(result.bucket).to be_nil
          expect(result.errors).to match({ name: ['должно быть заполнено'] })
        end
      end

      context 'with error during creation' do
        let(:payload) do
          {
            user: user,
            name: 'New name for category'
          }
        end

        before { allow_any_instance_of(described_class).to receive(:create_income_category).and_raise(RuntimeError) }

        it('does not create bucket') do
          expect { category_creation_service.call }.not_to change(IncomeCategory, :count)
        end

        it('returns correct info') do
          result = category_creation_service.call
          expect(result.success?).to eq(false)
          expect(result.bucket).to be_nil
          expect(result.errors)
            .to match({ common: ['Упс! Не удалось создать запись. Проверьте данные и попробуйте снова.'] })
        end
      end
    end
  end
end
