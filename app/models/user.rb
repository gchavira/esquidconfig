class User < ActiveRecord::Base
	validates_format_of :username, :with => /[a-z][a-z0-9]{2,20}/i, :message => 'debe ser alfa-numérico de 3 a 20 caracteres.'
	validates_format_of :password, :with => /[a-z][a-z0-9]{2,20}/i, :message => 'debe ser alfa-numérico de 3 a 20 caracteres.'
end
