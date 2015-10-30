module ApplicationHelper
     
  def is_logged_in
    return !@user.nil?
  end
end
