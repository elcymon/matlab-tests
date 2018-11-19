function gradientComputationUpdated()
    experimentData = readExperimentData();
    
    noiseParams = developNoiseModel(experimentData);
    
    sError = cell2mat(noiseParams(3,2:end)); %Standard deviation of line fit mismatch
    mIntensity = cell2mat(noiseParams(4,2:end)); %Mean intensities of chunks
    sig2noise = cell2mat(noiseParams(7,2:end)); % sError / mIntensity
    
    
    meanSError = mean(sError);
    meanSig2noise = mean(sig2noise);
    stdSig2noise = std(sig2noise);
    
    plotModelsV2(meanSError,experimentData,stdSig2noise,meanSig2noise)
    
    display(sprintf('mean sError \t %.4f \nstdev sig2noise \t %.4f \nmean sig2noise %.4f \n'...
        ,meanSError,stdSig2noise,meanSig2noise))
end