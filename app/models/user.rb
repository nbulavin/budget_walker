# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :buckets, dependent: :destroy
  has_many :expense_categories, dependent: :destroy
  has_many :savings, dependent: :destroy
end
