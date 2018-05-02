class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:publico]

  	def index 
  		
  	end
  	def publico
  	
  	end
	def prueba
	  	controllers = Dir.new("app/controllers").entries
	  	arCotroladores = []
	  	i=0
		controllers.each do |controller|
			if controller =~ /_controller/ 
				cont = controller.camelize.gsub(".rb","") 
				#puts cont
				arMets = []
				(eval("#{cont}.new.methods") - 
				ApplicationController.methods - 
				Object.methods -  
				ApplicationController.new.methods).sort.each {|met| 
					arMets << {:metodo => met}
				   	#puts "\t#{met}"
				   	#byebug
				}
				name_short = cont.gsub("Controller","").downcase
				arCotroladores << {:controlador => name_short, :metodos => arMets}
			end
		end

		@seeds = []
		ApplicationController.subclasses.each do |c|
			controlador = underscore(c.to_s.gsub('Controller',''))
			c.action_methods.each do |met|
				@seeds << "Permission.create(controlador: :#{controlador}, accion: :#{met})"
			end
		  #puts "Controller: #{c}"
		  #puts "Actions: #{c.action_methods.collect{|a| a.to_s}.join(', ')}"
		end

		@seeds = []
		#permisos = Permission.all
		permisos = Permission.where(controlador: ["welcome","tasks","custom_sessions"]) 
		permisos.each do |permiso|
			@seeds << "RolsPermission.create(rol_id: 7, permission_id: #{permiso.id})"
		end

		Rails.application.routes.routes.each do |route|
	 		#puts route.path.spec.to_s
		end

		arCotroladores
		@controladores = arCotroladores
 	end

 	def inicio
 		
 	end

  	def underscore(camel_cased_word)
     	camel_cased_word.to_s.gsub(/::/, '/').
       	gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
       	gsub(/([a-z\d])([A-Z])/,'\1_\2').
       	tr("-", "_").
       	downcase
   end
end
