function [tModel,xModel,pureSignal,meanError,stdError,x] = developSoundModel(expData)
% expData is a cell matrix of all sound experiments conducted. It is
% arranged in the form of 3 by n cell matrix, where each column represent
% an experiment and the rows are for sound intensity, relative distance
% from source gotten from encoder readings and corresponding time in
% seconds measured by the robot respectively (i.e. rows are sound
% intensity, distance and time for row 1, 2 and 3 respectively)
%     Initialize the parameters for fitting the sound models
    x0 = [200 1];
    Ae = 48.1824;
    ndeed = @(x,xData) x(1) * (exp(-x(2) * xData)) + Ae; 
    
    allY = cell2mat(expData(1,:)');
    allX = cell2mat(expData(2,:)');
    allT = cell2mat(expData(3,:)');
%     sort the data
    [allT, sortOrder] = sort(allT);
    allY = allY(sortOrder,:);
    allX = allX(sortOrder,:);
    
%     Initialize parameters needed for extracting experiment data needed
    minX = min(allX);
    maxX = max(allX);
    minT = min(allT);
    maxT = max(allT);
    
    nDataPoints = max(cellfun(@numel,expData(1,:)));%for knowing how many x,y points to gnenerate
    
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