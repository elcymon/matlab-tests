function [tModel,xModel,pureSignal,meanError,stdError,x] = developSoundModel(expData)
%     Initialize the parameters for fitting the sound models
    x0 = [200 1];
    Ae = 48.1824;
    ndeed = @(x,xData) x(1) * (exp(-x(2) * xData)) + Ae;
%     Initialize parameters needed for extracting experiment data needed
    minX = NaN;
    maxX = NaN;
    minT = NaN;
    maxT = NaN;
    
    nDataPoints = NaN;%for knowing how many x,y points to gnenerate
        
    allX = [];
    allY = [];
    allT = [];
    for i1 = 1:size(expData,2)
%         xy = csvread(strcat(expFiles{i1},'.txt'));
        xdata = expData{2,i1};
        ydata = expData{1,i1};
        tdata = expData{3,i1};
        allX = [allX;xdata];
        allY = [allY;ydata];
        allT = [allT;tdata];
%         numel(xdata)
        if isnan(nDataPoints)
            nDataPoints = numel(xdata);
        elseif nDataPoints < numel(xdata)
            nDataPoints = numel(xdata);
        end
%         Extract minimum values
        if isnan(minX)
            minX = min(xdata);
        elseif minX > min(xdata)
            minX = min(xdata);
        end
        if isnan(minT)
            minT = min(tdata);
        elseif minT > min(tdata)
            minT = min(tdata);
        end
        
%         Extract maximum values
        if isnan(maxX)
            maxX = min(xdata);
        elseif maxX < max(xdata)
            maxX = max(xdata);
        end
        if isnan(maxT)
            maxT = min(tdata);
        elseif maxT < min(tdata)
            maxT = max(tdata);
        end
    end
    
%     Get perform curvefit on all experiment data
    x = lsqcurvefit(ndeed,x0,allX,allY);
    
    xModel = linspace(minX,maxX,nDataPoints);
    tModel = linspace(minT,maxT,nDataPoints);
    pureSignal = ndeed(x,xModel);
    
    pureSignal2 = ndeed(x,allX);
    eRRoR = pureSignal2 - allY;
    meanError = mean(eRRoR);
    stdError = std(eRRoR);
    
    
%     [pureSignal,meanError,stdError] = FitSoundModel(allX,allY,x0,Ae);
end