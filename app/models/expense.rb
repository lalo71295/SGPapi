# == Schema Information
<<<<<<< HEAD
#
# Table name: expenses
#
#  id                 :integer          not null, primary key
#  concept_id         :integer
#  fecha              :date
#  monto              :decimal(, )
#  comentarios        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  expenses_header_id :integer
#  project_id         :integer
#
=======
  #
  # Table name: expenses
  #
  #  id                 :integer          not null, primary key
  #  concept_id         :integer
  #  fecha              :date
  #  monto              :decimal(, )
  #  comentarios        :string
  #  created_at         :datetime         not null
  #  updated_at         :datetime         not null
  #  expenses_header_id :integer
  #  project_id         :integer
  #
>>>>>>> master

class Expense < ApplicationRecord
  belongs_to :expenses_header
  belongs_to :concept
  belongs_to :project
  belongs_to :refund
  has_many :expenses_attachments
  has_many :expenses_employees
  has_many :employees, through: :expenses_employees
  belongs_to :invoices_got, foreign_key: "invoices_gots_id"
<<<<<<< HEAD
=======

  def self.especifico(id)
    self.find(id)
  end
>>>>>>> master
end
