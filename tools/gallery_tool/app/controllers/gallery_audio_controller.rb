class GalleryAudioController < BasePageController

  permissions 'gallery'
  helper 'gallery'

  # could we verify delete as the method on destry?
  verify :method => :post, :only => [:create]
  verify :method => [:post, :put], :only => [:update]
  verify :method => [:post, :delete], :only => [:destroy]

  def create
    @showing = @page.showings.find params['showing_id']
    @track = @showing.create_track params['track'].try.slice('permalink_url')
    @showing.save
  end

  def update
    @showing = @page.showings.find params['showing_id']
    @track = @showing.track
    @track.permalink_url = params['track']['permalink_url']
    if @track.save
      flash_message_now :title => I18n.t(:audio_updated),
                :success => I18n.t(:audio_updated_successfully)
    else
      flash_message_now :object => @track
    end
  end

  def destroy
  end

  protected

  # we don't want any confusion with :create specific context from
  # BasePageController
  def context
    page_context
  end
end