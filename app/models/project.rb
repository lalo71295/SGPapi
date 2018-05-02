# == Schema Information
<<<<<<< HEAD
#
# Table name: projects
#
#  id                   :integer          not null, primary key
#  clave                :string
#  nombre               :string
#  descripcion          :string
#  fecha_inicio         :date
#  fecha_fin            :date
#  company_id           :integer
#  presupuesto_ingresos :decimal(, )
#  presupuesto_egresos  :decimal(, )
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
=======
	#
	# Table name: projects
	#
	#  id                   :integer          not null, primary key
	#  clave                :string
	#  nombre               :string
	#  descripcion          :string
	#  fecha_inicio         :date
	#  fecha_fin            :date
	#  company_id           :integer
	#  presupuesto_ingresos :decimal(, )
	#  presupuesto_egresos  :decimal(, )
	#  created_at           :datetime         not null
	#  updated_at           :datetime         not null
	#
>>>>>>> master

class Project < ApplicationRecord
	belongs_to :company
	has_many :projects_rols
	has_many :minestones
	has_many :incomes
	has_many :costs
	has_many :rols, through: :projects_rols
	has_many :expenses
	has_many :employees_projects_rols, through: :projects_rols
	has_many :employees, through: :employees_projects_rols
	has_many :tasks

	validates :clave, presence: true
	validates :nombre, presence: true
	validates :descripcion, presence: true
	validates :presupuesto_ingresos, presence: true
	validates :presupuesto_egresos, presence: true

	enum status: [:capturado, :activo, :suspendido, :cancelado, :terminado]
  	after_initialize :set_default_status, :if => :new_record?

  	def set_default_status
<<<<<<< HEAD
	    self.status ||= :capturado
	end
=======
		self.status ||= :capturado
	end

	def self.del_empleado(empleado)
		self.joins(projects_rols: [:employees_projects_rols]).where("employees_projects_rols.employee_id" => empleado).group("id")
	end

	def to_param
		"#{id}-#{Digest::MD5.hexdigest(nombre)}-#{nombre.parameterize}"
	end

>>>>>>> master
end
