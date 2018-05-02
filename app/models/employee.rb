# == Schema Information
	#
	# Table name: employees
	#
	#  id                 :integer          not null, primary key
	#  nombre             :string
	#  apellido_paterno   :string
	#  apellido_materno   :string
	#  fecha_nacimiento   :date
	#  direccion          :text
	#  telefono           :string
	#  celular            :string
	#  email_personal     :string
	#  carrera            :string
	#  fecha_ingreso      :date
	#  fecha_egreso       :date
	#  costoxhora         :decimal(, )
	#  foto               :string
	#  city_id            :integer
	#  department_id      :integer
	#  created_at         :datetime         not null
	#  updated_at         :datetime         not null
	#  status             :boolean
	#  cover_file_name    :string
	#  cover_content_type :string
	#  cover_file_size    :integer
	#  cover_updated_at   :datetime
	#  user_id            :integer
	#

class Employee < ApplicationRecord
	belongs_to :city
	belongs_to :department
	belongs_to :user
	has_many :contracts
	has_many :employees_projects_rols
	has_many :projects, through: :employees_projects_rols
	has_many :expenses_headers
	has_many :expenses, through: :expenses_headers
	has_many :tasks_employees
	has_many :tasks, through: :tasks_employees
	has_many :refunds
	has_many :expenses_employees_generals
	has_many :expenses_generals, through: :expenses_employees_generals
	has_many :hours_headers
	




	validates :nombre, presence: true
	validates :apellido_paterno, presence: true
	validates :apellido_materno, presence: true
	validates :direccion, presence: true
	validates :telefono, presence: true
	validates :celular, presence: true
	validates :email_personal, presence: true, uniqueness: {case_sensitive: false ,message: "Ese e-mail ya esta registrado"}
	validates :carrera, presence: true
	validates :costoxhora, presence: true
	validates :foto, presence: false

	has_attached_file :cover, styles:{thumb:"800x600", mini:"500x300", thumb: "100x100"}
	validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

	attr_accessor :seleccionado

	def nombre_completo
		"#{nombre.upcase} #{apellido_paterno.upcase} #{apellido_materno.upcase}"
	end

	def nombre_apellido
    	"#{nombre} #{apellido_paterno} #{apellido_materno}"
 	end

 	def getProjects
  		@epr = EmployeesProjectsRol.find_by(employee_id: self.id)
  		@proyectos = @epr.project.nombre
  end

end
