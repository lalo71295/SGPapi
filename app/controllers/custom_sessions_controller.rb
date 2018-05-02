class CustomSessionsController < Devise::SessionsController
  before_action :before_login, :only => :create
  after_action :after_login, :only => :create
  #skip_before_action :authenticate_user!

  def before_login
  	
  end

  #Obtención de permisos despues del login
  def after_login
  	#session[:permisos] = current_user.permissions.group(:permission_id)
    session[:permisos] = current_user.permissions
    
  	if !(current_user.permissions.count > 0) 
  		redirect_to inicio_path, notice: "No tienes ningun permiso asignado"
  	end
  end
end