class TweetsController < ApplicationController
  def create
    tweet = current_user.tweets.new(tweet_params)
    if tweet.save
      render json: { tweet: { username: current_user.username, message: tweet.message } }, status: :created
    else
      render json: tweet.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user
      tweet = current_user.tweets.find(params[:id])
      tweet.destroy
      render json: { success: true }, status: :ok
    else
      render json: { success: false }, status: :unauthorized
    end
  end

  def index
    tweets = Tweet.all.order(created_at: :desc)
    render json: { tweets: tweets.map { |tweet| { id: tweet.id, username: tweet.user.username, message: tweet.message } } }
  end

  def index_by_user
    user = User.find_by(username: params[:username])
    tweets = user.tweets
    render json: { tweets: tweets.map { |tweet| { id: tweet.id, username: user.username, message: tweet.message } } }, status: :ok
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end

  def current_user
    token = cookies.signed[:twitter_session_token]
    session = Session.find_by(token: token)
    session&.user
  end
end
