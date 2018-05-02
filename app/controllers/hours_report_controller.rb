class HoursReportController < ApplicationController
  def index
    @proyectos = Project.all 
    fFin  = Time.now + 1.week
    @periodos = Period.select("fecha_inicio, DATE_FORMAT(fecha_inicio, '%d-%b-%Y') as fecha_inicio_f").where(["fecha_fin <= '%s'", fFin]).group("fecha_inicio").order(fecha_inicio: :desc) 
    @periodos2 = Period.select("fecha_fin, DATE_FORMAT(fecha_fin, '%d-%b-%Y') as fecha_fin_f").where(["fecha_fin <= '%s'", fFin]).group("fecha_fin").order(fecha_fin: :desc)
    @empleados = Employee.all
  end

  def get_detalle_proy
    @horas = HoursDetail.joins("INNER JOIN hours_header 
      ON hours_header.id = hours_detail.id_header").where(" 
      hours_detail.id_proyecto = :id_proyecto 
      AND hours_detail.fecha >= STR_TO_DATE(:fecha_inicio, '%Y-%m-%d') 
      AND hours_detail.fecha <= STR_TO_DATE(:fecha_fin, '%Y-%m-%d')
      AND hours_header.status = 'autorizado'",
      {id_proyecto: params[:id_proyecto], fecha_inicio: params[:fecha_inicio],
      fecha_fin: params[:fecha_fin]}).order(fecha: :asc)

    respond_to do |format|
      format.json { render :json => @horas }
    end
  end

  def get_periodos
    @periodosRep = Period.where(" 
      fecha_inicio >= STR_TO_DATE(:fecha_inicio, '%Y-%m-%d') AND
      fecha_fin <= STR_TO_DATE(:fecha_fin, '%Y-%m-%d')", 
      {fecha_inicio: params[:fecha_inicio],
      fecha_fin: params[:fecha_fin]}).order(fecha_inicio: :asc)

    respond_to do |format|
      format.json { render :json => @periodosRep }
    end
  end

  def show
    
  end

  def get_detalle_emp
    @horasEmp = HoursDetail.joins("INNER JOIN hours_header 
      ON hours_header.id = hours_detail.id_header").where(" 
      hours_header.employee_id = :id_empleado 
      AND hours_detail.fecha >= STR_TO_DATE(:fecha_inicio, '%Y-%m-%d') 
      AND hours_detail.fecha <= STR_TO_DATE(:fecha_fin, '%Y-%m-%d')
      AND hours_header.status = 'autorizado'",
      {id_empleado: params[:id_empleado], fecha_inicio: params[:fecha_inicio],
      fecha_fin: params[:fecha_fin]}).order(fecha: :asc, id_proyecto: :asc)

    respond_to do |format|
      format.json { render :json => @horasEmp }
    end
  end

  def get_proyecto
    id_proyecto = params[:id_proyecto]
    json_data = Project.find_by(id: id_proyecto).to_json
    respond_to do |format|
      format.json { render :json => json_data }
    end
  end

  def destroy
    
  end
end
