class ExpensesEmployee < ApplicationRecord
  belongs_to :expense
  belongs_to :employee
end
