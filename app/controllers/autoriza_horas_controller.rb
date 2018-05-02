class AutorizaHorasController < ApplicationController
  def index
    @periodos = Period.periodosAnualCombo
    
    commit = params[:commit]
    detalle = params[:detalle]
    if commit
      if params[:periods]
        @periodoSel = params[:periods][:period_id]
      else
        @periodoSel = nil
      end 
      
      if params[:noautorizado]
        @horas = HoursHeader.includes(:employee).includes(:period).where(period_id: @periodoSel, status: "autorizacion")
      else
        @horas = HoursHeader.includes(:employee).includes(:period).where(period_id: @periodoSel)  
      end
    end
  end

  def get_detalle
    id_header = params[:id_header]
    horas_detalle = HoursDetail.where(id_header: id_header).order(:id_proyecto, :fecha).to_json
    respond_to do |format|
      format.json { render :json => horas_detalle }
    end
  end

  def create
  end

  def get_proyecto
    id_proyecto = params[:id_proyecto]
    json_data = Project.find_by(id: id_proyecto).to_json
    respond_to do |format|
      format.json { render :json => json_data }
    end
  end

  def edit
  end

  def update_status
    id_header = params[:id_header]
    horas_header = HoursHeader.find_by(id: id_header)
    horas_header.update(status: 'autorizado')
    respond_to do |format|
      format.json { render :json => horas_header }
    end
  end

  def destroy
  end
end
