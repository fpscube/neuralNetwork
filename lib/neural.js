

function classNeural(pNbInput,pNbOutput,pNbNeuronByLayer,pConfig,pLearningMode)  {

    this.NbNeuronByLayer = pNbNeuronByLayer;
    this.Config =  pConfig;

    this.LearningMode = pLearningMode;
    this.GenomTab=[];
	this.GenomCurrentIndex=0;
	this.GenerationCounter=0;
	this.GenomBestTab=[] ;
	this.GenomBestTabScore=[];
	this.NbGenByGenom= pNbInput * pNbNeuronByLayer + pNbNeuronByLayer * pNbNeuronByLayer + pNbNeuronByLayer * pNbOutput;
	this.NbGenomeByGeneration=100;
	this.NbBestGenom=10;
	this.GenomMixRatio=0.5;
    this.GenomMutationRatio=0.0001;
    
    
    if (pLearningMode)
    {
        for (var i=0;i<this.NbGenomeByGeneration;i++)
        {
            this.GenomTab[i]=[];		
            for (var y=0;y<this.NbGenByGenom;y++)
            {
                this.GenomTab[i][y]=Math.random()*2.0-1.0;
            }
            this.Config = this.GenomTab[0];
        }
        /* init GenomBestTab*/
        for (i=0;i<this.NbBestGenom;i++)
        {
            this.GenomBestTab[i] = [];
            this.GenomBestTabScore[i] = 0x7FFFFFFF;
        }
    }

    
    if (this.config == undefined) this.config = [];

    
    this.run = function(pInOut)
    {
        var configIndex=0;
        var firstLayerOutput = [];
        var secondLayerOutput = [];
        var nbNeuronByLayer = this.NbNeuronByLayer;
        var inTab = pInOut.in;
        var outTab = pInOut.out;
        
        var config = this.Config;
        
        /* first Layer */
        for (var i=0;i<nbNeuronByLayer;i++)
        {
            firstLayerOutput[i]=0;
            for (var y=0;y<inTab.length;y++)
            {
                firstLayerOutput[i]+=config[configIndex++]*inTab[y];
            }
        }
    
        /* saturation of first layer output */
        for (var i=0;i<nbNeuronByLayer;i++)
        {
            if (firstLayerOutput[i] > 1)  firstLayerOutput[i] = 1;
            else if (firstLayerOutput[i] < -1)  firstLayerOutput[i] = -1;
        }
    
        /* second Layer */
        for (var i=0;i<nbNeuronByLayer;i++)
        {
            secondLayerOutput[i] = 0;
            for (var y=0;y<nbNeuronByLayer;y++)
            {
                secondLayerOutput[i]+=config[configIndex++]*firstLayerOutput[y];
            }
        }
    
        /* saturation of second layer output */
        for (var i=0;i<nbNeuronByLayer;i++)
        {
            if (secondLayerOutput[i] > 1)  secondLayerOutput[i] = 1;
            else if (secondLayerOutput[i] < -1)  secondLayerOutput[i] = -1;
        }
    
        /* output values */
        for (var i=0;i<outTab.length;i++)
        {
            outTab[i]=0;
            for (var y=0;y<nbNeuronByLayer;y++)
            {
                outTab[i]+=config[configIndex++]*secondLayerOutput[y];
            }
        }
    

    };


    this.saveScore = function(pScore)
	{
        nbGenByGenom = this.NbGenByGenom;
        highScore = -1 ;
        indexHighScore = -1;
        /* Search the score to be replaced in genom table */
        for (var i=0; i<this.NbBestGenom;i++)
        {
            if (this.GenomBestTabScore[i] > highScore)
            {
                highScore =  this.GenomBestTabScore[i];
                indexHighScore=i;
            }
        }
        
        /* if score is best replace it*/
        if (highScore >score)
        {
            this.GenomBestTabScore[indexHighScore] = score;
            dst = this.GenomBestTab[indexHighScore];
            src = this.GenomTab[this.GenomCurrentIndex];
            for (var i=0 ;i<nbGenByGenom;i++){dst[i]=src[i];}
        }
        // switch to next genom
        this.GenomCurrentIndex++;
        this.Config = this.GenomTab[this.GenomCurrentIndex];
        if (this.GenomCurrentIndex < this.GenomTab.length) return; 

        // create a new generation if all genom have been of the current generation have been tested
        indexGenom=0;
        while (indexGenom < this.NbGenomeByGeneration)
        {
            for (iB1=0;iB1<this.NbBestGenom;iB1++){
            for (iB2=0;iB2<this.NbBestGenom;iB2++){
                if (indexGenom >= this.NbGenomeByGeneration) continue;
                for (var i=0 ;i<this.NbGenByGenom;i++)
                {
                    if(Math.random() > this.GenomMixRatio)
                    {
                        this.GenomTab[indexGenom][i] = this.GenomBestTab[iB1][i];
                    }
                    else
                    {
                        this.GenomTab[indexGenom][i] = this.GenomBestTab[iB2][i];
                    }
                    if(Math.random() < this.GenomMutationRatio)
                    {

                        this.GenomTab[indexGenom][i] = Math.random()*2.0-1.0;
                    }
                }
                indexGenom++;
            }}
        }
                    
        this.GenomCurrentIndex = 0;
        this.Config = this.GenomTab[this.GenomCurrentIndex];
        this.GenerationCounter++;
    };
    
    this.getBestGenom = function(bestGenomOut)
    {
        nbGenByGenom = this.NbGenByGenom;
        bestScore = 0x7FFFFFFF ;
        indexBestScore = -1;
        /* Search the score to be replaced in genom table */
        for (var i=0; i<this.NbBestGenom;i++)
        {
            if (this.GenomBestTabScore[i] < bestScore)
            {
                bestScore =  this.GenomBestTabScore[i];
                indexBestScore=i;
            }
        }

        /*Copy genom to output*/
        bestGenomOut["score"]=bestScore;
        bestGenomOut["genom"]=[];
        src = this.GenomBestTab[indexBestScore];
        dst = bestGenomOut["genom"];
        for (var i=0 ;i<nbGenByGenom;i++){dst[i]=src[i];}
    }

};