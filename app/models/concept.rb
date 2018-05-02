# == Schema Information
#
# Table name: concepts
#
#  id            :integer          not null, primary key
#  nombre        :string
#  descripcion   :string
#  tipo          :integer
#  clasificacion :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :boolean
#

class Concept < ApplicationRecord
	has_many :costs
	has_many :incomes
	validates :nombre, presence: true, uniqueness: {case_sensitive: false ,message: "Ese concepto ya esta registrado"}
	validates :descripcion, presence: true
<<<<<<< HEAD
=======

	def self.con_clasificacion_empleados
		self.where(clasificacion: 1)
	end
>>>>>>> master
end
