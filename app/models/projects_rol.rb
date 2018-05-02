# == Schema Information
#
# Table name: projects_rols
#
#  id                   :integer          not null, primary key
#  project_id           :integer
#  rol_id               :integer
#  horas_presupuestadas :integer
#  costo_hora           :decimal(, )
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class ProjectsRol < ApplicationRecord
	belongs_to :rol
	belongs_to :project
  has_many :employees_projects_rols
  has_many :employees, through: :employees_projects_rols

	validates :horas_presupuestadas, presence: true
	validates :costo_hora, presence: true
end
