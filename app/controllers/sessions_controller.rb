class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:user][:username])
    if user && user.authenticate(params[:user][:password])
      session = user.sessions.create
      cookies.signed[:twitter_session_token] = session.token
      render json: { success: true }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def authenticated
    token = cookies.signed[:twitter_session_token]
    session = Session.find_by(token: token)
    if session
      render json: { authenticated: true, username: session.user.username }
    else
      render json: { authenticated: false }
    end
  end

  def destroy
    token = cookies.signed[:twitter_session_token]
    session = Session.find_by(token: token)
    if session
      session.destroy
      cookies.delete(:twitter_session_token)
      render json: { success: true }
    else
      render json: { error: 'Invalid session' }, status: :unauthorized
    end
  end
end
