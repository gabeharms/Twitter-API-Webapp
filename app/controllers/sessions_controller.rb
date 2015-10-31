class SessionsController < ApplicationController
  require 'geoip'
  require 'will_paginate/array'
  
  def create
    credentials = request.env['omniauth.auth']['credentials']
    session[:access_token] = credentials['token']
    session[:access_token_secret] = credentials['secret']
    flash[:success] = "Signed In Successfully"
    redirect_to profile_path
  end

  def show
    if user_logged_in 
      @user = client.user(include_entities: true)
    else
      redirect_to failure_path
    end
    
    if no_lists_exist
      create_empty_one
    end
 
    @location = getRequestInfo request
    @radius = params[:filter_by_radius] || 20
    @result_type = params[:filter_by_type] || 'recent'
    @selected_list = params[:filter_by_list]
    @search_for = params[:search_for] || 'healthcare'
    
    @tweets = getTweets
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
  
  
  private
  
    def user_logged_in
      session['access_token'] && session['access_token_secret']
    end
    
    def no_lists_exist
      session['lists'].nil?
    end
    
    def create_empty_one
      session['lists'] = {}
      session['lists']["new list"] = []
    end
    
    def getRequestInfo request_raw
      requestInfo = GeoIP.new(Rails.root.join("GeoLiteCity.dat")).city(request_raw.remote_ip)
      info = {}
      info['latitude'] = requestInfo.latitude
      info['longitude'] = requestInfo.longitude
      info['city'] = requestInfo.city_name
      info['region'] = requestInfo.real_region_name
      info
    end
    
    def getTweets
      results = client.search("#{@search_for}", result_type: "#{@result_type}", geocode:"#{@location['latitude']},#{@location['longitude']},#{@radius}mi")
      @result_count = results.count
      results.take(500).paginate(page: params[:page], :per_page => 5)
    end
end