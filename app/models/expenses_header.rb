# == Schema Information
#
# Table name: expenses_headers
#
#  id          :integer          not null, primary key
#  period_id   :integer
#  employee_id :integer
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  comentarios :text
#

class ExpensesHeader < ApplicationRecord
  belongs_to :period
  belongs_to :employee
  has_many :expenses
  

  enum status: [:captura, :autorizando, :autorizados, :pagados, :pagados_parcialmente]
  after_initialize :set_default_status, :if => :new_record?

  def set_default_status
    self.status ||= :captura
  end

  #Verifica si sus expenses están reembolsados y pone el encabezado como pagado
  def verifica_pagados
  	expenses = self.expenses
  	pagado = nil
  	expenses.each do |ex|
  		if !ex.rembolsado 
  			pagado = false
  		end
  	end
  	if pagado
  		self.pagados!
  	end
  end

end
