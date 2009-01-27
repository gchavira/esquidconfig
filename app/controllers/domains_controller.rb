class DomainsController < ApplicationController
	
	before_filter :authenticate
	
	active_scaffold :domains do |config|
		config.columns = [ :domain, :description, :active ]
		
		config.list.label = "Dominios"
		
		config.columns[:domain].label = 'Dominio'
		config.columns[:description].label = 'Descripcion'
		config.columns[:active].label = 'Activo'
		
		config.create.link.label = 'Agregar Nuevo'
		config.update.link.label = 'Editar'
		config.search.link.label = 'Buscar'
		config.delete.link.label = 'Eliminar'
		config.show.link.label = 'Mostrar'
		
		config.columns[:active].form_ui = :checkbox
		
		config.list.sorting = [ { :active => :desc }, { :domain => :asc } ]
		config.list.per_page = 30
		('a'..'z').map.reverse.each { |letter| config.action_links.add "letter_#{letter}", :label => ( (letter == 'a')? '&nbsp;'*5 : '' )+letter.upcase, :action => 'by_letter', :inline => false, :parameters => { :id => letter } }
		config.action_links.add 'show_all', :label => "<img src='/images/reload.png' style='border:0px; width:16px; height:16px;' />&nbsp;Mostrar Todos", :action => 'show_all', :inline => true, :position => false
		config.action_links.add 'export', :label => "<img src='/images/export.png' style='border:0px; width:16px; height:16px;' />&nbsp;SQUID&nbsp;Exportar", :action => 'export', :confirm => 'Esta seguro que desea exportar a SQUID y aplicar todos los cambios?'
		config.action_links.add 'import', :label => "<img src='/images/import.png' style='border:0px; width:16px; height:16px;' />&nbsp;SQUID&nbsp;Importar", :action => 'import', :confirm => 'Esta seguro que desea importar los dominios faltantes de SQUID?'
	end
	
	def by_letter
		@listconditions = "domain like '.#{params[:id].strip}%'"
		index
	end

	def conditions_for_collection
		@listconditions || nil
	end
	
	def show_all
		render :update do |page|
			page << "window.location.href = '/';"
		end
	end

	def export
		@domains = Domain.find(:all, :conditions => { :active => true }).map{ |d| d.domain }.sort
		File.open('/etc/squid/es_allowed.acl', 'w') { |f| f.write(@domains.join("\n")) }
		@squidreload = IO.popen('/etc/init.d/squid reload 2>&1').readlines
		render :layout => false
	end
	
	def import
		
		# Get the domains from file
		domains_file_raw = File.read('/etc/squid/es_allowed.acl').split
		domains_file = domains_file_raw
		domains_file = domains_file.map{ |d| d.downcase }
		domains_file = domains_file.map{ |d| (/^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$/.match(d))? nil : d }.compact
		domains_file = domains_file.map{ |d| (/^\.[a-z0-9-]+(\.[a-z0-0-]+)+$/.match(d))? d : nil }.compact
		domains_file = domains_file.map{ |d| (d.length > 0)? d : nil }.compact
		domains_file = domains_file.map{ |d| (d[0..0] == '.')? d : '.'+d }
		domains_file = domains_file + domains_file_raw.map{ |d| (/^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$/.match(d))? d : nil }.compact
		domains_file = domains_file.sort
		
		# Get the domains from database
		domains_db = Domain.find(:all).map{|d| d.domain.downcase }.sort
		
		# Remove from file list any domains we already have
		@domains = domains_file - domains_db
		
		# Add the missing domains to database with a comment
		@domains.each do |d|
			Domain.new(:domain => d, :description => "Permiso de acceso al dominio #{d}", :active => true).save
		end
		
		# Layout is null because of Ajax call.
		render :layout => false
	end
	
end

