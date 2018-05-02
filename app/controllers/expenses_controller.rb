class ExpensesController < ApplicationController

  def index
    @periodos = Period.periodosAnualCombo #Period.where(anio: 2016).order(:fecha_inicio)
    empleado    = current_user.employee.id
    #byebug

    if params[:periods]
      @periodoSel = params[:periods][:period_id]
    else
      @periodoSel = @periodos.last.id
    end

    if flash[:periodo_seleccionado]
<<<<<<< HEAD
       @periodoSel = flash[:periodo_seleccionado]    
=======
       @periodoSel = flash[:periodo_seleccionado]
>>>>>>> master
    end

    @ppe = nil
    if @periodoSel
      @expensesHeader = ExpensesHeader.find_by(period_id: @periodoSel, employee_id: empleado)
      @expenses = nil
      @expenses = @expensesHeader.expenses if @expensesHeader
    end
    @hou = nil
    if @ppe
      @hou = Hour.select(:project_id).distinct.where("hours.periods_projects_employee_id"=>@ppe.id)
    end

  end

  def new
    @periodos   = Period.periodosAnualCombo
    @expense    = Expense.new
    @conceptos  = Concept.where(clasificacion: 1)
    @proyectos  = Project.joins(projects_rols: [:employees_projects_rols]).where("employees_projects_rols.employee_id" => current_user.employee_id).group("id")
    @employees  = Employee.all
<<<<<<< HEAD
=======
    @periodoSel = @periodos.last.id
    @empleados_seleccionados = [current_user.employee.id]
>>>>>>> master
    #byebug
  end

  def create
    Expense.transaction do
      periodo     = params[:expense][:period_id]
      empleado    = current_user.employee.id
      proyecto    = params[:expense][:project_id]
      comentarios = params[:expense][:comentarios]

      @eh = ExpensesHeader.find_by(employee_id: empleado, period_id: periodo)
      if !@eh
        @eh = ExpensesHeader.new(employee_id: empleado, period_id: periodo)
        @eh.save
      end
      params[:expense][:expenses_header_id] = @eh.id
      params[:expense][:project_id]         = proyecto

<<<<<<< HEAD
=======
      arempleado = params[:empleado]

      if arempleado.count > 1
        params[:expense][:prorrateable] = true
      end

>>>>>>> master
      @expense    = Expense.new(expenses_params)

      period_id   = periodo
      periodoProc = [period_id]

      respond_to do |format|
        if @expense.save
<<<<<<< HEAD
          if @expense.prorrateable?
            if params[:empleado]
              empleados = params[:empleado]
              empleados.each do |empleado|
                @ee = ExpensesEmployee.new(expense_id: @expense.id, employee_id: empleado)
                @ee.save
              end
            else
              @expense.update(prorrateable: false)
            end
          end
=======

          #if arempleado.count > 1
            arempleado.each do |empleado|
              @ee = ExpensesEmployee.new(expense_id: @expense.id, employee_id: empleado)
              @ee.save
            end
          #end
>>>>>>> master

          #redirect_to thing_path(@thing, foo: params[:foo])
          format.html { redirect_to expenses_path, periods: periodoProc, notice: 'Viatico guardado correctamente.' }
          #format.json { render :show, status: :created, location: @expense }
        else
          format.html { render :new }
          #format.json { render json: @expenses.errors, status: :unprocessable_entity }
        end
      end
    end #Fin de la transacción
  end

  def edit
<<<<<<< HEAD
    @periodos = Period.periodosAnualCombo
    @conceptos = Concept.where(clasificacion: 1)
    @proyectos  = Project.joins(projects_rols: [:employees_projects_rols]).where("employees_projects_rols.employee_id" => current_user.employee_id).group("id")
    @expense = Expense.find(params[:id])
    @employees  = Employee.all

=======
    @periodos               = Period.periodosAnualCombo
    @conceptos              = Concept.con_clasificacion_empleados
    @proyectos              = Project.del_empleado(current_user.employee_id)
    @expense                = Expense.especifico(params[:id])
    @employees              = Employee.all
    @proyecto_seleccionado  = @expense.project_id
    @concepto_seleccionado  = @expense.concept_id

    @empleados_seleccionados = Array.new
>>>>>>> master
    i=0
    @employees.each do |emp|
      @expense.employees.each do |empleado|
        if emp.id == empleado.id
          @employees[i].seleccionado = true
<<<<<<< HEAD
        end
      end
      i+=1  
    end

=======
          @empleados_seleccionados[i] = empleado.id
        end
      end
      i+=1
    end
    #byebug
>>>>>>> master
  end

  def update
    @expense = Expense.find(params[:id])

    ExpensesEmployee.where(expense_id: @expense.id).destroy_all

<<<<<<< HEAD
    prorrateable = params[:expense][:prorrateable]

    if prorrateable && prorrateable.to_i > 0
      if params[:empleado]
        empleados = params[:empleado]
        empleados.each do |empleado|
          ee = ExpensesEmployee.new(expense_id: @expense.id, employee_id: empleado)
          ee.save
        end
      else
        @expense.prorrateable = false
      end
    else
      @expense.prorrateable = false
=======
    arempleado = params[:empleado]

    if arempleado.count > 1
      params[:expense][:prorrateable] = true
    else
      params[:expense][:prorrateable] = false
    end

    arempleado.each do |empleado|
      ee = ExpensesEmployee.new(expense_id: @expense.id, employee_id: empleado)
      ee.save
>>>>>>> master
    end

    respond_to do |format|
      if @expense.update(expenses_params)
        flash[:periodo_seleccionado] = params[:periodo_seleccionado]
        format.html { redirect_to expenses_path, notice: 'Viático correctamente actualizado.' }
        format.json { render :show, status: :ok, location: expenses_path }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
<<<<<<< HEAD
    
=======

>>>>>>> master
      @expense = Expense.find(params[:id])
      ExpensesEmployee.where(expense_id: @expense.id).destroy_all
      ExpensesAttachment.where(expense_id: @expense.id).destroy_all

      @expense.destroy
<<<<<<< HEAD
  
=======

>>>>>>> master
      respond_to do |format|
        format.html { redirect_to expenses_path, notice: 'Viático eliminado correctamente.' }
        format.json { head :no_content }
      end
  end

  def autorizacion
    eh = ExpensesHeader.find(params[:eh])
    eh.autorizando!
    flash[:periodo_seleccionado] = eh.period_id
    redirect_to expenses_path, notice: 'Viáticos enviados a autorización.'
  end

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

    #@periodos = Period.periodosPorRango(@periodoSel)
    #@eh = Period.periodosPorRango(@periodoSel).joins(expenses_headers: [:employee, :expenses]).group("expenses_headers.employee_id")
    #@eh = Period.where(id: 41).includes(expenses_headers: [:employee, :expenses])
    @periodos = Period.periodosPorRango(@periodoSel).joins(:expenses_headers).where("expenses_headers.status = ?",  ExpensesHeader.statuses["autorizando"]).distinct
<<<<<<< HEAD
    
=======

>>>>>>> master
    #if @soloPendientes
      #@expensesHeaders = ExpensesHeader.where(period_id: @periodos.ids, status: :autorizando).includes(:employee)
    #else
    #  @expensesHeaders = ExpensesHeader.where(period_id: @periodos.ids).includes(:employee)
    #end
    #@expenses = Expense.where(expenses_header_id: @expensesHeaders.ids).includes(:project, :concept, :expenses_attachments)
    #byebug
  end

  def autorizarExpenses
    eh = ExpensesHeader.find(params[:expenses_header])
    eh.autorizados!
    redirect_to listado_autorizacion_expeses_path, notice: 'Viáticos autorizados.'
  end

  def regresaraCaptura
    eh = ExpensesHeader.find(params[:expenses_header])
    eh.comentarios = params[:txtRegCaptura]
    eh.captura!
    redirect_to listado_autorizacion_expeses_path, notice: 'Viáticos regresados a captura.'
  end

  def reembolsos
    @employees = Employee.includes(expenses_headers: [expenses: [:expenses_attachments]]).joins(expenses_headers: [:expenses]).where("expenses_headers.status in (?) AND expenses.rembolsado IS NULL", [ExpensesHeader.statuses["autorizados"], ExpensesHeader.statuses["pagados_parcialmente"]])
    #byebug
  end

  def reembolso
    @empleado = Employee.find(params[:empleado])
    @expenses = Expense.where(id: params[:rembolsos], rembolsado: nil)
  end

  def aplicar_reembolso
    expenses = Expense.where(id: params[:expenses_selecccionados], rembolsado: nil)
    eh_id = expenses.first.expenses_header_id
    Expense.where(id: 10, rembolsado: nil)
    @reembolso = Refund.new(rembolso_params)

<<<<<<< HEAD
    fecha = DateTime.new(params[:date][:year].to_i, 
=======
    fecha = DateTime.new(params[:date][:year].to_i,
>>>>>>> master
                      params[:date][:month].to_i,
                      params[:date][:day].to_i)
    @reembolso.fecha = fecha
    @reembolso.usuult = current_user.id

    respond_to do |format|
<<<<<<< HEAD
      if @reembolso.save 
=======
      if @reembolso.save
>>>>>>> master
        expenses.update_all(refund_id: @reembolso.id, rembolsado: true, fecha_rembolso: Date.current, usuult: current_user.id)
        eh = ExpensesHeader.find(eh_id)
        eh.pagados_parcialmente!
        eh.verifica_pagados
        format.html { redirect_to reembolsos_path, notice: 'Se aplicó el reembolso correctamente!' }
<<<<<<< HEAD
      else 
=======
      else
>>>>>>> master
        format.html { redirect_to reembolsos_path, locals: {empleado: params[:refund][:employee_id], rembolsos: params[:expenses_selecccionados]} }
      end
    end
  end

  def reembolsos_pagados
    @employees = Employee.all.includes(refunds: [:expenses]).joins(:refunds)
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

  def expenses_params
    params.require(:expense).permit(:expenses_header_id, :project_id, :concept_id, :fecha, :monto, :comentarios, :facturable, :rembolsable, :prorrateable, :usuult)
  end

  def rembolso_params
    params.require(:refund).permit(:monto, :fecha, :forma_de_pago, :cuenta_origen, :cuenta_destino, :archivo, :employee_id, :usuult)
  end
end
<<<<<<< HEAD





=======
>>>>>>> master
