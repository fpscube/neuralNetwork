
load '../lib/neural.rb' 


neural = Neural.new(3,1,100,nil,true)
out = [0]
bestGenom = {}
200000.times do |i|

	score =0
	neural.run([0,0,0],out); score += (out[0]-0).abs
	neural.run([0,0,1],out); score += (out[0]-0).abs
	neural.run([0,1,0],out); score += (out[0]-0).abs
	neural.run([0,1,1],out); score += (out[0]-0).abs
	neural.run([1,0,0],out); score += (out[0]-0).abs
	neural.run([1,0,1],out); score += (out[0]-0).abs
	neural.run([1,1,0],out); score += (out[0]-0).abs
	neural.run([1,1,1],out); score += (out[0]-1).abs
	neural.saveScore(score)
	neural.getBestGenom(bestGenom)
	if (i%1000==0)
		puts bestGenom["score"].to_s
		target = open("genom.txt", 'w')
		target.puts "genom = " + bestGenom["genom"].to_s 
		target.close
	end
end

neural.getBestGenom(bestGenom)
