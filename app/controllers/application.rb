# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	helper :all # include all helpers, all the time
	
	# See ActionController::RequestForgeryProtection for details
	# Uncomment the :secret if you're not using the cookie session store
	protect_from_forgery # :secret => '3951d2ee6f0adf7d1d0230690f3fc49a'

	protected
	
	def authenticate
		if session[:user].blank?
			session[:intended_controller] = params[:controller]
			session[:intended_action] = params[:action]
			redirect_to :controller => 'main', :action => 'login'
		end
	end
  
end
