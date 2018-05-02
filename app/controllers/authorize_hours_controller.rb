class AuthorizeHoursController < ApplicationController
  def index
  	@periodos = Period.periodosAnualCombo
  	if params[:periods]
      @periodoSel = params[:periods][:period_id]
    else
      @periodoSel = nil
	end
  	comit = params[:commit]
  	comit2 = params[:commit2]
  	if params[:periods]
	  	if comit 
		  	@idperiodo = params[:periods][:period_id]
		  	idempl1 = PeriodsProjectsEmployee.select(:employee_id,:id).where("periods_projects_employees.period_id"=>@idperiodo,"periods_projects_employees.status"=>1)
		  	idempl2 = PeriodsProjectsEmployee.select(:employee_id,:id).where("periods_projects_employees.period_id"=>@idperiodo,"periods_projects_employees.status"=>2)
		  	idempl = idempl1+idempl2
		  	ides = []
		  	idempl.each do |b|
		  		ides << b.employee_id
		  	end
		  	@nombrehash = Hash.new
		  	ides.each do |nom|
		  		empleadoall = Employee.find(nom)
		  		empleado = empleadoall.apellido_paterno+" "+empleadoall.apellido_materno+", "+empleadoall.nombre
		  		@nombrehash [nom] = empleado
		  	end
			if comit != "Mostrar"
				comit = comit.to_i
				empleadoall = Employee.find(comit)
		  		@empleados = empleadoall.nombre+" "+empleadoall.apellido_paterno+" "+empleadoall.apellido_materno
				@ppe = PeriodsProjectsEmployee.find_by(period_id: @idperiodo, employee_id: comit)
				@hou = Hour.select(:project_id,:periods_projects_employee_id).distinct.where("hours.periods_projects_employee_id"=>@ppe.id)	
			end
			@nombrehash = @nombrehash.sort_by {|key,value|value}			
		end#end if 
		if comit2
			comit2 = comit2.to_i
			PeriodsProjectsEmployee.update(comit2, :status => 2)  
		    respond_to do |format| 
		      format.html { redirect_to authorize_hours_index_path, notice: 'Se han Autorizado las horas de los proyectos del periodo seleccionado.' }  
		      format.js  
		    end
		end
	end#end if
  end
end
