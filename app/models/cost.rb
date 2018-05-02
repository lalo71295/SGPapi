# == Schema Information
#
# Table name: costs
#
#  id         :integer          not null, primary key
#  fecha      :date
#  monto      :decimal(, )
#  project_id :integer
#  concept_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
# 

class Cost < ApplicationRecord
	belongs_to :project
	belongs_to :concept
	validates :monto, presence: true 
	validates :concept, uniqueness: {case_sensitive: false ,message: "Ese concepto ya esta registrado"}
end
