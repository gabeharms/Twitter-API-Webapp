class TweetController < ApplicationController
  
    def retweet
      client.retweet(params[:tweet_id])
      flash[:success] = "Retweeted Successfully"
      redirect_to profile_path
    end
    
    def reply
      client.update("@#{params[:username]} " + params[:response], {"in_reply_to_status_id" => params[:tweet_id]})
      flash[:success] = "Replied to Tweet Successfully"
      redirect_to profile_path
    end
    
end