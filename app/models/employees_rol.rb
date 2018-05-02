# == Schema Information
#
# Table name: employees_rols
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  rol_id      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class EmployeesRol < ApplicationRecord
	belongs_to :employee
	belongs_to :rol
end
