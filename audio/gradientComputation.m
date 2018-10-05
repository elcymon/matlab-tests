% Experiments on different filtering approaches
filename = '20180909231651datagoexp1b';
xy = csvread(strcat(filename,'.txt'));
xdata = xy(:,2);
ydata = xy(:,end);
t = xy(:,1);
hz = 40;
PulsFilterData = cell(11,5);
PulsFilterData(1,:) = {'Pitch','Trough','+grad','-grad','%+ve'};
PulsFilterData(2:end,1:2) = {10,0;10,10;10,20;10,30;...
                             20,0;20,20;20,40;
                             40,0;40,40;40,80};
for i1 = 2:size(PulsFilterData,1)
    w = PulsFilterData{i1,1};
    step = PulsFilterData{i1,2};

    stArt = 1;
    eNd = w;

    yPulsZeros = NaN(size(ydata));
    yPulsmeans = NaN(1,ceil(numel(ydata)/(step+w))-1);
    yPulsmax = NaN(1,ceil(numel(ydata)/(step+w))-1);
    xPuls = NaN(size(yPulsmeans));
    j = 1;
    i = 1;
%     hold on
    iw = w;
    bluePuls = 0;
    redPuls = 0;
    Blue = 0;
    Red = 0;
    while eNd <= numel(ydata)
        if isempty(ydata(stArt:eNd))
            break;
        end
        yPulsZeros(stArt:eNd) = ydata(stArt:eNd);
        yPulsmeans(j) = mean(ydata(stArt:eNd));
        xPuls(j) = median(xdata(stArt:eNd));

        lineColor = '-b';
        if j > 1
            if yPulsmeans(j-1) < yPulsmeans(j)
                lineColor = '-r';
                redPuls = redPuls + 1;
%                 Red = plot(xPuls(j-1:j),yPulsmeans(j-1:j),lineColor);
            else
                bluePuls = bluePuls + 1;
%                 Blue = plot(xPuls(j-1:j),yPulsmeans(j-1:j),lineColor);
            end
        end
        yPulsmax(j) = max(ydata(stArt:eNd));
        if eNd == numel(ydata)
            break;
        end
        stArt = eNd + step + 1;
        eNd = stArt + w;
        if eNd > numel(ydata)
            eNd = numel(ydata);
        end
        j = j + 1;
    end
    PulsFilterData{i1,3} = bluePuls;
    PulsFilterData{i1,4} = redPuls;
    PulsFilterData{i1,5} = bluePuls/(redPuls+bluePuls);
end
%     legend([Blue,Red],{num2str(bluePuls/(redPuls+bluePuls)),num2str(redPuls/(redPuls+bluePuls))})
%     hold off
% figure(1)
% 
%     plot(xdata,yPulsZeros)
%     ylabel('\boldmath Amplitude', 'Interpreter', 'Latex',...
%            'FontSize',20,'FontWeight','bold')
%     xlabel('\boldmath distance', 'Interpreter', 'Latex',...
%        'FontSize',20,'FontWeight','bold')
%     ylim([0 max(yPulsZeros)]);
%     fig = gcf;
%     fig.PaperPositionMode = 'auto';
%     fig_pos = fig.PaperPosition;
%     fig.PaperSize = [fig_pos(3) fig_pos(4)];
%     print(fig,sprintf('%s%s_width-%d_step-%d',filename,'_puls',w,step),'-dpdf')
% --------------------------------------
% Fitting a line to data in intervals
% figure(2)
%     hold on
    windowSize = 160;
    startPoint = 1;
    endPoint = windowSize;
    yPoints = NaN(size(ydata));
    blueLine = 0;
    redLine = 0;
    while endPoint <= numel(ydata)
        if isempty(ydata(startPoint:endPoint))
            break;
        end
        p = polyfit(xdata(startPoint:endPoint),ydata(startPoint:endPoint),1);
        yPoints(startPoint:endPoint) = polyval(p,xdata(startPoint:endPoint));
        
        lineColor = '-b';
        if p(1) > 0
            lineColor = '-r';
            redLine = redLine + 1;
        else
            blueLine = blueLine + 1;
        end
        
%         plot(xdata(startPoint:endPoint),yPoints(startPoint:endPoint),lineColor)
        startPoint = endPoint + 1;
        endPoint = startPoint + windowSize - 1;
        if endPoint == numel(ydata)
            break;
        end
        if endPoint > numel(ydata)
            endPoint = numel(ydata);
        end
    end
%     hold off
%     
%     ylabel('\boldmath Amplitude', 'Interpreter', 'Latex',...
%            'FontSize',20,'FontWeight','bold')
%     xlabel('\boldmath distance', 'Interpreter', 'Latex',...
%        'FontSize',20,'FontWeight','bold')
%     ylim([0 max(yPulsZeros)]);
%     fig = gcf;
%     fig.PaperPositionMode = 'auto';
%     fig_pos = fig.PaperPosition;
%     fig.PaperSize = [fig_pos(3) fig_pos(4)];
%     print(fig,sprintf('%s%s_windowSize-%d',filename,'_lineFit',windowSize),'-dpdf')
