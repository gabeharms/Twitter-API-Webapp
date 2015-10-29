class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  private 
  
    def client
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key = "KmziBBGEcdyLkfCznsw5JpjAM"
        config.consumer_secret = "dJkd7v6RsXoqffIoiSLa3Eu3NCYUZLlHgCNIzNzCgqQ538uVin"
        config.access_token = session['access_token']
        config.access_token_secret = session['access_token_secret']
      end
    end
    
end
