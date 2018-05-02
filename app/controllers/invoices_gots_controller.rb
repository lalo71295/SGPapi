class InvoicesGotsController < ApplicationController
    layout "blanco", only: [:ver_cfdi, :eliminar_cfdi]

    def index
        config_rfcs_receptores  = Config.find_by(parametro: 'rfcs_receptores')
        @receptores             = config_rfcs_receptores.valor.split('|')
        @receptor_seleccionado  = @receptores[0]

        if params[:selMes]
            #@mes_seleccionado = (Date.current.year.to_s + "-" + params[:selMes].to_s + "-01").to_date
            session[:mes_seleccionado]  = (params[:selAnio].to_s + "-" + params[:selMes].to_s + "-01").to_date
            session[:receptor]          = params[:selReceptor]
            session[:facturas]          = InvoicesGot.por_mes(params[:selMes], params[:selAnio].to_s, session[:receptor]).order(:fecha)
        else
            if !session[:mes_seleccionado] or !session[:facturas] or !session[:receptor]
                session[:mes_seleccionado]  = Date.current
                session[:receptor]          = @receptores[0]
                session[:facturas]          = InvoicesGot.por_mes(session[:mes_seleccionado].month.to_s, session[:mes_seleccionado].year.to_s, session[:receptor]).order(:fecha) 
            end
        end
        @mes_seleccionado       = session[:mes_seleccionado]
        @facturas               = session[:facturas]
        @receptor_seleccionado  = session[:receptor]
    end

    def new
        @invoices_gots = InvoicesGot.new
        @config_rfcs_receptores = Config.find_by(parametro: 'rfcs_receptores')
    end

    def create
        #@config_rfcs_receptores = Config.find_by(parametro: 'rfcs_receptores')

        if params[:invoices_got]
            parametros = params[:invoices_got]
            archivos = parametros[:archivoxml]
            arArchivos = Array.new
            archivos.each do |arc|
              File.open(Rails.root.join('archivos', 'buzoncfdi',arc.original_filename), 'wb') do |file|
                file.write(arc.read)
                file_name = 'archivos/buzoncfdi/' + arc.original_filename
                arArchivos << file_name
              end
            end

            invoice_got = InvoicesGot.new
            #resumen = invoice_got.guarda_xml(arArchivos)
            chrespeciales = false
            if params[:chrespeciales]
                chrespeciales = params[:chrespeciales]
            end
            resumen = invoice_got.procesa_xmls(arArchivos,chrespeciales)

            flash[:resumen] = resumen

            respond_to do |format|
              format.html { redirect_to buzon_facturas_path, notice: 'Información sobre el procesamiento' }
            end
        end
        #byebug
    end

    def validar
        @facturas = InvoicesGot.where(status: :capturado).order('fecha DESC')
        @facturas.each do |ig|
            ig.valida_cfdi_status
        end

        respond_to do |format|
            format.html { redirect_to buzon_facturas_path, notice: 'CFDIs validados' }
        end       
    end

    def validar_individual
        factura = InvoicesGot.find_by(uuid: params[:uuid])
        response = factura.valida_cfdi_status
        
        respond_to do |format|
            format.html { redirect_to ver_cfdi_path(params[:uuid]), notice: 'CFDI validado' }
        end       
    end

    def regenerar
        ig = InvoicesGot.new
        ig.regenera_facturas
    end

    def leer_pdf
        @resumen = nil
        if params[:archivopdf]
            archivos = params[:archivopdf]
            if archivos.count > 0
                invoice_got = InvoicesGot.new
                @resumen = invoice_got.procesar_pdfs(params[:archivopdf]) 
            end
        end
        #byebug
    end

    def cargar_pdf
        invoice_got = InvoicesGot.new
        resultado   = invoice_got.cargar_pdf(params[:archivopdf], params[:hiduuid])
        respond_to do |format|
          format.html { redirect_to ver_cfdi_path(params[:hiduuid]), notice: resultado["mensaje"] }
        end
    end

    def ver_pdf
        ig = InvoicesGot.find_by(uuid: params[:uuid])
        send_file(Rails.root.join("archivos","buzoncfdi","pdf","#{ig.pdf}"), :disposition => 'inline', :type => "application/pdf")
    end

    def ver_cfdi
        if params[:solo_vista]
            @solo_vista = true
        end
        @cfdi = InvoicesGot.find_by(uuid: params[:uuid])
    end

    def eliminar_cfdi
        invoice_got = InvoicesGot.new
        resultado   = invoice_got.eliminar_cfdi(params[:uuid])
    end

    def listado_seleccionable
        config_rfcs_receptores  = Config.find_by(parametro: 'rfcs_receptores')
        @receptores             = config_rfcs_receptores.valor.split('|')
        @receptor_seleccionado  = @receptores[0]

        @mes_seleccionado       = (params[:selAnio].to_s + "-" + params[:selMes].to_s + "-01").to_date
        @receptor_seleccionado  = params[:selReceptor]
        @facturas               = InvoicesGot.por_mes(params[:selMes], params[:selAnio].to_s, params[:selReceptor]).order(:fecha)

    end

    private
        def invoices_got_params
          params.require(:invoices_got).permit(:invoices_got=>[], :archivoxml=>[])
        end
end
