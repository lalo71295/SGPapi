class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_select_collections, only: [:edit, :update, :new, :create]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks            = Task.all.includes(:classification, :project, :tasks_employees, :employees).order(created_at: "DESC")
    @tasks_capturadas = Task.all.capturada.order(created_at: "DESC")
    @tasks_asignadas  = Task.joins(:employees).where(status: :asignada).group(:id).order(created_at: "DESC")
  end

  def mis_tareas
    @tasks_to_me = Task.includes(:employees, :classification, :project, :tasks_employees).where("employees.id" => current_user.id, status: :desplegada).order(created_at: "DESC")
    @horas_incurridas = TaskDuration.horas_incurridas(current_user.employee.id)
    #byebug
    puts @horas_incurridas
  end

  def mi_tarea
    task = Task.joins(:employees).where("employees.id" => current_user.id, "id" => params[:id])
    @task = task[0]
    @task_duration = TaskDuration.where(task_id: params[:id], employee_id: current_user.employee.id).order(created_at: "DESC")
  end

  def terminar_mi_tarea
    tarea = Task.find(params[:id])
    mi_tarea = TasksEmployee.find_by(task_id: params[:id], employee_id: current_user.employee_id)
    if tarea.task_durations.size > 0
      mi_tarea.terminada!
      te = TasksEmployee.where("task_id = ? AND status = ?", params[:id], TasksEmployee.statuses[:capturada, :asignada, :trabajando, :suspendida])
      if !te.count > 0
        tarea.terminada!
      end
      redirect_to mis_tareas_path, notice: 'Terminaste la tarea, ¡Excelente!'
    else
      redirect_back fallback_location: mis_tareas_path, alert: 'Añadele tiempo a la tarea antes de terminarla por favor.'
    end
  end

  def dashboard
    @proyectos  = Project.all.includes(:employees_projects_rols, :employees)
  end

  def dashboard_proyecto
    status_sel = "desplegada"
    if params[:status]
      status_sel = params[:status]
    end
    @Project = Project.find(params[:project_id])
    @Tasks = Task.includes(:employees).where(project_id: @Project.id, status: status_sel)
  end

  def detalle_tarea
    task = Task.joins(:employees).where(id: params[:id])
    @task = task[0]
    @task_duration = TaskDuration.includes(:employee).where(task_id: params[:id]).order(created_at: "DESC")
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task           = Task.new
    @tareas         = Task.where(status: :asignada)
    @prioridad_seleccionada = nil
    @clasificacion_seleccionada = nil
  end

  # GET /tasks/1/edit
  def edit
    tarea = Task.find(params[:id])
    @tareas         = Task.where(status: :asignada).where.not(id: params[:id])
    @prioridad_seleccionada = tarea.prioridad
    @clasificacion_seleccionada = tarea.classification.nombre

    if tarea.cancelada?
      @task_duration = TaskDuration.where(task_id: params[:id], employee_id: current_user.employee.id).order(created_at: "DESC")
    end

    i=0
    @employees.each do |emp|
      tarea.employees.each do |empleado|
        if emp.id == empleado.id
          @employees[i].seleccionado = true
        end
      end
      i+=1  
    end
  end

  # POST /tasks
  # POST /tasks.json
  def create
    if params[:chkTarea]
      if params[:chkTarea] != "-1"
        params[:task][:tarea_padre] = params[:chkTarea]
      else
        params[:task][:tarea_padre] = nil
      end
    end

    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        
        if params[:empleado]
          empleados = params[:empleado]
          asignada = false

          empleados.each do |empleado|
            task_employee = TasksEmployee.new
            task_employee.task_id     = @task.id
            task_employee.employee_id = empleado
            if task_employee.save
              asignada = true 
            end
          end

          if asignada
            @task.asignada!
          end
        end

        format.html { redirect_to tasks_path, notice: 'Tarea creada y asignada correctamente' }
        format.json { render :show, status: :created, location: tasks_path }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
      begin
        respond_to do |format|
          if params[:chkTarea]
            if params[:chkTarea] != "-1"
              params[:task][:tarea_padre] = params[:chkTarea]
            else
              params[:task][:tarea_padre] = nil
            end
          end

          if params[:chkFechaCompromiso]
            fecha = DateTime.new(params[:date][:year].to_i, 
                        params[:date][:month].to_i,
                        params[:date][:day].to_i,
                        params[:date][:hour].to_i,
                        params[:date][:minute].to_i) 
            params[:task][:fecha_compromiso] = fecha
          else
            params[:task][:fecha_compromiso] = nil
          end

          if @task.capturada? || @task.asignada?
            TasksEmployee.where(task_id: @task.id).destroy_all
            
            if params[:empleado]
                empleados = params[:empleado]
                asignada = false

                empleados.each do |empleado|
                  task_employee = TasksEmployee.new
                  task_employee.task_id     = @task.id
                  task_employee.employee_id = empleado
                  if task_employee.save
                    asignada = true 
                  end
                end

                if @task.capturada?
                  if asignada
                    @task.status = :asignada
                  else
                    @task.status = :capturada         
                  end
                end
            else
              if @task.asignada?
                @task.status = :capturada
              end
            #  raise ActiveRecord::Rollback, "No se puede eliminar la asignación"
            end
          end

          if !params[:chkCancelar]
            params[:task][:motivo_cancelacion] = nil
          else
            @task.status = :cancelada
          end

          if @task.update(task_params)
            format.html { redirect_to tasks_path, notice: 'Tarea actualizada correctamente' }
            format.json { render :show, status: :ok, location: tasks_path }
          else
            format.html { render :edit }
            format.json { render json: @task.errors, status: :unprocessable_entity }
          end
        end
      rescue Exception => ex 
        redirect_to tasks_path, notice: 'No se actualizó, hubo un problema al actualizar la tarea'
        logger.debug ex
      end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def asignar_tiempo
    task_duration = TaskDuration.new
    tiempo = 0
    if params[:tipo_tiempo] == 'horas'
      tiempo = params[:tiempo].to_i * 60
    else
      tiempo = params[:tiempo].to_i
    end

    fecha = DateTime.new(params[:date][:year].to_i, 
                        params[:date][:month].to_i,
                        params[:date][:day].to_i,
                        params[:date][:hour].to_i,
                        params[:date][:minute].to_i)

    task_duration.minutos = tiempo
    task_duration.fecha = fecha
    task_duration.retro = params[:retro]
    task_duration.employee_id = current_user.employee.id
    task_duration.task_id = params[:task_id]
    task_duration.save
    @task_duration = TaskDuration.where(task_id: params[:task_id], employee_id: current_user.employee.id).order(created_at: "DESC")
  end

  def eliminar_tiempo
    TaskDuration.find(params[:id]).destroy
    @task_duration = TaskDuration.where(task_id: params[:task_id], employee_id: current_user.employee.id).order(created_at: "DESC")
  end

  def desplegar_tareas
    Task.where(status: :asignada).update_all(status: :desplegada)
    #Aquí va a ir el envío de correo
    redirect_to tasks_path, notice: 'Las tareas fueron desplegadas correctamente'
  end

  def desplegar_tarea
    tarea = Task.find_by(status: :asignada, id: params[:id])
    notice = ''
    if tarea.desplegada!
      notice = "La tarea '#{tarea.asunto}' fue desplegada correctamente"
    else
      notice = "Error al desplegar la tarea '#{tarea.asunto}'"
    end
    #Aquí va a ir el envío de correo
    if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back, notice: notice
    else
      redirect_to tasks_path, notice: notice
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:asunto, :descripcion, :fecha, :status, :prioridad, :folio_alterno, :classification_id, :project_id, :asignador_id, :tarea_padre, :fecha_compromiso, :motivo_cancelacion)
    end

    def set_select_collections
      @proyectos      = Project.all
      @classification = Classification.all
      @employees      = Employee.all
    end
end
