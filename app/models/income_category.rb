# frozen_string_literal: true

class IncomeCategory < ApplicationRecord
  belongs_to :bucket
  belongs_to :user
end
