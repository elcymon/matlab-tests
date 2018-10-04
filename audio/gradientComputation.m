% Experiments on different filtering approaches
filename = '20180909231249datagoexp1a';
xy = csvread(strcat(filename,'.txt'));
xdata = xy(:,2);
ydata = xy(:,end);
t = xy(:,1);
hz = 40;
w = 40;
step = w;

stArt = 1;
eNd = w;

% tPuls = NaN(1,ceil(numel(ydata)/(step+w)));
yPuls = NaN(1,ceil(numel(ydata)/(step+w)));
% xPuls = NaN(1,ceil(numel(ydata)/(step+w)));
yPulsZeros = NaN(size(ydata));
yPulsmeans = NaN(ceil(numel(ydata)/(step+w)));
yPulsmax = NaN(ceil(numel(ydata)/(step+w)));
j = 1;
i = 1;

iw = w;
while eNd <= numel(ydata)
    if isempty(ydata(stArt:eNd))
        break;
    end
    yPulsZeros(stArt:eNd) = ydata(stArt:eNd);
    yPulsmeans(j) = mean(ydata(stArt:eNd));
    
    
    yPulsmax(j) = max(ydata(stArt:eNd));
    
    j = j + 1;
%     tPuls(i:iw) = t(stArt:eNd);
%     (yPuls(i:iw))
%     (ydata(stArt:eNd))
%     yPuls(i:iw) = ydata(stArt:eNd);
%     xPuls(i:iw) = xdata(stArt:eNd);
    if eNd == numel(ydata)
        break;
    end
    i = iw + 1;
    iw = i + w;
    stArt = eNd + step + 1;
    eNd = stArt + w;
    if eNd > numel(ydata)
        eNd = numel(ydata);
%         iw = numel(yPuls);
    end
%     display(i)
end
figure(1)

    plot(xdata,yPulsZeros)
    ylabel('\boldmath Amplitude', 'Interpreter', 'Latex',...
           'FontSize',20,'FontWeight','bold')
    xlabel('\boldmath distance', 'Interpreter', 'Latex',...
       'FontSize',20,'FontWeight','bold')
    ylim([0 max(yPulsZeros)]);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    print(fig,sprintf('%s%s_width-%d_step-%d',filename,'_puls',w,step),'-dpdf')
% --------------------------------------
% Fitting a line to data in intervals
figure(2)
    hold on
    windowSize = 160;
    startPoint = 1;
    endPoint = windowSize;
    yPoints = NaN(size(ydata));
    while endPoint <= numel(ydata)
        if isempty(ydata(startPoint:endPoint))
            break;
        end
        p = polyfit(xdata(startPoint:endPoint),ydata(startPoint:endPoint),1);
        yPoints(startPoint:endPoint) = polyval(p,xdata(startPoint:endPoint));
        
        lineColor = '-b';
        if p(1) > 0
            lineColor = '-r';
        end
        plot(xdata(startPoint:endPoint),yPoints(startPoint:endPoint),lineColor)
        startPoint = endPoint + 1;
        endPoint = startPoint + windowSize - 1;
        if endPoint == numel(ydata)
            break;
        end
        if endPoint > numel(ydata)
            endPoint = numel(ydata);
        end
        
    end
    hold off
    
    ylabel('\boldmath Amplitude', 'Interpreter', 'Latex',...
           'FontSize',20,'FontWeight','bold')
    xlabel('\boldmath distance', 'Interpreter', 'Latex',...
       'FontSize',20,'FontWeight','bold')
    ylim([0 max(yPulsZeros)]);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    print(fig,sprintf('%s%s_windowSize-%d',filename,'_lineFit',windowSize),'-dpdf')
