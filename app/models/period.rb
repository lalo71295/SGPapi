# == Schema Information
#
# Table name: periods
#
#  id           :integer          not null, primary key
#  anio         :integer
#  fecha_inicio :date
#  fecha_fin    :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Period < ApplicationRecord
	has_many :periods_projects_employees
  has_many :expenses_headers
  has_many :employees, through: :expenses_headers
  has_many :expenses, through: :expenses_headers
  has_many :expenses_generals
  has_many :expenses_employees_generals, through: :expenses_generals
  has_many :employees, through: :expenses_employees_generals
  has_many :hours_headers


  
 	#has_many :user, through: :product #Linea de ejemplo

 	def self.periodsif(user,idppe)
    per = PeriodsProjectsEmployee.find_by(employee_id: user, id:idppe )
    peri = per.period_id
    per2 = Period.find_by(id:peri)
    ini = per2.fecha_inicio
    fin = per2.fecha_fin
    ini = ini.to_formatted_s(:short)
    fin = fin.to_formatted_s(:short)

		"Periodo del dia  #{ini} al  dia #{fin}"
	end

  def periodosAnual
    anio = Date.now.year.to_i
    Period.where(["anio >= %s",anio]).order(:fecha_inicio, 'DESC')
  end
  def periodoRango
    fInicio = Date.strptime("#{fecha_inicio}", "%Y-%m-%d")
    fIni = fInicio.to_formatted_s(:rfc822)
    fFinal = Date.strptime("#{fecha_fin}", "%Y-%m-%d")
    fFin = fFinal.to_formatted_s(:rfc822)
    "#{fIni} - #{fFin}"
  end

  def self.periodosAnualCombo
  	fInicio = Time.now - 2.month
  	fFin 	= Time.now + 1.week
  	Period.where(["fecha_inicio >= '%s' and fecha_fin <= '%s'", fInicio, fFin]).order(:fecha_inicio)
  end

  def self.periodosPorRango(rango)
    today   = Date.today # => Thu, 18 Jun 2015
    fInicio = today.beginning_of_month.to_s(:db)
    fFinal  = today.end_of_month.to_s(:db)#(Date.today + 1).to_s(:db)

    if rango == "mes1"
      fInicio = today.beginning_of_month.to_s(:db)
    elsif rango == "mes2"
      fInicio = today.prev_month.beginning_of_month.to_s(:db)
    elsif rango == "mes3"
      fInicio = today.prev_month.prev_month.beginning_of_month.to_s(:db)
    elsif rango == "anio1"
      fInicio = today.at_beginning_of_year.to_s(:db)
    elsif rango == "anio2"
      fInicio = today.prev_year.at_beginning_of_year.to_s(:db)
    end

    where(["fecha_inicio >= '%s' and fecha_fin <= '%s'", fInicio, fFinal]).order(:fecha_inicio)

  end

end
def self.getDiaPorFecha(id)

    periodo = Period.find(id)
    diaini = periodo.fecha_inicio
    inisem = diaini.cwday
    diafin = periodo.fecha_fin
    finsem = diafin.cwday
    result = diafin - diaini + 1
    semana = {}
    if inisem == 1
      semana = {"Lunes" => diaini, "Martes" => diaini+1, "Miercoles"=> diaini+2,
        "Jueves" => diaini+3, "Vienes"=> diaini+4, "Sabado"=>diaini+5, "domingo"=> diaini+6}
    end
    if inisem == 2
      semana = {"Martes" => diaini, "Miercoles"=> diaini+1,
        "Jueves" => diaini+2, "Vienes"=> diaini+3, "Sabado"=>diaini+4, "domingo"=> diaini+5}
    end
    if inisem == 3
      semana = { "Miercoles"=> diaini,
        "Jueves" => diaini+1, "Vienes"=> diaini+2, "Sabado"=>diaini+3, "domingo"=> diaini+4}
    end
    if inisem == 4
      semana = {"Jueves" => diaini, "Vienes"=> diaini+1, "Sabado"=>diaini+2, "domingo"=> diaini+3}
    end
    if inisem == 5
      semana = { "Vienes"=> diaini, "Sabado"=>diaini+1, "domingo"=> diaini+2}
    end
    if inisem == 6
      semana = { "Sabado"=>diaini, "domingo"=> diaini+1}
    end
    if inisem == 7
      semana = { "Domingo"=> diaini}
    end
end

def procesaperiodo(anio)
  require 'date'

  # <-- print 'introduce el año: ' # <-- comentado para ruby on rails
  anio = gets.to_i


  start = Date.commercial(anio)
  ende = Date.commercial(anio+1)

  weeks = []

  dstart = start.mday
  if dstart == 1 # <-- si el dia primero es lunes
    while start < ende
      endw = start + 6
      dai = endw.mday
      weeks << [ start.year,start,endw]  # <-- enhanced
      start += 7

    end
    weeks.each do |x,w,y|   # <-- take two arguments in the block
      # <-- 	puts "#{x} /#{w} / #{y} "  #     and print them both out

    end
  elsif dstart == 31 # <-- enhanced
    nstart = Date.new(anio)
    nend = Date.new(anio)+5
    weeks << [ nstart.year,nstart,nend]



    start = Date.commercial(anio,2)
    while start < ende
      endw = start + 6
      dai = endw.mday
      weeks << [ start.year,start,endw]  # <-- enhanced
      start += 7

    end
    weeks.each do |x,w,y|   # <-- take two arguments in the block
      # <--  		puts "#{x} /#{w} / #{y} "  #     and print them both out

    end

  elsif dstart == 30 # <-- enhanced
    nstart = Date.new(anio)
    nend = Date.new(anio)+4
    weeks << [ nstart.year,nstart,nend]



    start = Date.commercial(anio,2)
    while start < ende
      endw = start + 6
      dai = endw.mday
      weeks << [ start.year,start,endw]  # <-- enhanced
      start += 7

    end
    weeks.each do |x,w,y|   # <-- take two arguments in the block
      # <-- 		puts "#{x} /#{w} / #{y} "  #     and print them both out

    end

  elsif dstart == 29 # <-- enhanced
    nstart = Date.new(anio)
    nend = Date.new(anio)+3
    weeks << [ nstart.year,nstart,nend]



    start = Date.commercial(anio,2)
    while start < ende
      endw = start + 6
      dai = endw.mday
      weeks << [ start.year,start,endw]  # <-- enhanced
      start += 7

    end
    weeks.each do |x,w,y|   # <-- take two arguments in the block
      # <-- 	puts "#{x} /#{w} / #{y} "  #     and print them both out

    end

  elsif dstart == 4 # <-- enhanced
    nstart = Date.new(anio)
    nend = Date.new(anio)+2
    weeks << [ nstart.year,nstart,nend]



    start = Date.commercial(anio)
    while start < ende
      endw = start + 6
      dai = endw.mday
      weeks << [ start.year,start,endw]  # <-- enhanced
      start += 7

    end
    weeks.each do |x,w,y|   # <-- take two arguments in the block
      # <-- puts "#{x} /#{w} / #{y} "  #     and print them both out

    end

  elsif dstart == 3 # <-- enhanced
    nstart = Date.new(anio)
    nend = Date.new(anio)+1
    weeks << [ nstart.year,nstart,nend]



    start = Date.commercial(anio)
    while start < ende
      endw = start + 6
      dai = endw.mday
      weeks << [ start.year,start,endw]  # <-- enhanced
      start += 7

    end
    weeks.each do |x,w,y|   # <-- take two arguments in the block
      # <-- 	puts "#{x} /#{w} / #{y} "  #     and print them both out

    end

  elsif dstart == 2 # <-- enhanced
    nstart = Date.new(anio)
    nend = Date.new(anio)
    weeks << [ nstart.year,nstart,nend]



    start = Date.commercial(anio)
    while start < ende
      endw = start + 6
      dai = endw.mday
      weeks << [ start.year,start,endw]  # <-- enhanced
      start += 7

    end
    weeks.each do |x,w,y|   # <-- take two arguments in the block
      # <-- 	puts "#{x} /#{w} / #{y} "  #     and print them both out

    end

  end

end
