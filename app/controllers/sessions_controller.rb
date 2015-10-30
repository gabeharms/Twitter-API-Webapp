class SessionsController < ApplicationController
  require 'geoip'
  
  def create
    credentials = request.env['omniauth.auth']['credentials']
    session[:access_token] = credentials['token']
    session[:access_token_secret] = credentials['secret']
    flash[:success] = "Signed In Successfully"
    redirect_to profile_path
  end

  def show
    if session['access_token'] && session['access_token_secret']
      @user = client.user(include_entities: true)
    else
      redirect_to failure_path
    end
    
    info = GeoIP.new(Rails.root.join("GeoLiteCity.dat")).city(request.remote_ip)
    @latitude = info.latitude
    @longitude = info.longitude
    @city = info.city_name
    @region = info.real_region_name
    client.search("to:justinbieber marry me", result_type: "recent").take(3).collect do |tweet|
      "#{tweet.user.screen_name}: #{tweet.text}"
    end
    
  end

  def error
    flash[:error] = 'Sign in with Twitter failed'
    redirect_to root_path
  end

  def destroy
    reset_session
    flash[:success] = "Signed Out Successfully"
    redirect_to root_path
  end
end