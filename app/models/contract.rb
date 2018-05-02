# == Schema Information
#
# Table name: contracts
#
#  id            :integer          not null, primary key
#  nombre        :string
#  descripcion   :string
#  tipo_contrato :integer
#  fecha_inicio  :date
#  fecha_fin     :date
#  estado        :integer
#  employee_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Contract < ApplicationRecord
	belongs_to :employee
end
