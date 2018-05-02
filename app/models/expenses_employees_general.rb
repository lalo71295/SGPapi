class ExpensesEmployeesGeneral < ApplicationRecord
  belongs_to :expenses_general
  belongs_to :employee
  validates :employee_id, presence: {message: 'El Monto es obligatorio.'}
end
