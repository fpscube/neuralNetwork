
class Neural	
	@@NbBestGenom=10
	@@NbGenomeByGeneration=@@NbBestGenom**2
	@@GenomMixRatio=0.5
	@@GenomMutationRatio=0.0001
	
	def initialize(pNbInput,pNbOutput,pNbNeuronByLayer,pConfig,pLearningMode) 
		@NbNeuronByLayer,@Config,@LearningMode = pNbNeuronByLayer,pConfig,pLearningMode
		@GenomTab,@GenomBestTab,@GenomBestTabScore=[],[],[]
		@NbGenByGenom= pNbInput * pNbNeuronByLayer + pNbNeuronByLayer * pNbNeuronByLayer + pNbNeuronByLayer * pNbOutput
		@GenomCurrentIndex=0

		if (pLearningMode)
			#init genom tab by random values
			@@NbGenomeByGeneration.times do |i|
				@GenomTab[i]=[]
				@NbGenByGenom.times { |y| @GenomTab[i][y]=rand*2.0-1.0}
				@Config = @GenomTab[0]
			end
			#init best tab
			@@NbBestGenom.times { |i| @GenomBestTab[i]=[];@GenomBestTabScore[i] = 0x7FFFFFFF }
		end
		
	end
  
    def run(pIn,pOut)
        configIndex=0
        firstLayerOutput,secondLayerOutput = [],[]
        
        #First Layer 
        @NbNeuronByLayer.times do |i|
            firstLayerOutput[i]=0
            pIn.length.times { |y| firstLayerOutput[i]+=@Config[configIndex]*pIn[y];configIndex+=1}     
			firstLayerOutput[i] = 1 if (firstLayerOutput[i] > 1)
			firstLayerOutput[i] = -1 if (firstLayerOutput[i] < -1)
        end
 
        #Second Layer 
        @NbNeuronByLayer.times do |i|
            secondLayerOutput[i]=0
            @NbNeuronByLayer.times { |y| secondLayerOutput[i]+=@Config[configIndex]*firstLayerOutput[y];configIndex+=1}     
			secondLayerOutput[i] = 1 if (secondLayerOutput[i] > 1)
			secondLayerOutput[i] = -1 if (secondLayerOutput[i] < -1)
			
        end 
    
        #output
        pOut.length.times  do |i|
            pOut[i]=0
			@NbNeuronByLayer.times { |y| pOut[i]+=@Config[configIndex]*secondLayerOutput[y];configIndex+=1}    
        end
    end


    def saveScore(pScore)
        nbGenByGenom = @NbGenByGenom	
		
		
        #add score and genom to best tab
        if (pScore < @GenomBestTabScore.max )
			indexScore = @GenomBestTabScore.index(@GenomBestTabScore.max)
            @GenomBestTabScore[indexScore] = pScore
			@GenomBestTab[indexScore] = @GenomTab[@GenomCurrentIndex].clone
        end
		
        #switch to next genom
		
        @GenomCurrentIndex+=1
        @Config = @GenomTab[@GenomCurrentIndex]

        # create a new generation if all genom of the current generation have been tested
        return if (@GenomCurrentIndex < @GenomTab.length)  
 
		indexGenom =0
        @@NbBestGenom.times do |iB1|
			@@NbBestGenom.times do |iB2|
				@NbGenByGenom.times do |i|
                    @GenomTab[indexGenom][i] =(rand > @@GenomMixRatio) ?  @GenomBestTab[iB1][i]:@GenomBestTab[iB2][i]
					@GenomTab[indexGenom][i] = rand*2.0-1.0	if(rand < @@GenomMutationRatio)
				end
				indexGenom+=1
			end
		end
                    
        @GenomCurrentIndex = 0
        @Config = @GenomTab[@GenomCurrentIndex]
   end
    
    def getBestGenom(bestGenomOut)
        bestGenomOut["score"]= @GenomBestTabScore.min
        bestGenomOut["genom"]= @GenomBestTab[@GenomBestTabScore.index(bestGenomOut["score"])].clone
    end

end