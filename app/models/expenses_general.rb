class ExpensesGeneral < ApplicationRecord
  belongs_to :concept
  belongs_to :project
  belongs_to :refund
  belongs_to :period
  #belongs_to :employee
  has_many :expenses_generals_attachments
  has_many :expenses_employees_generals
  has_many :employees, through: :expenses_employees_generals
  belongs_to :invoices_got, foreign_key: "invoices_gots_id"

  #validates :monto, presence: true {message: "El Monto es obligatorio"}
  validates :period_id, presence: { message: 'El Periodo es obligatorio.'}
  validates :project_id, presence: { message: 'El Proyecto es obligatorio.'}
  validates :concept_id, presence:{ message: 'El Concepto es obligatorio.'}
  validates :monto, presence: {message: 'El Monto es obligatorio.'}
  


  enum status: [:captura, :autorizando, :autorizados, :pagados, :pagados_parcialmente]
  after_initialize :set_default_status, :if => :new_record?


  def set_default_status
    self.status ||= :captura
  end
  

   #Verifica si sus expenses están reembolsados y pone el encabezado como pagado
  def verifica_pagados
    expenses_general  = self.expenses_general
    pagado = nil
    expenses_general.each do |ex|
      if !ex.rembolsado 
        pagado = false
      end
    end
    if pagado
      self.pagados!
    end
  end



end
