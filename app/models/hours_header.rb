# Tabla hours_header

class HoursHeader < ActiveRecord::Base
  self.table_name = "hours_header"
  has_many :hours_details
  belongs_to :employee
  belongs_to :period
end