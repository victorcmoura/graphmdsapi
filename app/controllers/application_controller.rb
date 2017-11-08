class ApplicationController < ActionController::API
  def index
    @welcome_text = 'Welcome to GraphMDS-API!'
    render json: @welcome_text
  end
end
