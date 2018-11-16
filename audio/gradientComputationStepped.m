function gradientComputationStepped(pureSignal,xModel,tModel, stdError, meanError, errScale)
    Tests = {10,0;20,0;30,0;40,0;60,0;80,0;120,0};
    minD = 0;
    maxD = ceil(max(xModel));
    Step = 1;
    Stops = minD:Step:maxD-1;
    
    Headers = cell(1,numel(Stops));
    Headers{1} = 'Distance (m)';
    for i = Stops
        Headers{i+2} = sprintf('%i to %i ',i,i+1);
    end
    
    MeansFilter = cell(size(Tests,1)+1,size(Headers,2));
    MeansFilter(1,:) = Headers;
    
    LineFitFilter = MeansFilter;
    LineRegFilter = MeansFilter;
    TVRegDiffFilter = MeansFilter;
    
    currMin = minD;
    currMax = minD + Step;
    while currMax <= maxD
        pSignalBin = pureSignal(xModel >= currMin & xModel <= currMax);
        xModelBin = xModel(xModel >= currMin & xModel <= currMax);
        tModelBin = tModel(xModel >= currMin & xModel <= currMax);
        Analysis = analyseData({pSignalBin,xModelBin,tModelBin},Tests,stdError,meanError,errScale);
        if currMax == 1
            %Initialize first columns
            MeansFilter(:,1) = Analysis(:,1);
            LineFitFilter(:,1) = Analysis(:,1);
            LineRegFilter(:,1) = Analysis(:,1);
            TVRegDiffFilter(:,1) = Analysis(:,1);
        end
        
        MeansFilter(2:end,currMax+1) = Analysis(2:end,2);
        LineFitFilter(2:end,currMax+1) = Analysis(2:end,3);
        LineRegFilter(2:end,currMax+1) = Analysis(2:end,4);
        TVRegDiffFilter(2:end,currMax+1) = Analysis(2:end,5);
        currMin = currMax;
        currMax = currMax + Step;
    end
    xlswrite('GradientAnalysis.xlsx',MeansFilter',...
        sprintf('MeansFilter %iPct Error',round(errScale*100)),'A1');
    
    xlswrite('GradientAnalysis.xlsx',LineFitFilter',...
        sprintf('LineFitFilter %iPct Error',round(errScale*100)),'A1');
    
    xlswrite('GradientAnalysis.xlsx',LineRegFilter',...
        sprintf('LineRegFilter %iPct Error',round(errScale*100)),'A1');
    
    xlswrite('GradientAnalysis.xlsx',TVRegDiffFilter',...
        sprintf('TVRegDiffFilter %iPct Error',round(errScale*100)),'A1');
end