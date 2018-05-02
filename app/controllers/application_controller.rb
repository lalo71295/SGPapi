class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :add_user_to_employee, if: :devise_controller?
  before_action :authenticate_user!
  before_action :checa_permisos, if: -> { !:devise_controller? }

  include SecurityHelper

  #Permite añadir parametros permitidos a devise
  def add_user_to_employee
    devise_parameter_sanitizer.permit(:sign_up, keys: [:employee, :employee_id, :approved])
    devise_parameter_sanitizer.permit(:account_update, keys: [:employee, :employee_id, :approved])
    devise_parameter_sanitizer.permit(:create, keys: [:employee, :employee_id, :approved])
  end

  def checa_permisos
  	if user_signed_in?
  		#permisos = current_user.permissions.group(:permission_id)

      #puts ">>>>>>>>>>>> #{controller_name}"
  		
      #permiso = current_user.permissions.find_by(controlador: controller_name, accion: action_name)
      @permisos = session[:permisos]

      permitido = false
      @permisos.each do |per|
        if per.controlador == controller_name && per.accion == action_name
          permitido = true
        end
      end

      if !permitido
	   		if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
		      redirect_back(fallback_location: publico_path, alert: "No tienes acceso a esta accion")
		    else
		      redirect_to publico_path, alert: "No tienes acceso a esta accion"
		    end
      end
  	end
  end
end
