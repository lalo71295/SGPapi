class TasksEmployee < ApplicationRecord
  belongs_to :employee
  belongs_to :task

  enum status: [:capturada, :asignada, :trabajando, :suspendida, :terminada, :cancelada, :cerrada]
  after_initialize :set_default_status, :if => :new_record?

  	def set_default_status
	    self.status ||= :capturada
	end
end
