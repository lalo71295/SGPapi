# == Schema Information
#
# Table name: cities
#
#  id          :integer          not null, primary key
#  nombre      :string
#  abreviacion :string
#  state_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class City < ApplicationRecord
	belongs_to :state
	has_many :employees
end
