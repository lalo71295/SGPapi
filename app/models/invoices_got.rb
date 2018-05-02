# == Schema Information
  #
  # Table name: invoices_gots
  #
  #  id                          :integer          not null, primary key
  #  folio                       :string(30)
  #  serie                       :string(30)
  #  fecha                       :datetime
  #  forma_de_pago               :string(60)
  #  condiciones_de_pago         :string
  #  no_certificado              :string(20)
  #  subtotal                    :decimal(11, 2)   not null
  #  total                       :decimal(11, 2)   not null
  #  moneda                      :string(20)       not null
  #  metodo_de_pago              :string(30)
  #  tipo_de_comprobante         :string(30)
  #  num_cta_pago                :string(20)
  #  emisor_rfc                  :string(13)       not null
  #  emisor_razon_social         :string           not null
  #  emisor_datos                :text
  #  receptor_rfc                :string(13)       not null
  #  receptor_razon_social       :string           not null
  #  receptor_datos              :text
  #  conceptos                   :text             not null
  #  total_impuestos_trasladados :decimal(11, 2)
  #  total_impuestos_retenidos   :decimal(11, 2)
  #  impuestos                   :text
  #  sello_cfd                   :text
  #  fecha_timbrado              :datetime
  #  uuid                        :string(36)
  #  no_certificado_sat          :string(20)
  #  sello_sat                   :text
  #  status                      :integer
  #  xml                         :text
  #  created_at                  :datetime         not null
  #  updated_at                  :datetime         not null
  #  archivoxml_file_name        :string
  #  archivoxml_content_type     :string
  #  archivoxml_file_size        :integer
  #  archivoxml_updated_at       :datetime
  #

class InvoicesGot < ApplicationRecord
<<<<<<< HEAD
  require 'cfdi'
=======
  #require 'cfdi'
>>>>>>> master
  include ActionView::Helpers::NumberHelper

  attr_accessor :errores, :proceso

  enum status: [:capturado, :asignado, :pagado]
  enum status_sat: [:captura, :validado, :no_valido, :cancelado]
  after_initialize :set_default_status, :if => :new_record?

  def set_default_status
    self.status ||= :capturado
    self.status_sat ||= :captura
    self.moneda = 'MXN' if self.moneda.nil?
  end

  #Obtiene los cfdi contenidos en la db filtrados por mes
  def self.por_mes(mes, anio=nil, receptor=nil, status=nil)
    if anio
      str_fecha = anio + "-" + mes.to_s + "-01 00:00:00"
    else
      str_fecha = Date.current.year.to_s + "-" + mes.to_s + "-01 00:00:00"
    end
    dt = str_fecha.to_datetime
    bom = dt.beginning_of_month
    eom = dt.end_of_month
    if status
      where("fecha >= ? and fecha <= ? and receptor_rfc = ? and status in ?", bom, eom, receptor, status)
    else
      where("fecha >= ? and fecha <= ? and receptor_rfc = ?", bom, eom, receptor)
    end
  end

  #Procesa de forma masiva los archivos xml cargados
  def procesa_xmls(arArchivos, chrespeciales=false)
    config_rfcs_receptores = Config.find_by(parametro: 'rfcs_receptores')

    if arArchivos.count > 0
      procesados  = 0
      guardados   = 0
      fallidos    = 0
      arreglo_fallidos = Array.new

      arArchivos.each do |archivo_path|

        begin
<<<<<<< HEAD
          proceso = false 
          invoice_got = InvoicesGot.new 
=======
          proceso = false
          invoice_got = InvoicesGot.new
>>>>>>> master
          #Se obtienen los datos del xml y se procede a guardarlo en la base de datos
          factura = CFDI.from_xml(File.read(archivo_path),chrespeciales)
          #byebug
          proceso = invoice_got.guarda_xml(factura, archivo_path, config_rfcs_receptores.valor.split('|'))

          #byebug

          begin
            if proceso == true
              if invoice_got.save
                guardados += 1
              end
            else
                arreglo_fallidos << invoice_got.errores
                fallidos += 1
            end
          rescue Exception => e
            #byebug
            arreglo_fallidos << {:mensaje => "Error al guardar el archivo #{File.basename(archivo_path)}", :detalle => "#{e}"}
            logger.debug e
            fallidos += 1
          end

          if proceso
            #Validación de cada xml contra el webservice
              # response = invoice_got.valida_cfdi_webservice(invoice_got.emisor_rfc, invoice_got.receptor_rfc,  invoice_got.total, invoice_got.uuid)
<<<<<<< HEAD
              # if response 
=======
              # if response
>>>>>>> master
              #   if response.body[:consulta_response][:consulta_result][:estado] == "Vigente"
              #     invoice_got.texto_validacion = response.body[:consulta_response][:consulta_result][:codigo_estatus]
              #     invoice_got.status_sat = :validado
              #     invoice_got.save
              #     #invoice_got.validado!
              #   else
              #     invoice_got.texto_validacion = response.body[:consulta_response][:consulta_result][:codigo_estatus]
              #     invoice_got.status_sat = :no_validado
              #     invoice_got.save
              #     #invoice_got.no_valido!
              #   end
              # end
              invoice_got.set_status_sat_after_validate
          end

          procesados += 1

        rescue Exception => ex
          arreglo_fallidos << {:mensaje => "Error de formato con el archivo #{File.basename(archivo_path)} - #{ex}", :detalle => "#{ex}"}
          logger.debug ex
          fallidos += 1
        end

      end
    end

    resumen = "<br>Total de Procesados: #{procesados}<br>Total de guardados correctamente: #{guardados}<br>Total de Fallidos: #{fallidos}<br>"

    if arreglo_fallidos.count > 0
      resumen += "Resumen de Fallidos: <br>"
      arreglo_fallidos.each do |fails|
        #byebug
        resumen += " - #{fails[:mensaje]}<br>"
      end
    end
    resumen
  end

  #Extrae los datos del xml de u CFDI y los guarda en la db
  def guarda_xml(archivo_xml, xml_path, rfcs_receptores)
    self.errores = Hash.new
    nombre_archivo_xml = File.basename xml_path
    begin
      #Asignaciones
        self.folio                  = archivo_xml.folio
        self.serie                  = archivo_xml.serie
        self.fecha                  = archivo_xml.fecha.to_datetime
        self.forma_de_pago          = archivo_xml.formaDePago
        self.condiciones_de_pago    = archivo_xml.condicionesDePago
        self.no_certificado         = archivo_xml.noCertificado
        self.subtotal               = archivo_xml.subTotal
        self.total                  = archivo_xml.total
        self.descuento              = archivo_xml.descuento
        self.moneda                 = archivo_xml.moneda
        self.metodo_de_pago         = archivo_xml.metodoDePago
        self.tipo_de_comprobante    = archivo_xml.tipoDeComprobante
        self.num_cta_pago           = archivo_xml.NumCtaPago
        self.emisor_rfc             = archivo_xml.emisor.rfc
        self.emisor_razon_social    = archivo_xml.emisor.nombre
        self.emisor_datos           = archivo_xml.emisor.to_json
        self.receptor_rfc           = archivo_xml.receptor.rfc
        self.receptor_razon_social  = archivo_xml.receptor.nombre
        self.receptor_datos         = archivo_xml.receptor.to_json
        self.conceptos              = archivo_xml.conceptos.to_json
        self.total_impuestos_trasladados  = archivo_xml.impuestos.totalImpuestosTrasladados
        self.total_impuestos_retenidos    = archivo_xml.impuestos.totalImpuestosRetenidos
        self.impuestos              = archivo_xml.impuestos.to_json
        self.sello_cfd              = archivo_xml.sello
        self.fecha_timbrado         = archivo_xml.complemento.FechaTimbrado.to_datetime
        self.uuid                   = archivo_xml.complemento.UUID
        self.no_certificado_sat     = archivo_xml.complemento.noCertificadoSAT
        self.sello_sat              = archivo_xml.complemento.selloCFD
        self.status                 = 0
        self.xml                    = File.read(xml_path).to_s

      uuid   = archivo_xml.complemento.UUID
      folio  = archivo_xml.folio
      fecha  = archivo_xml.fecha
      emisor = archivo_xml.emisor.nombre

      ig = InvoicesGot.find_by(uuid: uuid)

      cfdi = {:uuid =>  uuid, :folio => folio, :fecha => fecha, :emisor_razon_social => emisor, :nombre_archivo_xml => nombre_archivo_xml }
      if ig
        self.errores = {:mensaje => "El CFDI #{uuid} ya se encontraba en la base de datos (#{nombre_archivo_xml})", :detalle => cfdi}
        self.proceso = false
      else
        if rfcs_receptores.include?(archivo_xml.receptor.rfc)
          self.proceso = true
        else
          self.errores = {:mensaje => "El CFDI #{uuid} (#{nombre_archivo_xml}) no está dirigido a la(s) razon(es) social(es) de la empresa", :detalle => cfdi}
          self.proceso = false
        end
        #self.proceso = true
      end

    rescue Exception => exc
      self.errores = {:mensaje => "Error al leer el xml #{nombre_archivo_xml}", :detalle => exc}
      self.proceso = false
    end
  end

  #Valida un CFDI contra el esquema xsd
  def valida_cfdi(archivo_path)
    schema_cfd_path = 'app/assets/extras/cfdv32.xsd'
    schema_cfd      = Nokogiri::XML::Schema(File.read(schema_cfd_path))
    schema_tfd_path = 'app/assets/extras/TimbreFiscalDigital.xsd'
    schema_tfd      = Nokogiri::XML::Schema(File.read(schema_tfd_path))

    documento_completo    = Nokogiri::XML(File.read(archivo_path))

    #Validación del xml contra el esquema
    schema.validate(document.xpath("//cfdi").to_s)
  end

  #Hace el llamado del Webservice de validación del SAT para validar un CFDI
  def valida_cfdi_webservice(re, rr, tt, uuid)
    begin
      namespaces = {
          "xmlns:tem" => "http://tempuri.org/",
      }
<<<<<<< HEAD
      client = Savon.client(wsdl: "https://consultaqr.facturaelectronica.sat.gob.mx/consultacfdiservice.svc?wsdl", 
                              #log: true,
                              #log_level: :debug,
                              open_timeout: 5, 
=======
      client = Savon.client(wsdl: "https://consultaqr.facturaelectronica.sat.gob.mx/consultacfdiservice.svc?wsdl",
                              #log: true,
                              #log_level: :debug,
                              open_timeout: 5,
>>>>>>> master
                              read_timeout: 5,
                              pretty_print_xml: true,
                              env_namespace: :soapenv,
                              namespaces: namespaces,
                              namespace_identifier: :tem)
<<<<<<< HEAD
      
      #op = client.operations
      body = {:"tem:expresionImpresa!" => "<![CDATA[?re="+re+"&rr="+rr+"&tt="+number_to_currency(tt.to_f, precision: 6, separator: ".", format: "%n").to_s+"&id="+uuid+"]]>"};

      response = client.call(:consulta) do 
=======

      #op = client.operations
      body = {:"tem:expresionImpresa!" => "<![CDATA[?re="+re+"&rr="+rr+"&tt="+number_to_currency(tt.to_f, precision: 6, separator: ".", format: "%n").to_s+"&id="+uuid+"]]>"};

      response = client.call(:consulta) do
>>>>>>> master
          message body
      end

      response

    rescue Exception => exc
      response = false
    end
  end

  #Manda llamar la validación por webservice y guarda el resultado en la db
  def valida_cfdi_status()
    response = self.valida_cfdi_webservice(self.emisor_rfc, self.receptor_rfc,  self.total, self.uuid)
<<<<<<< HEAD
    if response 
=======
    if response
>>>>>>> master
      if response.body[:consulta_response][:consulta_result][:estado] == "Vigente"
        self.texto_validacion = response.body[:consulta_response][:consulta_result][:codigo_estatus]
        self.status_sat = :validado
        self.save
        #self.validado!
      elsif response.body[:consulta_response][:consulta_result][:estado] == "Cancelado"
        self.texto_validacion = response.body[:consulta_response][:consulta_result][:codigo_estatus]
        self.status_sat = :cancelado
        self.save
      else
        self.texto_validacion = response.body[:consulta_response][:consulta_result][:codigo_estatus]
        self.status_sat = :no_valido
        self.save
        #self.no_valido!
      end
    end
    response
  end

  #Vuelve a leer el xml contenido en la db para cargar la info en su mismo renglón
  def regenera_facturas
    invoice_got = InvoicesGot.all
    invoice_got.each do |ig|
      factura = CFDI.from_xml(ig.xml)
      if !ig.descuento
        ig.descuento = factura.descuento
        ig.save
      end
    end
  end

  #Procesa de forma masiva archivos pdf para verificar si existe un uuid dentro de este y al final lo sube y lo asigna al cfdi
  def procesar_pdfs(archivos)
    invoices_gots = InvoicesGot.where(pdf: nil).pluck(:uuid)
    arArchivos = Array.new
    path1 = 'archivos/buzoncfdi/'
    path2 = 'archivos/buzoncfdi/pdf/'
    resumen = Array.new
    archivos.each do |arc|
        File.open(Rails.root.join('archivos', 'buzoncfdi',arc.original_filename), 'wb') do |file|
          file.write(arc.read)
          file_name = path1 + arc.original_filename
          arArchivos << file_name
        end
    end

    i = 0
    arArchivos.each do |archivo|
      begin
        texto = ''
        encontrado = false
        reader = PDF::Reader.new(archivo)
        reader.pages.each do |page|
          texto += page.text
        end
<<<<<<< HEAD
        
        invoices_gots.each do |uuid| 
=======

        invoices_gots.each do |uuid|
>>>>>>> master
          if texto.include? uuid
            encontrado = true
            ig = InvoicesGot.find_by(uuid: uuid)
            ig.pdf = File.basename(archivo)
            ig.save
          end
        end
<<<<<<< HEAD
        
=======

>>>>>>> master
        if encontrado == true
          File.rename(archivo, path2 + File.basename(archivo))
          resumen[i] = {"estado"=>"procesado","detalle"=>"El archivo #{File.basename(archivo)} contenía un UUID correcto y fue añadido a la base de datos"}
        else
<<<<<<< HEAD
          File.delete(archivo) if File.exist?(archivo) 
          resumen[i] = {"estado"=>"incorrecto","detalle"=>"No se encontró UUID en el archivo #{File.basename(archivo)} o el archivo fue procesado anteriormente"}
        end
      rescue Exception => e
        File.delete(archivo) if File.exist?(archivo) 
=======
          File.delete(archivo) if File.exist?(archivo)
          resumen[i] = {"estado"=>"incorrecto","detalle"=>"No se encontró UUID en el archivo #{File.basename(archivo)} o el archivo fue procesado anteriormente"}
        end
      rescue Exception => e
        File.delete(archivo) if File.exist?(archivo)
>>>>>>> master
        resumen[i] = {"estado"=>"incorrecto","detalle"=>"Error al leer el archivo #{File.basename(archivo)}"}
      end
      i+=1
    end
<<<<<<< HEAD
    resumen 
=======
    resumen
>>>>>>> master
  end

  #Carga de forma individual un pdf a un cfdi en la db
  def cargar_pdf(archivo, uuid)
    path_pdf      = 'archivos/buzoncfdi/pdf/'
    path_archivo  = ''
    resultado     = nil
<<<<<<< HEAD
    
=======

>>>>>>> master
    begin
      ig = InvoicesGot.find_by(uuid: uuid)

      File.open(Rails.root.join('archivos', 'buzoncfdi','pdf',archivo.original_filename), 'wb') do |file|
        file.write(archivo.read)
        path_archivo = path_pdf + archivo.original_filename
      end

      if File.exist?(path_archivo)
<<<<<<< HEAD
        if ig.pdf 
=======
        if ig.pdf
>>>>>>> master
          archivo_anterior = path_pdf + ig.pdf
          File.delete(archivo_anterior) if File.exist?(archivo_anterior)
        end
        ig.pdf = File.basename(path_archivo)
<<<<<<< HEAD
        ig.save  
=======
        ig.save
>>>>>>> master
        resultado = {"estado"=>"correcto","mensaje"=>"Se cargó correctamente el archivo"}
      else
        resultado = {"estado"=>"error","mensaje"=>"No se subió el archivo"}
      end
      resultado
    rescue Exception => e
      resultado = {"estado"=>"error","mensaje"=>"No se subió el archivo, detalle: #{e.message}"}
    end
  end

  def eliminar_cfdi(uuid)
    resultado     = nil
    begin
      ig = InvoicesGot.find_by(uuid: uuid)
      if ig.pdf
        path_pdf      = 'archivos/buzoncfdi/pdf/'
        path_pdf_fin  = path_pdf + ig.pdf
        File.delete(path_pdf_fin) if File.exist?(path_pdf_fin)
      end

      if ig.xml
        path_xml      = 'archivos/buzoncfdi/'
        path_xml_fin  = path_xml + ig.xml
        File.delete(path_xml_fin) if File.exist?(path_xml_fin)
      end

<<<<<<< HEAD
      ig.destroy      
=======
      ig.destroy
>>>>>>> master
      resultado = {"estado"=>"correcto","mensaje"=>"Se eliminó correctamente el CFDI"}
    rescue Exception => e
      resultado = {"estado"=>"error","mensaje"=>"No se pudo eliminar el CFDI, detalle: #{e.message}"}
    end
  end

  def set_status_sat_after_validate
    response = self.valida_cfdi_webservice(self.emisor_rfc, self.receptor_rfc,  self.total, self.uuid)
<<<<<<< HEAD
    if response 
=======
    if response
>>>>>>> master
      if response.body[:consulta_response][:consulta_result][:estado] == "Vigente"
        self.texto_validacion = response.body[:consulta_response][:consulta_result][:codigo_estatus]
        self.status_sat = :validado
        self.save
        #self.validado!
      elsif response.body[:consulta_response][:consulta_result][:estado] == "Cancelado"
        self.texto_validacion = response.body[:consulta_response][:consulta_result][:codigo_estatus]
        self.status_sat = :cancelado
        self.save
      else
        self.texto_validacion = response.body[:consulta_response][:consulta_result][:codigo_estatus]
        self.status_sat = :no_validado
        self.save
        #self.no_valido!
      end
    end
  end

end
