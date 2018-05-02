# == Schema Information
#
# Table name: employees_projects_rols
#
#  id              :integer          not null, primary key
#  employee_id     :integer
#  projects_rol_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class EmployeesProjectsRol < ApplicationRecord
  belongs_to :employee #tiene enlazada la tabla employees
  belongs_to :projects_rol #tiene enlazada la tabla projects_rol
  has_one :project, through: :projects_rol #es una union, la tabla project atra vez de la tabla projects_rol

  has_one :user, through: :employee

  def proyecto_rol2 #metodo que trae nombre de projecto por medio de la union has_one, ya que se enlaza
	  	"#{project.nombre}"
  end
end
