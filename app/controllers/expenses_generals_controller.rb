class ExpensesGeneralsController < ApplicationController

  def index
    @periodos   = Period.periodosAnualCombo 
    empleado    = current_user.employee.id

    if params[:periods]
      @periodoSel = params[:periods][:period_id]
    else
      @periodoSel = @periodos.first.id
    end

    if flash[:periodo_seleccionado]
       @periodoSel = flash[:periodo_seleccionado]    
    end

    @ppe = nil
    if @periodoSel
      @expensesGeneral = ExpensesGeneral.includes(:project).includes(:concept).includes(:invoices_got).includes(:expenses_employees_generals).includes(:employees).where(period_id: @periodoSel)#@periodoSel) #find_by(period_id: @periodoSel)#, employee_id: empleado)
    end
    @hou = nil
    if @ppe
      @hou = Hour.select(:project_id).distinct.where("hours.periods_projects_employee_id"=>@ppe.id)

    end
  end

  #Reporte por empleado
  def reporte_empleado
    @employees 	= Employee.all
    @periodos 	= ExpensesGeneral.select(:period_id).distinct

    if params[:period]
      @periodo 	= params[:period][:period_id]
      @empleado = params[:employee][:employee_id]
    else
      @periodo 	= ExpensesGeneral.select(:period_id).first
      @empleado = @employees.first.id
    end

    if @periodo
      @reporte_empleado 	= ExpensesGeneral.includes(:project).includes(:concept).includes(:period).joins(:expenses_employees_generals).where("expenses_generals.period_id" => @periodo, "expenses_employees_generals.employee_id"=> @empleado)
      @nombreEmpleado 		= Employee.where("id" => @empleado)
      @periodoSeleccionado 	= Period.where("id" => @periodo)
    end
  end

  #Reporte por proyecto
  def reporte_proyecto
      @periodos 	= ExpensesGeneral.select(:period_id).distinct
      @proyectos 	= ExpensesGeneral.select(:project_id).distinct

      if params[:period]
        @periodo 	= params[:period][:period_id]
        @proyecto 	= params[:project][:project_id]
      else
        @periodo 	= ExpensesGeneral.select(:period_id).first
        @proyecto 	= ExpensesGeneral.select(:project_id).first
      end

      if @periodo
        @reporte_proyecto 		= ExpensesGeneral.includes(:project).includes(:concept).includes(:period).joins(:expenses_employees_generals).where("expenses_generals.period_id" => @periodo, "expenses_generals.project_id"=> @proyecto)
        @periodoSeleccionado 	= Period.where("id" => @periodo)
        @proyectoSeleccionado 	= Project.where("id" => @proyecto)
      end
  end 

  #Reporte por concepto
  def reporte_concepto
      @conceptos 	= ExpensesGeneral.select(:concept_id).distinct
      @periodos 	= ExpensesGeneral.select(:period_id).distinct

      if params[:concept]
        @concepto 	= params[:concept][:concept_id]
        @periodo 	=  params[:period][:period_id]
      else
        @concepto = -1
      end

      if @concepto
        @reporte_concepto 		= ExpensesGeneral.where("concept_id" => @concepto, "period_id" => @periodo)
        @nombre_concepto		= Concept.where("id" => @concepto)
        @periodo_seleccionado 	= Period.where("id" => @periodo)
      end 
  end

  #Nuevo Viatico
  def new
    @periodos         = Period.periodosAnualCombo
    @expense_general  = ExpensesGeneral.new
    @conceptos        = Concept.where(clasificacion: 1)
    @proyectos        = Project.joins(projects_rols: [:employees_projects_rols]).where("employees_projects_rols.employee_id" => current_user.employee_id).group("id")
    @employees        = Employee.all
    @facturas         = InvoicesGot.order(:folio)
  end

  #Guardar viatico
  def create
    ExpensesGeneral.transaction do
      periodo     = params[:expenses_general][:period_id]
      @expense_general    = ExpensesGeneral.new(expenses_generals_params)      
      period_id   = periodo
      periodoProc = [period_id]
      @empls = params[:empleado].try(:length)

      respond_to do |format|

        if (@expense_general.valid?) && (@empls != nil) && (@empls != 0) 
          @expense_general.save

          if params[:empleado]
            empleados = params[:empleado]
            empleados.each do |e|
              @ee = ExpensesEmployeesGeneral.new(expenses_general_id: @expense_general.id, employee_id: e)
              @ee.save
            end
          end
          format.html { redirect_to expenses_generals_path, periods: periodoProc, notice: 'Viático guardado correctamente.' }
        else  
          if (@empls == nil) || (@empls == 0)
            @error_empleado = 'Debes agregar empleados'
          end   

          @conceptos  = Concept.where(clasificacion: 1)
          @proyectos  = Project.joins(projects_rols: [:employees_projects_rols]).where("employees_projects_rols.employee_id" => current_user.employee_id).group("id")
          @employees  = Employee.all
          @periodos   = Period.periodosAnualCombo
          @facturas         = InvoicesGot.order(:folio)
          format.html { render :new } 
          format.json { render json: @expense_general.errors, status: :unprocessable_entity }
        end
      end
    end #Fin de la transacción
  end


  #Editar Viatico
  def edit
    @periodos         = Period.periodosAnualCombo
    @conceptos        = Concept.where(clasificacion: 1)
    @proyectos        = Project.joins(projects_rols: [:employees_projects_rols]).where("employees_projects_rols.employee_id" => current_user.employee_id).group("id")
    @expense_general  = ExpensesGeneral.find(params[:id])
    @employees        = Employee.all
    @facturas         = InvoicesGot.all

    i=0
    @employees.each do |emp|
      @expense_general.employees.each do |empleado|
        if emp.id == empleado.id
          @employees[i].seleccionado = true
        end
      end
      i+=1  
    end
  end

  #Actualiza el viatico
  def update
    @expense_general = ExpensesGeneral.find(params[:id])
    ExpensesEmployeesGeneral.where(expenses_general_id: @expense_general.id).destroy_all
    prorrateable = params[:expenses_general][:prorrateable]


      if params[:empleado]
        empleados = params[:empleado]
        empleados.each do |empleado|
          ee = ExpensesEmployeesGeneral.new(expenses_general_id: @expense_general.id, employee_id: empleado)
          ee.save
        end
      else
        @expense_general.prorrateable = false
      end
    else
      @expense_general.prorrateable = false

    @empls = params[:empleado].try(:length)
    
    respond_to do |format|
      if (@expense_general.valid?) && (@empls != nil) && (@empls != 0) 
        @expense_general.update(expenses_generals_params)
        flash[:periodo_seleccionado] = params[:periodo_seleccionado]
        format.html { redirect_to expenses_generals_path, notice: 'Viático correctamente actualizado.' }
        format.json { render :show, status: :ok, location: expenses_generals_path }
      else
        if (@empls == nil) || (@empls == 0)
          @error_empleado = 'Debes agregar empleados'
        end
          @conceptos  = Concept.where(clasificacion: 1)
          @proyectos  = Project.joins(projects_rols: [:employees_projects_rols]).where("employees_projects_rols.employee_id" => current_user.employee_id).group("id")
          @employees  = Employee.all
          @periodos   = Period.periodosAnualCombo
          @facturas         = InvoicesGot.order(:folio)
          format.html { render :new } 
          format.json { render json: @expense_general.errors, status: :unprocessable_entity }
       
      end
    end
  end

  #Eliminar viatico
  def destroy
      @expense_general = ExpensesGeneral.find(params[:id])
      ExpensesEmployeesGeneral.where(expenses_general_id: @expense_general.id).destroy_all      
      @expense_general.destroy
  
      respond_to do |format|
        format.html { redirect_to expenses_generals_path, notice: 'Viático eliminado correctamente.' }
        format.json { head :no_content }
      end
  end

  #Autorizacion de viatico
  def autorizacion
    eh = ExpensesGeneral.find(params[:eh])
    eh.autorizando!
    flash[:periodo_seleccionado] = eh.period_id
    redirect_to expenses_generals_path, notice: 'Viáticos enviados a autorización.'
  end

  #Listado de autorizaciones
  def listadoAutorizacion
    @periodoSel     = "mes1"
    @soloPendientes = false
    if params[:selPeriodo]
      @periodoSel = params[:selPeriodo]
      if params[:chkPendientes]
        @soloPendientes = true
      end
    end

    @opciones = {"Mes Actual" => "mes1", "Ultimos 2 meses" => "mes2", "Ultimos 3 meses" => "mes3",
                 "Este Año" => "anio1", "Ultimos 2 años" => "anio2"}
    @periodos = Period.periodosPorRango(@periodoSel).joins(:expenses_generals).where("expenses_generals.status = 1 or expenses_generals.status = 2")#,  ExpensesGeneral.statuses["autorizando"])#.distinct
  end

  #Se autoriza el viatico
  def autorizarExpenses
    eh = ExpensesGeneral.find(params[:expenses_general])
    eh.autorizados!
    eh.fecha_autorizacion = Date.today
    eh.usuario_autorizo = current_user.id
    eh.save
    redirect_to listado_autorizacion_expeses_general_path, notice: 'Viáticos autorizados.'
  end

  #Se regresa a status de captura el viatico
  def regresarCaptura
    eh = ExpensesGeneral.find(params[:expenses_general])
    eh.comentarios_header = params[:txtRegCaptura]
    eh.captura!
    redirect_to listado_autorizacion_expeses_general_path, notice: 'Viáticos regresados a captura.'
  end


  #Reembolsos administrativos
  def reembolsos_administrativos
    @employees = Employee.includes(expenses_generals: [:expenses_employees_generals]).joins(expenses_generals:[:expenses_employees_generals]).where("expenses_generals.status in (?) AND expenses_generals.rembolsado IS NULL", [ExpensesGeneral.statuses["autorizados"], ExpensesGeneral.statuses["pagados_parcialmente"]])
    
  end 

  #Reembolsar viatico administrtivo
  def reembolso_administrativo
    @empleado = Employee.find(params[:empleado])
    @expenses_general = ExpensesGeneral.where(id: params[:rembolsos], rembolsado: nil)
  end


  #Aplicar reembolso administrativo
  def aplicar_reembolso_administrativo
    expenses_general = ExpensesGeneral.where(id: params[:expenses_selecccionados], rembolsado: nil)
    eh_id = expenses_general.first.id
    ExpensesGeneral.where(id: 10, rembolsado: nil)
    @reembolso = Refund.new(rembolso_params)

    fecha = DateTime.new(params[:date][:year].to_i, 
                      params[:date][:month].to_i,
                      params[:date][:day].to_i)

    @reembolso.fecha 	= fecha
    @reembolso.usuult 	= current_user.id

    respond_to do |format|
      if @reembolso.save 
        expenses_general.update_all(refund_id: @reembolso.id, rembolsado: true, fecha_rembolso: Date.current, usuult: current_user.id)
        eh = ExpensesGeneral.find(eh_id)
        eh.pagados!
        
        format.html { redirect_to reembolsos_administrativos_path, notice: 'Se aplicó el reembolso correctamente!' }
      else 
        format.html { redirect_to reembolsos_administrativos_path, locals: {empleado: params[:refund][:employee_id], rembolsos: params[:expenses_selecccionados]} }
      end
    end
  end

  #Reembolos administrativos pagados
  def reembolsos_administrativos_pagados
    @expenses_generals = ExpensesGeneral.joins(:refund)
  end


  def download_rembolso
    empleado = params[:empleado]
    rembolso = Refund.find(params[:id])
    send_file(Rails.root.join("archivos","reembolsos","#{empleado}", rembolso.archivo_file_name))
  end

  def mis_reembolsos
    #@employee = Employee.find(current_user.employee_id).includes(refunds: [:expenses]).joins(:refunds)
    @empleado = current_user.employee
    @reembolsos = @empleado.refunds.mes(3)
  end

  def reembolso_pagado
    if params[:refund] && params[:refund][:archivo]
      @refund = Refund.find(params[:id])
      if @refund.update(rembolso_params)
        redirect_to reembolso_pagado_path(params[:id]), notice: 'Archivo actualizado'
      else
        redirect_to reembolso_pagado_path(params[:id]), alert: 'No se actualizó el archivo'
      end
    end
    @rembolso = Refund.find(params[:id])
    @empleado = Employee.find(@rembolso.employee_id)
  end

  def expenses_generals_params
    params.require(:expenses_general).permit(:project_id, :concept_id, :fecha, :monto, :comentarios, :facturable, :rembolsable, :prorrateable, :usuult, :period_id, :status, :comentarios_header, :invoices_gots_id, :usuario_autorizo)

  end

  def rembolso_params
    params.require(:refund).permit(:monto, :fecha, :forma_de_pago, :cuenta_origen, :cuenta_destino, :archivo, :employee_id, :usuult)
  end
end





