class TweetController < ApplicationController
  
    def retweet
      begin
        client.retweet(params[:tweet_id])
        redirect_to profile_path, :flash => { :success => "Retweeted Successfully" }
      rescue
        redirect_to profile_path, :flash => { :error => "Already Retweeted" }
      end
    end
    
    def reply
      client.update("@#{params[:reply_to_tweet_user]} " + params[:reply_to_tweet_response], {"in_reply_to_status_id" => params[:reply_to_tweet_id]})
      flash[:success] = "Replied to Tweet Successfully"
      redirect_to profile_path
    end
    
end