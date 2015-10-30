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
    
    def lists
      if (params[:list_name].downcase == 'new list') 
        session['lists'] = {} if session['lists'].nil?
        session['lists'][params[:list_name]] = []
      end
      session['lists'][params[:list_name]].push(params[:add_to_list_author])
      
    end
    
end