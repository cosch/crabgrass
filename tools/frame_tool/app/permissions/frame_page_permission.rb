module FramePagePermission
  def authorized?
   if params[:action] == 'create'
  		return true
   elsif params[:action] == 'edit'
     return current_user.may?(:edit, @page)
   else
     return current_user.may?(:see, @page)
   end
  end
end
