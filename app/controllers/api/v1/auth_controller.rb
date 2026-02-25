module Api::V1
  class AuthController < ApplicationController
    before_action :authorize_request, only: [:profile]

    # POST /register
    def register
      user = User.new(user_params)

      if user.save
        token = JsonWebToken.encode(user_id: user.id)
        render_success({
                         token: token,
                         user: UserSerializer.new(user).serializable_hash[:data][:attributes]
                       }, :created)
      else
        render_error(user.errors.full_messages)
      end
    end

    # POST /login
    def login
      user = User.find_by(email: params[:email])

      if user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        render_success({
                         token: token,
                         user: UserSerializer.new(user).serializable_hash[:data][:attributes]
                       })
      else
        render_error("Invalid credentials", :unauthorized)
      end
    end

    # GET /profile
    def profile
      user_hash = UserSerializer.new(current_user).serializable_hash[:data]
      render_success(
        user_hash[:attributes].merge(id: user_hash[:id])
      )
    end

    private

    def user_params
      params.permit(:name, :email, :password, :password_confirmation)
    end
  end
end