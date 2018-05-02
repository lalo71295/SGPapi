#tabla hours_detail

class HoursDetail < ActiveRecord::Base
  self.table_name = "hours_detail"
  belongs_to :hours_header
end