module AuthenticationHelper
  extend ActiveSupport::Concern

  def authenticate_user(msg="Sorry, you have to log in")
    if current_user.present?
      unless current_user.terms_of_service
        redirect_to accept_terms_url(subdomain: false) and return
      end
    else
      flash[:error] = msg
      if msg.match(/create an account/i).present?
        redirect_to new_user_url(subdomain: false) and return
      else
        redirect_to new_session_url(subdomain: false) and return
      end
    end
  end

  def user_root_url
    return root_url unless current_user.present?
    if current_user.superuser
      admin_root_url
    elsif current_user.is_content_admin
      admin_news_index_url
    else
      user_home_url(subdomain: false)
    end
  end

protected
  def remove_session
    cookies.delete(:auth)
  end
  
  def current_user
    @current_user ||= User.from_auth(cookies.signed[:auth])
  end

  # def permitted_params
  #   @permitted_params ||= PermittedParams.new(params, current_user)
  # end

  def require_member!
    if current_user.is_member_of?(current_organization)
      return true
      # unless current_user.vendor_terms_of_service
      #   redirect_to accept_vendor_terms_url(subdomain: false) and return
      # end
    else
      flash[:error] = "You're not a member of that organization!"
      redirect_to user_home_url(subdomain: false) and return
    end
  end

  def require_admin!
    unless current_user.is_admin_of?(current_organization)
      flash[:error] = "You have to be an organization administrator to do that!"
      redirect_to user_home_url and return
    end
  end

  def require_index_admin!
    type = 'full'
    content_accessible = ['news']
    if content_accessible.include?(controller_name)
      type = 'content'
    end
    unless current_user.present? && current_user.admin_authorized(type)
      flash[:error] = "You don't have permission to do that!"
      redirect_to user_root_url
    end
  end

  def current_organization
    @organization ||= Organization.find_by_slug(request.subdomain)
  end

  def set_current_organization
    if Subdomain.matches?(request)
      @organzation = Organization.find_by_slug(request.subdomain)
    end
  end
end