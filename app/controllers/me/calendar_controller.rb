class Me::CalendarController < Me::BaseController

  helper :action_bar

  def search
    if request.post?
      path = parse_filter_path(params[:search])
      #redirect_to url_for(:controller => '/me/pages/trash', :action => 'search', :path => nil) + path
    else
      list
    end
  end

  def index
    list
  end


  def list
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month)

    # To restrict what events are included in the result you can pass additional find options like this:
    #
    # @event_strips = Event.event_strips_for_month(@shown_month, :include => :some_relation, :conditions => 'some_relations.some_column = true')
    #
  end

  protected

  def context
    super
    add_context I18n.t(:calendar), url_for(:controller => '/me/calendar/', :action => 'list', :path => params[:path])
  end

end
