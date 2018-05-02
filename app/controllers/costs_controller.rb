class CostsController < ApplicationController
  before_action :set_cost, only: [:show, :edit, :update, :destroy]

  # GET /costs
  # GET /costs.json
  def index
    @costs = Cost.all
  end

  # GET /costs/1
  # GET /costs/1.json
  def show
  end

  # GET /costs/new
  def new
    @cost = Cost.new
  end

  # GET /costs/1/edit
  def edit
  end

  # POST /costs
  # POST /costs.json
  def create
    @cost = Cost.new(cost_params)

    respond_to do |format|
      if @cost.save
        format.html { redirect_to @cost, notice: 'Cost was successfully created.' }
        format.json { render :show, status: :created, location: @cost }
      else
        format.html { render :new }
        format.json { render json: @cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /costs/1
  # PATCH/PUT /costs/1.json
  def update
    respond_to do |format|
      if @cost.update(cost_params)
        format.html { redirect_to @cost, notice: 'Cost was successfully updated.' }
        format.json { render :show, status: :ok, location: @cost }
      else
        format.html { render :edit }
        format.json { render json: @cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /costs/1
  # DELETE /costs/1.json
  def destroy
    @cost.destroy 
    respond_to do |format|
      format.html { redirect_to costs_url, notice: 'Cost was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def nuevo
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cost
      @cost = Cost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cost_params
      params.require(:cost).permit(:fecha, :monto, :project_id, :concept_id)
    end
end
