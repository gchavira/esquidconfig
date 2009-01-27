class MainController < ApplicationController
	before_filter :authenticate, :except => :login

	def index
	end
	
	def login
		if request.post?
			username = params[:username]
			password = params[:password]
			if User.exists?(:username => username, :password => password)
				session[:user] = username
				redirect_to :controller => session[:intended_controller], :action => session[:intended_action]
			end
		else
			flash[:error] = "Error en el ingreso, por favor verifique su usuario y password."
		end
	end
	
	def logout
		session[:user] = nil
	end
end
