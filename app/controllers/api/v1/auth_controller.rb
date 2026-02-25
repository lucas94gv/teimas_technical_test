module Api::V1
  class AuthController < ApplicationController
    before_action :authorize_request, only: [ :profile ]

    # POST /register
    def register
      user = User.new(user_params)
      if user.save
        token = JsonWebToken.encode(user_id: user.id)
        render json: { token: token, user: user.as_json(except: [ :password_digest ]) }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # POST /login
    def login
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        render json: { token: token, user: user.as_json(except: [ :password_digest ]) }, status: :ok
      else
        render json: { errors: [ "Invalid credentials" ] }, status: :unauthorized
      end
    end

    # GET /profile
    def profile
      render json: @current_user
    end

    private

    def user_params
      params.permit(:name, :email, :password, :password_confirmation)
    end

    def authorize_request
      header = request.headers["Authorization"]&.split(" ")&.last
      decoded = JsonWebToken.decode(header)
      @current_user = User.find(decoded[:user_id]) if decoded
    rescue ActiveRecord::RecordNotFound
      render json: { errors: [ "User not found" ] }, status: :unauthorized
    rescue JWT::DecodeError, JWT::VerificationError
      render json: { errors: [ "Invalid or expired token" ] }, status: :unauthorized
    end
  end
end
