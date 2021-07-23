# frozen_string_literal: true

class AddAuthorizationTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :authorization_token, :string
  end
end
