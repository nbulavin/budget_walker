# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    enable_extension('citext')

    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.citext :email, null: false
      t.string :password_digest

      t.timestamps
    end
  end
end
