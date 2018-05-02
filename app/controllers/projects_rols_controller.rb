class ProjectsRolsController < ApplicationController
  before_action :set_projects_rol, only: [:show, :edit, :update, :destroy]

  # GET /projects_rols
  # GET /projects_rols.json
  def index
    @projects_rols = ProjectsRol.all
  end

  # GET /projects_rols/1
  # GET /projects_rols/1.json
  def show
  end

  # GET /projects_rols/new
  def new
    @projects_rol = ProjectsRol.new
  end

  # GET /projects_rols/1/edit
  def edit
  end

  # POST /projects_rols
  # POST /projects_rols.json
  def create
    @projects_rol = ProjectsRol.new(projects_rol_params)

    respond_to do |format|
      if @projects_rol.save
        format.html { redirect_to @projects_rol, notice: 'Projects rol was successfully created.' }
        format.json { render :show, status: :created, location: @projects_rol }
      else
        format.html { render :new }
        format.json { render json: @projects_rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects_rols/1
  # PATCH/PUT /projects_rols/1.json
  def update
    respond_to do |format|
      if @projects_rol.update(projects_rol_params)
        format.html { redirect_to @projects_rol, notice: 'Projects rol was successfully updated.' }
        format.json { render :show, status: :ok, location: @projects_rol }
      else
        format.html { render :edit }
        format.json { render json: @projects_rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects_rols/1
  # DELETE /projects_rols/1.json
  def destroy
    @projects_rol.destroy
    respond_to do |format|
      format.html { redirect_to projects_rols_url, notice: 'Projects rol was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_projects_rol
      @projects_rol = ProjectsRol.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def projects_rol_params
      params.require(:projects_rol).permit(:project_id, :rol_id, :horas_presupuestadas, :costo_hora)
    end
end
