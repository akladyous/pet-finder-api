class SessionsController < ApplicationController
    skip_before_action :authenticate_user, only: [:create, :destroy]
    
    def create
        @user = User.find_by(user_name: params[:user_name])
        if @user.nil?
            render json: {error: "User Name not found"}, status: :not_found
        elsif !@user.authenticate(params[:password])
            render json: {error: "Invalid password"}, status: :unprocessable_entity
        elsif
            session[:user_id] = @user.id
            render json: {message: "logged in successfully", 
                date_time: Time.now, email: current_user.email}, status: :ok
        else
            render json: {error: "Unauthorized user"}, status: :unauthorized
        end
    end

    def destroy
        session.delete :user_id
        render json: {message: "logged out successfully", date_time: Time.now}, status: :ok
    end

    def session_params
        params.permit(:user_name, :password, :password_confirmation)
    end
end
