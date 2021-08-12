# frozen_string_literal: true

class ExpenseCategory < ApplicationRecord
  belongs_to :bucket
  belongs_to :user
end
