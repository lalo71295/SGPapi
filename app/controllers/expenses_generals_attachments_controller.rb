class ExpensesGeneralsAttachmentsController < ApplicationController
  before_action :find_attachment, only: :download

  def index
    @expense              = ExpensesGeneral.find(params[:expense])
    @expenses_attachment  = ExpensesGeneralsAttachment.new
    @expenses_attachments = ExpensesGeneralsAttachment.where(expenses_general_id: @expense.id)
    if !@expenses_attachment.tipo
      @expenses_attachment.tipo = 0
    end
    @cfdi = @expense.invoices_got

    flash[:periodo_seleccionado] = @expense.period_id
  end

  def create
    archivo_attachment    = ''
    validado              = false
    complemento_notice    = ''
    expense               = params[:expense]
    tipo                  = params[:expenses_generals_attachment][:tipo]
    archivo               = params[:expenses_generals_attachment][:archivo]
    params[:expenses_generals_attachment][:expenses_general_id] = expense

    @expense_attachment   = ExpensesGeneralsAttachment.new(expenses_generals_attachment_params)

    #Llamada al procesamiento del archivo, regresará 3 datos: validado?, nombre_archivo, mensaje
    if tipo == 'otro'
      validado = true
    elsif tipo == 'xml_de_factura'
      res_procesar_archivo = @expense_attachment.procesar_archivo(tipo, archivo, expense)
      validado = res_procesar_archivo["validado"]
      #archivo_attachment = res_procesar_archivo["nombre_archivo"]
      complemento_notice = res_procesar_archivo["mensaje"]
    elsif tipo == 'pdf_de_factura'
      res_procesar_archivo = @expense_attachment.procesar_archivo(tipo, archivo, expense)
      validado = res_procesar_archivo["validado"]
      #archivo_attachment = res_procesar_archivo["nombre_archivo"]
      complemento_notice = res_procesar_archivo["mensaje"]
    end

    if validado 
      @expense_attachment.expenses_general = expense

      respond_to do |format|
        if @expense_attachment.save
          #redirect_to thing_path(@thing, foo: params[:foo])
          format.html { redirect_to expenses_generals_attachments_path(expense), notice: 'Archivo guardado correctamente.' + complemento_notice }
          #format.json { render :show, status: :created, location: @expense }
        else
          format.html { redirect_to expenses_generals_attachments_path(expense), notice: 'No fue posible subir el archivo.' + complemento_notice }
          #format.json { render json: @expenses.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to expenses_generals_attachments_path(expense), notice: 'Error al subir archivo' + (complemento_notice ? complemento_notice : '')
    end
  end

  def download
    send_file(Rails.root.join("archivos","viaticos","#{@expense}",@expenses_generals_attachment.archivo_file_name))
  end

  def destroy
    notice = ''
    begin
      ExpensesGeneralsAttachment.transaction do
        @expense_attachment = ExpensesGeneralsAttachment.find(params[:id])
        if @expense_attachment.xml_de_factura?
          expense = ExpensesGeneral.find(@expense_attachment.expenses_general_id)
          invoices_got = InvoicesGot.find(expense.invoices_gots_id)

          expense.invoices_gots_id = nil
          expense.save

          if invoices_got
            if invoices_got.pdf
              path_pdf = 'archivos/buzoncfdi/pdf/' + invoices_got.pdf
              File.delete(path_pdf) if File.exist?(path_pdf)
            end
            invoices_got.destroy
          end
        end

        if @expense_attachment.pdf_de_factura?
          expense = ExpensesGeneral.find(@expense_attachment.expenses_general_id)
          invoices_got = InvoicesGot.find(expense.invoices_gots_id)
          if invoices_got
            if invoices_got.pdf
              path_pdf = 'archivos/buzoncfdi/pdf/' + invoices_got.pdf
              File.delete(path_pdf) if File.exist?(path_pdf)
              invoices_got.pdf = nil
              invoices_got.save
            end
          end          
        end

        @expense_attachment.archivo = nil 
        @expense_attachment.save
        @expense_attachment.destroy
        notice = "Archivo eliminado correctamente"
      end
    rescue Exception => ex
      notice = "Error al eliminar archivo: #{ex}"
    end

    respond_to do |format|
      format.html { redirect_to expenses_generals_attachments_path(params[:expense]), notice:  notice }
      format.json { head :no_content }
    end
  end

  def expenses_generals_attachment_params
    params.require(:expenses_generals_attachment).permit(:expenses_general_id, :archivo, :descripcion, :tipo)
  end

  private
    def find_attachment
      @expense = params[:expense]
      @expenses_generals_attachment = ExpensesGeneralsAttachment.find(params[:id])
    end

end
