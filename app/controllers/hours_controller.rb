class HoursController < ApplicationController
  def index
    
    @periodos = Period.periodosAnualCombo
    empleado = current_user.employee_id
    estado = params[:aut].to_i
    idpe = params[:idpe].to_i
    comit = params[:commit]     
    @proyectos = Project.joins(projects_rols: [:employees_projects_rols]).where("employees_projects_rols.employee_id" => current_user.employee_id).group("id")
    if comit
        if params[:periods]
          @periodoSel = params[:periods][:period_id]
        else
          @periodoSel = nil
        end 

        @ppe = nil
        if @periodoSel
          @ppe = PeriodsProjectsEmployee.find_by(period_id: @periodoSel, employee_id: empleado)
        end
        if @ppe
          @hou = Hour.select(:project_id).distinct.where("hours.periods_projects_employee_id"=>@ppe.id)
          @status = @ppe.status
        end
        
        if estado == 1 and idpe != 0 
          PeriodsProjectsEmployee.update(idpe, :status => 1)  
          respond_to do |format| 
            format.html { redirect_to horas_incurridas_path(0,0), notice: 'Se ha Enviado la solicitud para la Autoriacion.' }  
            format.js  
          end
        end
        if comit != "Mostrar"
          @tabla = true
          ppeid = @ppe.id
          @proyecttable = comit.to_i
        end
    end
  

  end #end del metodo index

  def new
        idperiod = params[:idperiod]
        @periodos = Period.periodosAnualCombo2(idperiod)
        empleado = current_user.employee_id
        if params[:periods]
          @periodoSel = params[:periods][:period_id]
        else
          @periodoSel = nil
        end 

        @ppe = nil
        if @periodoSel
          @ppe = PeriodsProjectsEmployee.find_by(period_id: @periodoSel, employee_id: empleado)
        end
        @proyectos = Project.joins(projects_rols: [:employees_projects_rols]).where("employees_projects_rols.employee_id" => current_user.employee_id).group("id")    
        
        if params[:periods] 
          status = 0
          id = params[:periods][:period_id] 
          @proyecto = params[:projects][:project_id]
          campo1 = params[:Campo1].to_i
          campo2 = params[:Campo2].to_i 
          campo3 = params[:Campo3].to_i
          campo4 = params[:Campo4].to_i 
          campo5 = params[:Campo5].to_i
          campo6 = params[:Campo6].to_i
          campo7 = params[:Campo7].to_i
          periodo = Period.find(id)
          diaini = periodo.fecha_inicio
          diafin = periodo.fecha_fin
          semana = []
          horas = []
          semanahash = Hash.new 
          horashash = Hash.new
          while diaini <= diafin
            dia = diaini.cwday
            if dia == 1
              dia = "Lunes"
              semana << [ diaini]
              horas << campo1
              @lunhab = false
            end
            if dia == 2
              dia = "Martes"
              semana << [ diaini]
              horas << campo2
              @marhab = false
            end
            if dia == 3
              dia = "Miercoles"
              semana << [ diaini]
              horas << campo3
              @miehab = false
            end
            if dia == 4
              dia = "Jueves"
              semana << [ diaini]
              horas << campo4
              @juehab = false
            end
            if dia == 5
              dia = "Viernes"
              semana << [ diaini]
              horas << campo5
              @viehab = false
            end
            if dia == 6
              dia = "Sabado"
              semana << [ diaini]
              horas << campo6
              @sabhab = false
            end
            if dia == 7
              dia = "Domingo"
              semana << [ diaini]
              horas << campo7
              @domhab = false
            end      
            diaini += 1
          end
          h=0
          semana.each do |a|
            semanahash [h] = a
            h += 1
          end
          g = 0 
          horas.each do |b|
            horashash [g] = b
            g+=1 
          end

          diasmun = semana.length
          i=0
          
          @hora = nil
          if @ppe
            @hora = Hour.find_by(periods_projects_employee_id: @ppe.id, project_id: @proyecto)
          end 
          respond_to do |format|
            if !@hora  
              if @ppe
                for i in 0..diasmun-1 do
                  fe = semana[i].to_s
                  ho = horas[i]
                  detalle = Hour.new(:fecha => fe, :horas => ho, :project_id => @proyecto, :periods_projects_employee_id => @ppe.id)
                  detalle.save       
                end
              format.html { redirect_to horas_incurridas_path(0,0), notice: 'Horas capturadas en el proyecto '+Hour.nombre_proyecto(@proyecto)+' para el perido  seleccionado.' }
              
              else
                encabezado = PeriodsProjectsEmployee.new(:employee_id => empleado,:period_id => id, :status => status) 
                encabezado.save
                for i in 0..diasmun-1 do
                  fe = semana[i].to_s
                  ho = horas[i]
                  detalle = Hour.new(:fecha => fe, :horas => ho, :project_id => @proyecto, :periods_projects_employee_id => PeriodsProjectsEmployee.last.id)
                  detalle.save  
                end
              format.html { redirect_to horas_incurridas_path(0,0), notice: 'Horas capturadas en el proyecto '+Hour.nombre_proyecto(@proyecto)+' para el perido  seleccionado.' }
              end# en if !@ppe
            else
                format.html { redirect_to new_hours_path, alert: 'No se pueden guardar las horas ya que el proyecto '+Hour.nombre_proyecto(@proyecto)+' ya tiene horas asignadas para el perido  seleccionado. Selecciona otro proyecto o periodo' }
                format.js
            end# en if !@hora
          end#responds
          
        end #end del if params periods
  end #end metodo new

  def edit
    @lunhab = true 
    @marhab = true 
    @miehab = true 
    @juehab = true 
    @viehab = true 
    @sabhab = true 
    @domhab = true
    @idppe = params[:idppe]
    @idproject = params[:idproject]
    horareg = Hour.select(:id,:fecha,:horas).where("hours.periods_projects_employee_id"=>@idppe,"hours.project_id"=>@idproject)
    arrhora = []
    @arrid = []
    horareg.each do |t|
      arrhora << t.horas
      @arrid << t.id
    end
    idperiod = PeriodsProjectsEmployee.find(@idppe)
    @periodos = Period.periodosAnualCombo2(idperiod.period_id)
    @periodoSel = idperiod
    arrhora = arrhora.reverse
    @@arrid = @arrid.reverse
    count = 0
    lim = horareg.length
    while count <= lim-1
      if count == 0
        @domhab = false
        @domval = arrhora[count]
      elsif count == 1
        @sabhab = false
        @sabval = arrhora[count]
      elsif count == 2
        @viehab = false
        @vieval = arrhora[count]
      elsif count == 3
        @juehab = false
        @jueval = arrhora[count]
      elsif count == 4
        @miehab = false
        @mieval = arrhora[count]
      elsif count == 5
        @marhab = false
        @marval = arrhora[count]
      elsif count == 6
        @lunhab = false
        @lunval = arrhora[count]        
      end
      count += 1
    end
    
   
  end#end del metodo edit

  def update
    arr = @@arrid
    campo = []
    campo[6] = params[:Campo1].to_i
    campo[5] = params[:Campo2].to_i 
    campo[4] = params[:Campo3].to_i
    campo[3] = params[:Campo4].to_i 
    campo[2] = params[:Campo5].to_i
    campo[1] = params[:Campo6].to_i
    campo[0] = params[:Campo7].to_i
    captura = []
    for i in 0..arr.length-1 do
      captura << campo[i]
    end
    updatehash = Hash.new
    for i in 0..arr.length-1 do
      updatehash [arr[i]] = {"horas" => captura[i]}
    end
    Hour.update(updatehash.keys,updatehash.values)
    respond_to do |format| 
        format.html { redirect_to horas_incurridas_path(0,0), notice: 'Se ha Actualiado la informacion.' }  
        format.js  
      end
    
  end

  def show
    @idppe = params[:idppe]
    @idperiod = params[:idproject]
    @hou = Hour.select(:project_id,:periods_projects_employee_id).distinct.where("hours.periods_projects_employee_id"=>@idppe) 
    @periodos = Period.periodosAnualCombo2(@idperiod)
    @periodoSel = @idperiod
  end

end #end de la clase
