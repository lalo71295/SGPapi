# == Schema Information
#
# Table name: hours
#
#  id                           :integer          not null, primary key
#  fecha                        :date
#  horas                        :integer
#  periods_projects_employee_id :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  project_id                   :integer
#

class Hour < ApplicationRecord
  belongs_to :periods_projects_employee
  has_one :project, through: :periods_projects_employee


  def self.ciclo(fecha)
  	day = fecha.cwday
  	if day == 1
   		dia = "lunes"
	elsif day == 2
		dia = "Martes"
	elsif day == 3
		dia = "Miercoles"
	elsif day == 4
		dia = "Jueves"
	elsif day == 5
		dia = "Viernes"
	elsif day == 6
		dia = "Sabado"
	elsif day == 7
		dia = "Domingo"
	end
    return dia
  end#end del self.ciclo

  def self.nombre_proyecto(id)
	if id
		pros = Project.all
		profind = pros.find(id)
		pronom = profind.nombre
		return pronom 	
	end
  end#end nommbre_proyecto

  def self.statusppe(per,emp)
  	if per
	  	sta = PeriodsProjectsEmployee.find_by(employee_id:emp, period_id:per)
	  	status = sta.status
	  	return status
  	end
  end#end statusppe

  def self.hours_day(ppe,proy,day)
  	horareg = Hour.select(:id,:fecha,:horas).where("hours.periods_projects_employee_id"=>ppe,"hours.project_id"=>proy)
    hl = horareg.length
    for i in 0..hl-1 do
    	fecha = horareg[i].fecha
    	if fecha.cwday==day
    		cons = Hour.find_by(periods_projects_employee_id:ppe,project_id:proy,fecha:fecha)
    		res = cons.horas
    	end
    end
    return res		
  end

    def self.hours_total(ppe,proy)
  	horareg = Hour.select(:id,:fecha,:horas).where("hours.periods_projects_employee_id"=>ppe,"hours.project_id"=>proy)
    hl = horareg.length
    total = 0
    for i in 0..hl-1 do
    	fecha = horareg[i].horas
    	total = total + fecha
    end
    return total		
  end

 



end#end de clase
