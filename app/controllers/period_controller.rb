class PeriodController < ApplicationController
  def index
  	require 'date'
  	@aniovalor = params[:anio].to_i
  	
  	start = Date.commercial(@aniovalor)
  	ende = Date.commercial(@aniovalor+1)

  	weeks = []
  	dstart = start.mday

	
  	if @aniovalor > 0
  		case dstart	
      #en caso de que el lunes sea dia 1
  		when 1
  			while start < ende
		  		endw = start + 6
		  		dai = endw.mday
		  		weeks << [ start.year,start,endw]  # <-- enhanced
		  		start += 7
		  
			end
			weeks.each do |x,w,y|   # <-- take two arguments in the block
  				u = Period.new(:anio => x, :fecha_inicio => w,:fecha_fin => y)
				  u.save
				  u
			end
			@aniostatus = {:status => start.year};
  		#en caso de que el martes sea dia 1
      when 31

        nstart = Date.new(@aniovalor)
        nend = Date.new(@aniovalor)+5
        weeks << [ nstart.year,nstart,nend]

        start = Date.commercial(@aniovalor,2)
        while start < ende
         endw = start + 6
         dai = endw.mday
         weeks << [ start.year,start,endw]  # <-- enhanced
         start += 7
      
        end
        weeks.each do |x,w,y|   # <-- take two arguments in the block
          u = Period.new(:anio => x, :fecha_inicio => w,:fecha_fin => y)
          u.save
          u
        end
  			@aniostatus = {:status => nstart.year};
  		#-----------------------------#en caso de que el miercoles sea dia 1
      when 30
        
        nstart = Date.new(@aniovalor)
        nend = Date.new(@aniovalor)+4
        weeks << [ nstart.year,nstart,nend]

        start = Date.commercial(@aniovalor,2)
        while start < ende
         endw = start + 6
         dai = endw.mday
         weeks << [ start.year,start,endw]  # <-- enhanced
         start += 7
      
        end
        weeks.each do |x,w,y|   # <-- take two arguments in the block
          u = Period.new(:anio => x, :fecha_inicio => w,:fecha_fin => y)
          u.save
          u
        end
        @aniostatus = {:status => nstart.year};
      #-----------------------------#en caso de que el jueves sea dia 1
    when 29
        
        nstart = Date.new(@aniovalor)
        nend = Date.new(@aniovalor)+3
        weeks << [ nstart.year,nstart,nend]

        start = Date.commercial(@aniovalor,2)
        while start < ende
         endw = start + 6
         dai = endw.mday
         weeks << [ start.year,start,endw]  # <-- enhanced
         start += 7
      
        end
        weeks.each do |x,w,y|   # <-- take two arguments in the block
          u = Period.new(:anio => x, :fecha_inicio => w,:fecha_fin => y)
          u.save
          u
        end
        @aniostatus = {:status => nstart.year};
      #-----------------------------#en caso de que el viernes sea dia 1
      when 4
        
        nstart = Date.new(@aniovalor)
        nend = Date.new(@aniovalor)+2
        weeks << [ nstart.year,nstart,nend]

        start = Date.commercial(@aniovalor)
        while start < ende
         endw = start + 6
         dai = endw.mday
         weeks << [ start.year,start,endw]  # <-- enhanced
         start += 7
      
        end
        weeks.each do |x,w,y|   # <-- take two arguments in the block
          u = Period.new(:anio => x, :fecha_inicio => w,:fecha_fin => y)
          u.save
          u
        end
        @aniostatus = {:status => nstart.year};
      #-----------------------------#en caso de que el sabado sea dia 1
    when 3
        
        nstart = Date.new(@aniovalor)
        nend = Date.new(@aniovalor)+1
        weeks << [ nstart.year,nstart,nend]

        start = Date.commercial(@aniovalor)
        while start < ende
         endw = start + 6
         dai = endw.mday
         weeks << [ start.year,start,endw]  # <-- enhanced
         start += 7
      
        end
        weeks.each do |x,w,y|   # <-- take two arguments in the block
          u = Period.new(:anio => x, :fecha_inicio => w,:fecha_fin => y)
          u.save
          u
        end
        @aniostatus = {:status => nstart.year};
      #-----------------------------#en caso de que el domingo sea dia 1
      when 2
        
        nstart = Date.new(@aniovalor)
        nend = Date.new(@aniovalor)
        weeks << [ nstart.year,nstart,nend]

        start = Date.commercial(@aniovalor)
        while start < ende
         endw = start + 6
         dai = endw.mday
         weeks << [ start.year,start,endw]  # <-- enhanced
         start += 7
      
        end
        weeks.each do |x,w,y|   # <-- take two arguments in the block
          u = Period.new(:anio => x, :fecha_inicio => w,:fecha_fin => y)
          u.save
          u
        end
        @aniostatus = {:status => nstart.year};
      #-----------------------------
  		else
  			@aniostatus = false;
  		end
    else
        @aniostatus = false;
  	end
  end
end
