class Domain < ActiveRecord::Base
	
	HUMANIZED_ATTRIBUTES = { :domain => 'dominio', :description => 'descripcion', :active => 'activo' }

	validates_presence_of :domain, :message => 'debe ser especificado'
	validates_presence_of :description, :message => 'debe ser especificado'

	validates_format_of :domain, :with => /^localhost$|^(\.[a-z0-9-]+(\.[a-z0-0-]+)*)|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3})$/i, :message => 'debe ser solo minusculas e iniciar con un punto (.) (ejm. .google.com) o ser una direccion IP valida (ejm. 123.456.78.9)'

	validates_length_of :description, :in => 5..255, :too_short => 'es demasiado corto (minimo es 5 caracteres)', :too_long => 'es demasiado largo (maximo es 255 caracteres)'

	validates_uniqueness_of :domain, :message => 'el dominio debe ser unico'

	def self.human_attribute_name(attr)
		HUMANIZED_ATTRIBUTES(attr.to_sym) || super
	end

end

