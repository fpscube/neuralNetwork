load '../lib/neural.rb' 


def runGame(neural,sizeX,sizeY,posX,posY,display)
	@Grid = []
	(sizeY+2).times do |y| 
		@Grid[y] ||= []
		(sizeX+2).times do |x|
			if (x==0 || x==(sizeX+1) || y==0 || y==(sizeY+1))
				@Grid[y][x] = 1
			else
				@Grid[y][x] = 0
			end
		end
	end

	posX+=1
	posY+=1
	out=[0,0,0,0]
	count=0
	while(1)
		inTab=[]
		inTab.push(@Grid[posY  ][posX+1])
		inTab.push(@Grid[posY+1][posX  ])
		inTab.push(@Grid[posY  ][posX-1])
		inTab.push(@Grid[posY-1][posX  ])
		neural.run(inTab,out)
		outIndex=out.index(out.max)
		posY -=1 if (outIndex==0) #north
		posX +=1 if (outIndex==1) #east
		posY +=1 if (outIndex==2) #south
		posX -=1 if (outIndex==3) #west 

		if (@Grid[posY][posX] == 0)
			@Grid[posY][posX] = 1
			count+=1
		else
			if (display)
				@Grid.each { |i| puts i.to_s}
				puts
			end
			return (1.0 - count.to_f/(sizeX*sizeY))
		end
	end

end



neural = Neural.new(4,4,8,nil,true)
100000.times do |i| 	
	score=0	
	score+=runGame(neural,20,20,15,15,false)
	score+=runGame(neural,1,10,0,0,false)
	score+=runGame(neural,2,10,1,0,false)
	score+=runGame(neural,10,4,9,1,false)
	score+=runGame(neural,20,16,0,15,false)
	score+=runGame(neural,18,20,17,19,false)
	score+=runGame(neural,20,30,10,15,false)
	score+=runGame(neural,4,4,2,2,false)
	score+=runGame(neural,4,5,3,0,false)
	if (i%100==0)
		bestGenom={}
		neural.getBestGenom(bestGenom)		
		puts bestGenom["score"]/9
		target = open("genom.txt", 'w')
		target.puts "genom = " + bestGenom["genom"].to_s 
		target.close
	end
	neural.saveScore(score) 	
end





