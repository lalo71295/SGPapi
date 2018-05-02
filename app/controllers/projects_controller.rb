class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @projectsRols = ProjectsRol.where(project_id: params[:id]) or nil
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def asignar_empleado
    if params[:epr]
      empleado = params[:epr][:employee_id]
      rol      = params[:epr][:rol_id]
      proyecto = params[:project]
      @pr   = ProjectsRol.find_by(project_id: proyecto, rol_id: rol)
      @epr  = EmployeesProjectsRol.new(employee_id: empleado, projects_rol_id: @pr.id)
      respond_to do |format|
        if @epr.save
          format.html { redirect_to project_path(proyecto), notice: 'El empleado fue asignado a este proyecto' }
        end
      end
    end
    @empleados  = Employee.where(status: true)
    @proyecto   = Project.find(params[:project])
    @roles      = @proyecto.rols
  end

  def elimina_asignar_empleado
    @epr = EmployeesProjectsRol.find_by(employee_id: params[:empleado], projects_rol_id: params[:pr])
    @epr.destroy
    respond_to do |format|
      format.html { redirect_to project_path(params[:project]), notice: 'Eliminaste al empleado del proyecto' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:clave, :nombre, :descripcion, :fecha_inicio, :fecha_fin, :company_id, :presupuesto_ingresos, :presupuesto_egresos)
    end
end
