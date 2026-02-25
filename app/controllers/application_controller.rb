class ApplicationController < ActionController::API
  attr_reader :current_user

  private

  def authorize_request
    header = request.headers["Authorization"]&.split(" ")&.last
    decoded = JsonWebToken.decode(header)

    return render_unauthorized unless decoded

    @current_user = User.find_by(id: decoded[:user_id])
    return render_unauthorized unless @current_user
  end

  def render_unauthorized
    render json: { errors: ["Unauthorized"] }, status: :unauthorized
  end
end
