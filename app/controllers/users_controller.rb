class UsersController < ApplicationController
	before_filter :authenticate

	active_scaffold :users do |config|
		config.columns = [ :username, :password ]
		config.list.label = "Usuarios"
		
		config.columns[:username].label = 'Usuario'
		config.columns[:password].label = 'Password'

		config.create.link.label = 'Agregar Nuevo'
		config.update.link.label = 'Editar'
		config.search.link.label = 'Buscar'
		config.delete.link.label = 'Eliminar'
		config.show.link.label = 'Mostrar'

		config.list.sorting = [ { :username => :asc } ]

		config.list.per_page = 30
	end
	
	def logout
		session['user'] = nil
		redirect_to :controller => 'main', :action => 'logout'
	end
end
