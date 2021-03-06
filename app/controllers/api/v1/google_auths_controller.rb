class Api::V1::GoogleAuthsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_current_user

  def redirect_callbacks
    p params['profileObj']['email']
    if params['profileObj']['email'] 
      user_params = User.find_for_google_oauth(params)
      @user = User.new user_params
      if @user.save
        session[:user_id] = @user.id
        render json: {
          messages: "Sign Up Successfully",
          is_success: true,
          data: {user: @user}
        }, status: 200
      end
      if User.find_by(email:  params['profileObj'][:email])
        user = User.find_by(email:  params['profileObj'][:email])
        session[:user_id] = user.id
        render json: {
          messages: "Sign in Successfully",
          is_success: true,
          data: {user: user}
        }, status: 200
      end
    end
  end
  

  private
  def set_current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end
end

