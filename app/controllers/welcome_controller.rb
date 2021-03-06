class WelcomeController < ApplicationController
  before_filter :authenticate_user, only: :user_home
  
  def index
    render action: 'index', layout: 'application_updated'
  end

  def update_browser
    render action: 'update_browser', layout: false
  end

  def goodbye
    redirect_to logout_url if current_user.present?
  end

  def user_home
    if current_user.present?
      bikes = current_user.bikes
      @bikes = BikeDecorator.decorate_collection(bikes)
      @locks = LockDecorator.decorate_collection(current_user.locks)

      if current_user.can_invite && current_user.has_membership?
        @bike_token_invitation = BikeTokenInvitation.new
      end
      render action: 'user_home', layout: 'no_container'
    else
      flash[:notice] = "Woops, you have to log in to be able to do that"  
      redirect_to new_session_url
    end
  end

  def choose_registration
    @user = User.new unless current_user.present?
  end
end
