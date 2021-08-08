# frozen_string_literal: true

class ExpenseCategory < ApplicationRecord
  belongs_to :user
end
