# == Schema Information
#
# Table name: periods_projects_employees
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  period_id   :integer
#  status      :integer
#  notas       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PeriodsProjectsEmployee < ApplicationRecord
  belongs_to :employee
  belongs_to :project
  belongs_to :period
  
  enum status: [:captura, :autorizando, :autorizados]
  after_initialize :set_default_status, :if => :new_record?

  def set_default_status
    self.status ||= :captura
  end

  def proyecto
    project = Project.find(project_id)
    project.nombre
  end

  before_create do
    @montoExpenses = 0
  end
end
