# == Schema Information
#
# Table name: incomes
#
#  id         :integer          not null, primary key
#  fecha      :string
#  monto      :string
#  concept_id :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Income < ApplicationRecord
	belongs_to :concept
	belongs_to :project
	validates :fecha, presence: true 
	validates :monto, presence: true 
end
