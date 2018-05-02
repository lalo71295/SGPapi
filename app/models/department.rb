# == Schema Information
#
# Table name: departments
#
#  id          :integer          not null, primary key
#  nombre      :string
#  descripcion :string
#  company_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Department < ApplicationRecord
	has_many :employees
	belongs_to :company
<<<<<<< HEAD
=======

	validates :nombre, uniqueness: true
>>>>>>> master
end
