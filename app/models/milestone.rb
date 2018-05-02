# == Schema Information
#
# Table name: milestones
#
#  id          :integer          not null, primary key
#  fecha       :date
#  orden       :integer
#  nombre      :string
#  descripcion :text
#  project_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Milestone < ApplicationRecord
	belongs_to :project
	validates :orden, presence: true
	validates :nombre, presence: true, uniqueness: {case_sensitive: false ,message: "Ese hito ya esta registrado para ese proyecto"}
	validates :descripcion, presence: true
end
