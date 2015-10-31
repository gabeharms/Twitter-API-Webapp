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
      
      if (!are_params_valid) 
        flash[:error] = 'Invalid Arguements. Please fill out each input field in the modal'
        redirect_to profile_path
      end
      
      if (params[:list_selection].downcase == 'new list')
        create_new_list params[:list_name]
        flash['success'] = "Created new list called: #{params[:list_name]}, and added the author: #{params[:add_to_list_author]}, to it" 
      else 
        params[:list_name] = params[:list_selection]
        flash['success'] = "Added author: #{params[:add_to_list_author]}, to the list: #{params[:list_name]}"
      end
      
      add_author_to_list params[:list_name], params[:add_to_list_author]
      
      redirect_to profile_path
    end
    
    private
    
      def are_params_valid
        if params[:list_selection].nil? || params[:add_to_list_author].nil? || (params[:list_selection] == 'new list' && params[:list_name].nil?)
          false
        else 
          true
        end
      end
      
      def create_new_list list_name
        session['lists'] = {} if session['lists'].nil?
        session['lists'][list_name] = []
      end
      
      def add_author_to_list list_name, author
        session['lists'][list_name].push(author) if !session['lists'][list_name].include?(author)
      end
    
end