# == Schema Information
#
# Table name: expenses_generals_attachments
#
#  id                   :integer          not null, primary key
#  expenses_general_id  :integer
#  archivo              :string
#  descripcion          :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  archivo_file_name    :string
#  archivo_content_type :string
#  archivo_file_size    :integer
#  archivo_updated_at   :datetime
#

class ExpensesGeneralsAttachment < ApplicationRecord
  belongs_to :expenses_general
  #has_attached_file :archivo, path: ":rails_root/archivos/:id/:style/:filename"
  has_attached_file :archivo, path: ":rails_root/archivos/viaticos/:expenses_general_id/:filename"
  #path: ":rails_root/archivos/viaticos/:expense/:filename"
  do_not_validate_attachment_file_type :archivo #Necesita cambiarse

  attr_accessor :expenses_general

  enum tipo: [:otro, :xml_de_factura, :pdf_de_factura]
  after_initialize :set_default_tipo, :if => :new_record? 

  Paperclip.interpolates :expenses_general_id do |attachment, style|
    attachment.instance.expenses_general_id
  end

  before_post_process :rename_attachment

  def procesar_archivo(tipo, archivo, expense_id)
    ret = {}
      # if tipo == "0"
        #   File.open(Rails.root.join('archivos', 'tmp',archivo.original_filename), 'wb') do |file|
        #     file.write(archivo.read)
        #   end
        #   path1         = 'archivos/tmp/'
        #   path2         = 'archivos/viaticos/'
        #   file_name     = path1 + archivo.original_filename
        #   #File.rename(path1 + archivo.original_filename, path2 + archivo.original_filename)
        #   #extension     = File.extname file_name
        #   #file_name_woe = archivo.original_filename.remove(extension)
        #   #random        = p SecureRandom.hex(10)
        #   #nuevo_archivo = random + "_" + file_name_woe + extension
        #   #File.rename(path1 + archivo.original_filename, path2 + nuevo_archivo) 
        #   ret = {"validado" => true, "nombre_archivo" => file_name, "mensaje" => "#{archivo.original_filename}"}
    
    if tipo == "xml_de_factura"
      begin
        expense = ExpensesGeneral.find(expense_id)

        if !expense.invoices_gots_id #Se valida si ya existe el comprobante asignado al expense
          invoice_got = InvoicesGot.new
          config_rfcs_receptores = Config.find_by(parametro: 'rfcs_receptores')
          chrespeciales = false
          arc_valido = false
          file_name = ''

          File.open(Rails.root.join('archivos', 'tmp',archivo.original_filename), 'wb') do |file|
            file.write(archivo.read)
            file_name = 'archivos/tmp/' + archivo.original_filename
            extension = File.extname file_name
            if extension == '.xml'
              arc_valido = true
            else
              File.delete(file_name) if File.exist?(file_name)
              ret = {"validado" => false, "nombre_archivo" => File.basename(file_name), "mensaje" => " El archivo no es XML "}
            end          
          end

          if arc_valido == true
            #Se obtienen los datos del xml y se procede a guardarlo en la base de datos
            factura = CFDI.from_xml(File.read(file_name),chrespeciales)
            #byebug
            proceso = invoice_got.guarda_xml(factura, file_name, config_rfcs_receptores.valor.split('|'))

            if proceso == true
                if invoice_got.save
                  expense.invoices_gots_id = invoice_got.id
                  expense.save

                  invoice_got.status = "asignado"
                  expenses_attachments = ExpensesAttachment.find_by(expense_id: expense.id, tipo: :pdf_de_factura)
                  if expenses_attachments
                    #byebug
                    ruta_origen  = 'archivos/viaticos/' + expenses_attachments.expense_id.to_s + '/' + expenses_attachments.archivo_file_name
                    ruta_destino = 'archivos/buzoncfdi/pdf/' + expenses_attachments.archivo_file_name
                    FileUtils.cp ruta_origen, ruta_destino
                    invoice_got.pdf = expenses_attachments.archivo_file_name
                  end

                  invoice_got.set_status_sat_after_validate


                  File.delete(file_name) if File.exist?(file_name)

                  ret = {"validado" => true, "nombre_archivo" => File.basename(file_name), "mensaje" => ""}
                else
                  ret = {"validado" => false, "nombre_archivo" => File.basename(file_name), "mensaje" => " - Fallo al guardar el comprobante "}
                end
            else
              #puts '>>>>>>>>>>>>>' + invoice_got.errores[:mensaje]
              File.delete(file_name) if File.exist?(file_name)
              ret = {"validado" => false, "nombre_archivo" => File.basename(file_name), "mensaje" => " - Error al procesar el comprobante: #{invoice_got.errores[:mensaje].to_s}"}
            end
          else
            File.delete(file_name) if File.exist?(file_name)
            ret = {"validado" => false, "nombre_archivo" => File.basename(file_name), "mensaje" => " - Error con el formato del archivo"} 
          end
        else
          ret = {"validado" => false, "nombre_archivo" => archivo.original_filename, "mensaje" => " - Ya existe un CFDI para este viático "}
        end
      rescue Exception => ex
        file_name = 'archivos/tmp/' + archivo.original_filename
        File.delete(file_name) if File.exist?(file_name)
        ret = {"validado" => false, "nombre_archivo" => archivo.original_filename, "mensaje" => ": #{ex} "}
      end
    elsif tipo == "pdf_de_factura"
      begin
        arc_valido  = false
        path_pdf    = 'archivos/buzoncfdi/pdf/'
        file_name   = ''
        File.open(Rails.root.join('archivos', 'tmp',archivo.original_filename), 'wb') do |file|
          file.write(archivo.read)
          file_name = 'archivos/tmp/' + archivo.original_filename
          extension = File.extname file_name
          if extension == '.pdf'
            arc_valido = true
          else
            File.delete(file_name) if File.exist?(file_name)
            ret = {"validado" => false, "nombre_archivo" => File.basename(file_name), "mensaje" => " El archivo no es PDF "}
          end          
        end

        if arc_valido == true
          expense = ExpensesGeneral.find(expense_id)
          if expense.invoices_gots_id 
            invoices_got = InvoicesGot.find(expense.invoices_gots_id)
          else
            invoices_got = nil
          end
          if invoices_got #Si ya hay cargado un CFDI para este viatico
            #byebug
            if !invoices_got.pdf #Si ya hay un PDF cargado para este viatico
              target_file = path_pdf + archivo.original_filename
              if File.exist?(target_file)
                extension     = File.extname file_name
                file_name_woe = archivo.original_filename.remove(extension)
                random    = p SecureRandom.hex(10)
                target_file   = path_pdf + file_name_woe + random + extension
              end
              File.rename(file_name, target_file)
              invoices_got.pdf = File.basename(target_file)
              invoices_got.save
              ret = {"validado" => true, "nombre_archivo" => File.basename(file_name), "mensaje" => ""}
            else
              File.delete(file_name) if File.exist?(file_name)
              ret = {"validado" => false, "nombre_archivo" => File.basename(file_name), "mensaje" => " Ya existe un pdf para la factura"}
            end
          else
            File.delete(file_name) if File.exist?(file_name)
            ret = {"validado" => true, "nombre_archivo" => File.basename(file_name), "mensaje" => ""}
          end 
        else
          File.delete(file_name) if File.exist?(file_name)
          ret = {"validado" => false, "nombre_archivo" => File.basename(file_name), "mensaje" => " - Problema al subir el archivo"} 
        end
        
      rescue Exception => ex
        #File.delete(file_name) if File.exist?(file_name)
        ret = {"validado" => false, "nombre_archivo" => File.basename(file_name), "mensaje" => " : #{ex} "}
      end
    end
    ret
  end

  def set_default_tipo
    self.tipo ||= :otro
  end

  def rename_attachment
    #avatar_file_name - important is the first word - avatar - depends on your column in DB table
    extension = File.extname(archivo_file_name).downcase
    file_name_woe = archivo_file_name.remove(extension)
    random    = p SecureRandom.hex(10)
    self.archivo.instance_write :file_name, "#{file_name_woe}_#{random}#{extension}"
  end
end
