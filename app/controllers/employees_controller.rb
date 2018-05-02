class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy] 

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.all
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
    @employee = Employee.find(params[:id])
    if @employee.user_id
      @usuario = User.find(@employee.user_id)
    else
      @usuario = User.new
    end
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_update_user
    @employee = Employee.find(params[:employee])
    if !@employee.user_id

      usuario = User.create_new_user(params[:user][:email], params[:user][:password], params[:employee], params[:user][:approved])

      if usuario
        @employee.user_id = usuario.id
        @employee.save
        redirect_to edit_employee_path(params[:employee]), notice: "Se guardó correctamente el usuario"
      else
        redirect_to edit_employee_path(params[:employee]), notice: "No se guardó el usuario"
      end
    else
      usuario = User.find(@employee.user_id)
      pass = params[:user][:password]
      if !pass.blank?
        usuario.password = params[:user][:password]
      end
      usuario.email = params[:user][:email]
      usuario.approved = params[:user][:approved]
      us = usuario.save

      if us
        redirect_to edit_employee_path(params[:employee]), notice: "Se actualizó correctamente el usuario"
      else
        redirect_to edit_employee_path(params[:employee]), notice: "No se modificaron los datos del usuario"
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
      @usuario = @employee.user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:nombre, :apellido_paterno, :apellido_materno, :fecha_nacimiento, :direccion, :telefono, :celular, :email_personal, :carrera, :fecha_ingreso, :fecha_egreso, :costoxhora, :foto, :city_id, :department_id,:status, :cover)
    end
end
