class Refund < ApplicationRecord
	belongs_to :employee
	has_many :expenses
	has_many :expenses_generals

	has_attached_file :archivo, path: ":rails_root/archivos/reembolsos/:employee_id/:filename"
  	#path: ":rails_root/archivos/viaticos/:expense/:filename"
  	do_not_validate_attachment_file_type :archivo #Necesita cambiarse

  	Paperclip.interpolates :employee_id do |attachment, style|
		attachment.instance.employee_id
	end

	def self.mes(mes = 1)
		today   = Date.today # => Thu, 18 Jun 2015
		if mes == 1
			fInicio = today.beginning_of_month.to_s(:db)
		else
			fInicio = today.months_ago(mes).to_s(:db)
		end
	    fFinal  = today.to_s(:db)#(Date.today + 1).to_s(:db)

	    where(["fecha >= '%s' and fecha <= '%s'", fInicio, fFinal]).order(fecha: :desc)
	end
end
