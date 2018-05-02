# == Schema Information
#
# Table name: companies
#
#  id          :integer          not null, primary key
#  nombre      :string
#  logo        :string
#  descripcion :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Company < ApplicationRecord
	has_many :projects
	has_many :rols
	has_many :departments
end
