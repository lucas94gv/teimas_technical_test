class ApplicationController < ActionController::API
  attr_reader :current_user

  private

  def render_success(data = {}, status = :ok)
    render json: {
      success: true,
      data: data
    }, status: status
  end

  def render_error(errors = [], status = :unprocessable_entity)
    render json: {
      success: false,
      errors: Array(errors)
    }, status: status
  end

  def authorize_request
    header = request.headers["Authorization"]&.split(" ")&.last
    decoded = JsonWebToken.decode(header)

    return render_error("Unauthorized", :unauthorized) unless decoded

    @current_user = User.find_by(id: decoded[:user_id])
    render_error("Unauthorized", :unauthorized) unless @current_user
  end
end
