class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.where(username: params[:username], github: nil).first

    if user&.authenticate(params[:password])
      if user.suspended
        redirect_to signin_path, notice: "Account suspended, contact administrator"
      else
        session[:user_id] = user.id
        redirect_to user, notice: "Welcome back!"
      end
    else
      redirect_to signin_path, notice: "Signin failed!"
    end
  end

  def create_oauth
    github_name = request.env["omniauth.auth"].info.nickname
    user = User.where(username: github_name, github: true).first

    if user.nil?
      user = User.new username: github_name, github: true
      newpass = SecureRandom.urlsafe_base64
      user.password = newpass
      user.password_confirmation = newpass
      user.save

      session[:user_id] = user.id
      redirect_to user, notice: "Welcome #{user.username}"
    elsif user.suspended
      redirect_to signin_path, notice: "Account suspended, contact administrator"
    else
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
