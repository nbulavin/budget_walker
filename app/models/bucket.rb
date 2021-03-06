# frozen_string_literal: true

class Bucket < ApplicationRecord
  belongs_to :user

  enum bucket_type: { credit_card: 0, account: 1, cash: 2 }
end
