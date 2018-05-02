class Task < ApplicationRecord
	belongs_to :classification
	belongs_to :project, counter_cache: true
	has_many :tasks_employees
	has_many :employees, through: :tasks_employees
	has_many :task_durations
	has_one :asignador, class_name: "Employee", foreign_key: "id"

	validates_presence_of :asunto, :descripcion, :project_id
  	#validates :pricing, numericality: { greater_than: 0 }

  	enum status: [:capturada, :asignada, :desplegada, :suspendida, :terminada, :cancelada, :cerrada]
  	after_initialize :set_default_status, :if => :new_record?
	enum prioridad: [:alta, :media, :baja]

	def set_default_status
	    self.status ||= :capturada
	    self.prioridad ||= :baja
	    self.fecha 			= DateTime.current
	end
end
