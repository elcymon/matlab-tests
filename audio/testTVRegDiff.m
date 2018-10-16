% Was created to test the behavour of TVRegDiff. Abandoned it to implement
% it within the gradientComputation Script instead.
function testTVRegDiff()
%     u = TVRegDiff( data, iter, alph, u0, scale, ep, dx, plotflag, diagflag )
    npoints  = 100000;
    minx = 0;
    maxx = 15;
    ymin = 48.1824;
    ymax = 140.5193 + ymin;
    ylinearvalues = linspace(ymax,ymin,npoints);
    xvalues = linspace(minx,maxx,npoints);
    figure('Name','Linear Model')
    subplot(2,1,1)
    plot(xvalues,ylinearvalues)
    subplot(2,1,2)
    diffgrads = gradient(ylinearvalues);
    plot(linspace(minx,maxx,length(diffgrads)),diffgrads)
    
    
    
%     Modelled sound data
    AnAlpha = [140.5193, 0.1193];
%     noiseInfo = [0.1207,9.381];
    Ae = 48.1824;
    ndeed = @(x,xdata)x(1)*(exp(-x(2)*(xdata))) + Ae;
    ysoundData = ndeed(AnAlpha,xvalues);
    figure('Name','Sound Model')
    subplot(2,1,1)
    plot(xvalues,ysoundData)
    subplot(2,1,2)
    gradSoundData = gradient(ysoundData);
    plot(linspace(minx,maxx,length(gradSoundData)),gradSoundData)
end