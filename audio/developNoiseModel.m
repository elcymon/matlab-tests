function noiseParams = developNoiseModel(expData)
    allY = cell2mat(expData(1,:)');%sound intensity
    allX = cell2mat(expData(2,:)');%distance in metres
    allT = cell2mat(expData(3,:)');%time
%     sort the data
    [allT, sortOrder] = sort(allT);
    allY = allY(sortOrder,:);
    allX = allX(sortOrder,:);
    
%     Divide the whole distance to steps
    minD = 0;
    maxD = ceil(max(allX));
    Step = 1;
    Stops = minD:Step:maxD-1;
    
    Headers = cell(1,numel(Stops));
    Headers{1} = 'Distance (m)';
    for i = Stops
        Headers{i+2} = sprintf('%i to %i ',i,i+1);
    end
    
    noiseParams = cell(4,numel(Headers));
    noiseParams(1,1:end) = Headers;
    noiseParams(2:4,1) = {'mError';'sError';'mIntensity'};
    
    
    currMin = minD;
    currMax = minD + Step;
    
    plot(allX,allY)
    
    hold on
    while currMax <= maxD
        pYbin = allY(allX >=currMin & allX <= currMax);
        pXbin = allX(allX >=currMin & allX <= currMax);
        pTbin = allT(allX >=currMin & allX <= currMax);
        
        p = polyfit(pXbin,pYbin,1);
        lineFit = pXbin .* p(1) + p(2);
        lineError = lineFit - pYbin;
        
        noiseParams{2,currMax + 1} = mean(lineError);
        noiseParams{3,currMax + 1} = std(lineError);
        noiseParams{4,currMax + 1} = mean(pYbin);
        currMin = currMax;
        currMax = currMax + Step;
        
        plot(pXbin,lineFit,'k','LineWidth',2)
    end
    hold off
end