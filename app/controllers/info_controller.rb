class InfoController < ApplicationController
  layout 'content'
  # caches_page :about, :where, :roadmap, :security, :serials, :stolen_bikes, :privacy, :terms, :vendor_terms, :downloads, :resources, :spokecard
  before_filter :set_active_section

  def about
  end
  
  def where
    @bike_shops = Organization.shop.shown_on_map.decorate
    @states = State.includes(:locations).all
    @countries = Country.where('iso != ?', 'US').includes(:locations)
  end

  def roadmap
  end

  def security
  end

  def serials
  end

  def protect_your_bike
  end

  def how_it_works
  end

  def stolen_bikes
  end

  def privacy
    render layout: 'legal'
  end

  def terms
    render layout: 'legal'
  end

  def vendor_terms
    render layout: 'legal'
  end

  def resources
  end

  def image_resources
  end

  def spokecard
    if current_user.present?
      @bikes = current_user.bikes
    end
  end

  def support_the_index
    render layout: 'application_updated'
  end
  def support_the_bike_index
    redirect_to support_the_index_url
  end

  def how_not_to_buy_stolen
    redirect_to 'https://files.bikeindex.org/stored/BikeIndex_How_To_Not_Buy_Stolen.pdf'
  end

protected

  def set_active_section
    resources = ['serials', 'stolen_bikes', 'resources', 'spokecard', 'protect_your_bike', 'how_it_works', 'image_resources']
    if resources.include? action_name
      @active_section = 'resources'
    else
      @active_section = 'about'
    end
  end


end