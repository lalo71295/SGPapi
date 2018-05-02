class HoursEmployeeController < ApplicationController
  def index
    @periodos = Period.periodosAnualCombo
    @empleado = current_user.employee.id
  end

  def new_horas_header
    id_empleado = current_user.employee.id
    id_periodo = params[:id_periodo]
    total_horas = params[:total_horas]
    status = params[:status]
    @hh = HoursHeader.new(:employee_id => id_empleado,:period_id => id_periodo,:total_horas => total_horas,:status => status)
    @hh.save

    json_data = @hh.id.to_json
    respond_to do |format|
      format.json { render :json => json_data }
    end
  end

  def create
    
  end

  def get_proyectos
    #json_data = Project.all.to_json
    json_data = Project.joins(projects_rols: [:employees_projects_rols]).where("employees_projects_rols.employee_id" => current_user.employee_id).group("id").to_json
    respond_to do |format|
      format.json { render :json => json_data }
    end
  end

  def get_fechas_periodo
    @id_periodo = params[:id_periodo]
    json_data = Period.find_by(id: @id_periodo).to_json
    respond_to do |format|
      format.json { render :json => json_data }
    end
  end

  def new_horas_detalle
    id_header = params[:id_header]
    id_proyecto = params[:id_proyecto]
    fecha = params[:fecha]
    horas = params[:horas]
    facturable = params[:facturable]
    @hd = HoursDetail.new(:id_header => id_header,:id_proyecto => id_proyecto,:fecha => fecha,:horas => horas,:facturable => facturable)
    @hd.save

    json_data = @hd.id.to_json
    respond_to do |format|
      format.json { render :json => json_data }
    end
  end

  def get_validacion
    id_empleado = current_user.employee.id
    id_periodo = params[:id_periodo]
    estado = ''
    @hh = HoursHeader.find_by(employee_id: id_empleado, period_id: id_periodo)
    if !@hh
      estado = 'No hay registros'
    else
      estado = @hh.status
    end

    json_data = estado.to_json
    respond_to do |format|
      format.json { render :json => json_data }
    end
  end


  def hours_employee_params
    params.require(:HoursHeader).permit(:employee_id, :period_id, :total_horas, :status)
    params.require(:HoursDetail).permit(:id_header, :id_proyecto, :fecha, :horas, :facturable)
  end

end
