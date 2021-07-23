# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def current_user
    token = request.headers['Authorization'].to_s
    User.find_by(authorization_token: token)
  end
end
