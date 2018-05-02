class EmployeesProjectsRolsController < ApplicationController
  before_action :set_employees_projects_rol, only: [:show, :edit, :update, :destroy]

  # GET /employees_projects_rols
  # GET /employees_projects_rols.json
  def index
    @employees_projects_rols = EmployeesProjectsRol.all
  end

  # GET /employees_projects_rols/1
  # GET /employees_projects_rols/1.json
  def show
  end

  # GET /employees_projects_rols/new
  def new
    @employees_projects_rol = EmployeesProjectsRol.new
  end

  # GET /employees_projects_rols/1/edit
  def edit
  end

  # POST /employees_projects_rols
  # POST /employees_projects_rols.json
  def create
    @employees_projects_rol = EmployeesProjectsRol.new(employees_projects_rol_params)

    respond_to do |format|
      if @employees_projects_rol.save
        format.html { redirect_to @employees_projects_rol, notice: 'Employees projects rol was successfully created.' }
        format.json { render :show, status: :created, location: @employees_projects_rol }
      else
        format.html { render :new }
        format.json { render json: @employees_projects_rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees_projects_rols/1
  # PATCH/PUT /employees_projects_rols/1.json
  def update
    respond_to do |format|
      if @employees_projects_rol.update(employees_projects_rol_params)
        format.html { redirect_to @employees_projects_rol, notice: 'Employees projects rol was successfully updated.' }
        format.json { render :show, status: :ok, location: @employees_projects_rol }
      else
        format.html { render :edit }
        format.json { render json: @employees_projects_rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees_projects_rols/1
  # DELETE /employees_projects_rols/1.json
  def destroy
    @employees_projects_rol.destroy
    respond_to do |format|
      format.html { redirect_to employees_projects_rols_url, notice: 'Employees projects rol was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employees_projects_rol
      @employees_projects_rol = EmployeesProjectsRol.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employees_projects_rol_params
      params.require(:employees_projects_rol).permit(:employee_id, :projects_rol_id)
    end
end
