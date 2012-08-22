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

  def list_orig
    logger.debug "CalendarController list in"
    @path.default_sort('updated_at')
    full_url = url_for(:controller => '/me/pages/calendar', :action => 'list', :path => @path)

    @pages = Page.paginate_by_path(@path.merge(:admin => current_user.id), options_for_me(:flow => :deleted).merge(pagination_params))
#    @second_nav = 'pages'
#    handle_rss(
#      :link => full_url,
#      :title => 'Crabgrass Trash',
#      :image => avatar_url(:id => @user.avatar_id||0, :size => 'huge')
#    ) or render(:action => 'list')
  end

  def list
    @field = 'updated'

    @months = Page.month_counts(:current_user => (current_user if logged_in?), :field => @field, :event => true)
    unless @months.empty?
      @current_year = (Date.today).year
      @start_year = @months[0]['year'] || @current_year.to_s
      @current_month = (Date.today).month

      # normalize path
      unless @path.keyword?('date')
        @path.merge!( :date => ("%s-%s" % [@months.last['year'], @months.last['month']]) )
      end
      @path.set_keyword(@field)

      # find pages
      @pages = Page.paginate_by_path( @path.merge(:type => 'EventPage'), pagination_params)
    end
#    @tags = Tag.for_group(:group => @group, :current_user => (current_user if logged_in?))
#    search_template('archive')
  end

  # post required
  def update
    pages = params[:pages]
    if pages
      pages.each do |page_id|
        page = Page.find_by_id(page_id)
        if page
          if params[:undelete] and may_undelete_page?(page)
            page.undelete
          elsif params[:remove] and may_remove_page?(page)
            page.destroy
            ## add more actions here later
          end
        end
      end
    end
    if params[:path]
      #redirect_to :action => 'search', :path => params[:path]
    else
      #redirect_to :action => nil, :path => nil
    end
  end

  protected

  def may_undelete_page?(page)
    current_user.may?(:admin, page)
  end

  def may_remove_page?(page)
    current_user.may?(:delete, page)
  end

  def context
    super
    add_context I18n.t(:me_trash_link), url_for(:controller => '/me/pages/trash', :action => 'search', :path => params[:path])
  end

end
