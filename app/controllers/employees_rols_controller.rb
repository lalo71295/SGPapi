class EmployeesRolsController < ApplicationController
  before_action :set_employees_rol, only: [:show, :edit, :update, :destroy]

  # GET /employees_rols
  # GET /employees_rols.json
  def index
    @employees_rols = EmployeesRol.all
  end

  # GET /employees_rols/1
  # GET /employees_rols/1.json
  def show
  end

  # GET /employees_rols/new
  def new
    @employees_rol = EmployeesRol.new
  end

  # GET /employees_rols/1/edit
  def edit
  end

  # POST /employees_rols
  # POST /employees_rols.json
  def create
    @employees_rol = EmployeesRol.new(employees_rol_params)

    respond_to do |format|
      if @employees_rol.save
        format.html { redirect_to @employees_rol, notice: 'Employees rol was successfully created.' }
        format.json { render :show, status: :created, location: @employees_rol }
      else
        format.html { render :new }
        format.json { render json: @employees_rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees_rols/1
  # PATCH/PUT /employees_rols/1.json
  def update
    respond_to do |format|
      if @employees_rol.update(employees_rol_params)
        format.html { redirect_to @employees_rol, notice: 'Employees rol was successfully updated.' }
        format.json { render :show, status: :ok, location: @employees_rol }
      else
        format.html { render :edit }
        format.json { render json: @employees_rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees_rols/1
  # DELETE /employees_rols/1.json
  def destroy
    @employees_rol.destroy
    respond_to do |format|
      format.html { redirect_to employees_rols_url, notice: 'Employees rol was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employees_rol
      @employees_rol = EmployeesRol.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employees_rol_params
      params.require(:employees_rol).permit(:employee_id, :rol_id)
    end
end
