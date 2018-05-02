# == Schema Information
#
# Table name: rols
#
#  id          :integer          not null, primary key
#  nombre      :string
#  descripcion :string
#  funciones   :string
#  company_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Rol < ApplicationRecord
	has_many :employees_rols
	has_many :projects_rols
	belongs_to :company
	has_many :rols_permissions
	has_many :permissions, through: :rols_permissions 

	validates :nombre, presence: true, uniqueness: {case_sensitive: false ,message: "Ese rol ya esta registrado"} 
	validates :descripcion, presence: true 
	validates :funciones, presence: true 
end
