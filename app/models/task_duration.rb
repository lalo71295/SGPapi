class TaskDuration < ApplicationRecord
  belongs_to :employee
  belongs_to :task

  #validates_presence_of :minutos, :retro, :fecha
  def self.horas_incurridas(empleado, tipo_periodo="semanal")
  	if tipo_periodo == "semanal"
  		periodo = Time.now.beginning_of_week().beginning_of_day.to_formatted_s(:db)
  	elsif tipo_periodo == "mensual"
  		periodo = Time.now.beginning_of_month()
  	end
  	#periodo = Today.current
  	where(employee_id: empleado).where("fecha >= ?",periodo).group_by_day(:fecha, day_start: 0,  format: "%Y-%m-%d").sum(:minutos)
  end
end
