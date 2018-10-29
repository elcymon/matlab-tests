function [pureSignal,meanError,stdError] = FitSoundModel(xdata,ydata,x0,Ae)
% Function to fit sound data to a sound model represented by ndeed, which
% is a negative exponential function.
% All arguments are required:
%   xdata is a vector representing distance
%   ydata is a vector of equal size as xdata representing the corresponding
%       sound intensity
%   x0 is the starting point for lsqcurvefit function
%   Ae is the ambient noise value 
% Returns:
%   pureSignal the fitted curve which represents the pure signal fit
%   meanError the error between the pure signal and the ydata
%   stdError the standard deviation between pure signal and ydata
    ndeed = @(x,xdata) x(1)*(exp(-x(2) * xdata)) + Ae;
    
    x = lsqcurvefit(ndeed,x0,xdata,ydata);
    
    display(sprintf('%d ',x))
    
    pureSignal = ndeed(x,xdata);
    
    yError = pureSignal - ydata;
    meanError = mean(yError);
    stdError = std(yError);
    
    
end