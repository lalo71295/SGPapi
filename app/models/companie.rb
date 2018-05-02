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

class Companie < ApplicationRecord
end
