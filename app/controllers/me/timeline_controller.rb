class Me::TimelineController < Me::BaseController

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

    cond = { :user => User.current }

    @event_strips = Event.event_strips_for_month(@shown_month, cond)

    # To restrict what events are included in the result you can pass additional find options like this:
    #
    # @event_strips = Event.event_strips_for_month(@shown_month, :include => :some_relation, :conditions => 'some_relations.some_column = true')
    #
  end

  def timeline
    @year = (params[:year] || Time.zone.now.year).to_i

    startd = Date.new(@year,1,1)
    endd= Date.new(@year,12,31)

    cond = { :user => User.current }

    @event_strips = Event.events_for_date_range( startd, endd ,cond)

    @second_nav = 'timeline'
  end

  protected

  def context
    super
    add_context I18n.t(:timeline), url_for(:controller => '/me/timeline/', :action => 'timeline', :path => params[:path])
  end

end
