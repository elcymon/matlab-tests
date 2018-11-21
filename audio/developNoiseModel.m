function [noiseParams,figID] = developNoiseModel(expData,figID)
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
    Stops = minD:Step:maxD;
    
    Headers = cell(1,numel(Stops));
    Headers{1} = 'Distance (m)';
    for i = 1:numel(Stops)-1
        Headers{i+1} = sprintf('%i to %i ',Stops(i),Stops(i+1));
    end
    
    noiseParams = cell(7,numel(Headers));
    noiseParams(1,1:end) = Headers;
    noiseParams(2:end,1) = {'mError';'sError';'mIntensity'...
                            ;'mDistance';'mTime';'sig2noise'};
    
    
    currMin = minD;
    currMax = minD + Step;
    i1 = 1;
    figID = figID + 1;
    figure(figID)
    plot(allX,allY,'DisplayName','Experiment Data')
    ylim([0 Inf])
    ylabel('Intensity')
    xlabel('Distance (metres)')
    hold on
    while currMax <= maxD
        pYbin = allY(allX >=currMin & allX <= currMax);
        pXbin = allX(allX >=currMin & allX <= currMax);
        pTbin = allT(allX >=currMin & allX <= currMax);
        
        p = polyfit(pXbin,pYbin,1);
        lineFit = pXbin .* p(1) + p(2);
        lineError = lineFit - pYbin;
        
        noiseParams{2,i1 + 1} = mean(lineError);
        noiseParams{3,i1 + 1} = std(lineError);
        noiseParams{4,i1 + 1} = mean(pYbin);
        noiseParams{5,i1 + 1} = mean(pXbin);
        noiseParams{6,i1 + 1} = mean(pTbin);
        noiseParams{7,i1 + 1} = mean(pYbin)\std(lineError);
        currMin = currMax;
        currMax = currMax + Step;
        i1 = i1 + 1;
        
        plot(pXbin,lineFit,'k','LineWidth',2,'DisplayName','Fitted Line')
    end
    hold off
    legend({'Experiment Data','Fitted Line'})
    savePlot(gcf,'line-fits-noise-model')
    figID = figID + 1;
    figure(figID)
    
        scatter(cell2mat(noiseParams(5,2:end)),cell2mat(noiseParams(7,2:end)))
        ylim([0 max(cell2mat(noiseParams(7,2:end)))*1.5])
        ylabel('(Noise Stdev) / (Mean Intensity)')
        xlabel('Distance (metres)')
        savePlot(gcf,'noise-stdev-to-mean-intensity')
        
    figID = figID + 1;
    figure(figID)
    
        scatter(cell2mat(noiseParams(5,2:end)),cell2mat(noiseParams(3,2:end)))
        ylim([0 max(cell2mat(noiseParams(3,2:end)))*1.5])
        ylabel('Noise Stdev')
        xlabel('Distance (metres)')
        savePlot(gcf,'noise-stdev-vs-distance')
end