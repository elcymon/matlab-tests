% Experiments on different filtering approaches
filename = '20180909231249datagoexp1a';
xy = csvread(strcat(filename,'.txt'));
xdata = xy(:,2);
ydata = xy(:,end);
% Get signal model fit
[pSignal,mError,sError] = FitSoundModel(xdata,ydata,[200 1], 48.1824);
% Generate noisy signal model based on pure signal, mean and std
t = xy(:,1);
hz = 40;
PulsFitHeader = {'Pitch','Trough','%+ve (Means)',...
                        '%+ve LineFit','%+ve TVRegDiff'};
PulsFitTests = {10,0;10,10;20,0;10,20;30,0;10,30;...
                             20,20;40,0;20,40;60,0;
                             40,40;80,0;40,80;120,0};

PulsFilterData = cell(size(PulsFitTests,1)+1,size(PulsFitHeader,2));
PulsFilterData(1,:) = PulsFitHeader;
PulsFilterData(2:end,1:2) = PulsFitTests;
Iters = 30;
MeansFilter = NaN(size(PulsFilterData,1)-1,Iters);%number of rows equal test cases each done Iters time (columns)
LineFitFilter = NaN(size(PulsFilterData,1)-1,Iters);
TVRegDiffFilter = NaN(size(PulsFilterData,1)-1,Iters);

for ii = 1:Iters
    noisyModel = pSignal + 0.25*sError .* randn(size(pSignal)) + mError;
    soundData = noisyModel;
    for i1 = 1:size(MeansFilter,1)
        w = PulsFilterData{i1+1,1};
        step = PulsFilterData{i1+1,2};

        stArt = 1;
        prevstArt = stArt;
        eNd = w;

        yPulsZeros = NaN(size(soundData));
        yPulsmeans = NaN(1,ceil(numel(soundData)/(step+w))-1);
        yPulsmax = NaN(1,ceil(numel(soundData)/(step+w))-1);
        j = 1;
        i = 1;
    %     hold on
        iw = w;
        bluePuls = 0;
        redPuls = 0;
        blueLineFit = 0;
        redLineFit = 0;
        Blue = 0;
        Red = 0;

        blueTVRegDiff = 0;
        redTVRegDiff = 0;
        while eNd <= numel(soundData)
            if isempty(soundData(stArt:eNd))
                break;
            end
            yPulsZeros(stArt:eNd) = soundData(stArt:eNd);
            yPulsmeans(j) = mean(soundData(stArt:eNd));

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
                txdata = xdata(prevstArt:eNd);
                tyPulsZeros = yPulsZeros(prevstArt:eNd);
                txdata = txdata(~isnan(tyPulsZeros));
                tyPulsZeros = tyPulsZeros(~isnan(tyPulsZeros));
                p = polyfit(txdata,tyPulsZeros,1);
                if p(1) > 0
                    redLineFit = redLineFit + 1;
    %                 plot(xdata(prevstArt:eNd),polyval(p,xdata(prevstArt:eNd)),'-r')
                else
                    blueLineFit = blueLineFit + 1;
    %                 plot(xdata(prevstArt:eNd),polyval(p,xdata(prevstArt:eNd)),'-b')
                end


    %             Computing grad using TVRegDiff and counting the positive
    %             gradients returned
    %             u = TVRegDiff(            data,    iter,alph,u0,scale,ep,dx,plotflag,diagflag )
                
                tvRegDiffgrads = TVRegDiff(tyPulsZeros,20, 10, [], [],  [],[],  0,      0);
                tvRegDiffgrads = sign(tvRegDiffgrads);
                blueTVRegDiff = blueTVRegDiff + sum(tvRegDiffgrads==-1);
                redTVRegDiff = redTVRegDiff + sum(tvRegDiffgrads==1);
            end
            yPulsmax(j) = max(soundData(stArt:eNd));
            if eNd == numel(soundData)
                break;
            end
            prevstArt = stArt;
            stArt = eNd + step + 1;
            eNd = stArt + w - 1;
            if eNd > numel(soundData)
                eNd = numel(soundData);
            end
    %         display(sprintf('%i',j))
            j = j + 1;
        end
    %     hold off
    %     pause
        
        MeansFilter(i1,ii) = bluePuls/(redPuls+bluePuls) * 100;
        LineFitFilter(i1,ii) = blueLineFit/(redLineFit+blueLineFit) * 100;
        TVRegDiffFilter(i1,ii) = blueTVRegDiff/(redTVRegDiff+blueTVRegDiff) * 100;
        
        display(sprintf('%3i:%.2f',ii,i1/numel(1:size(MeansFilter,1)) * 100))
    end
    
end
% MeansFilterCells = arrayfun(@(MN,STD) sprintf('%.2f %c%.2f',MN,char(177),STD),mean(MeansFilter,2),std(MeansFilter,0,2),...
%                                 'UniformOutput',false);
% LineFitFilterCells = arrayfun(@(MN,STD) sprintf('%.2f %c%.2f',MN,char(177),STD),mean(LineFitFilter,2),std(LineFitFilter,0,2),...
%                                 'UniformOutput',false);
% TVRegDiffCells = arrayfun(@(MN,STD) sprintf('%.2f %c%.2f',MN,char(177),STD),mean(TVRegDiffFilter,2),std(TVRegDiffFilter,0,2),...
%                                 'UniformOutput',false);
MeansFilterCells = arrayfun(@(MN,STD) sprintf('%.2f $%s$ %.2f',MN,'\pm',STD),mean(MeansFilter,2),std(MeansFilter,0,2),...
                                'UniformOutput',false);
LineFitFilterCells = arrayfun(@(MN,STD) sprintf('%.2f $%s$ %.2f',MN,'\pm',STD),mean(LineFitFilter,2),std(LineFitFilter,0,2),...
                                'UniformOutput',false);
TVRegDiffCells = arrayfun(@(MN,STD) sprintf('%.2f $%s$ %.2f',MN,'\pm',STD),mean(TVRegDiffFilter,2),std(TVRegDiffFilter,0,2),...
                                'UniformOutput',false);
PulsFilterData(2:end,3) = MeansFilterCells;
PulsFilterData(2:end,4) = LineFitFilterCells;
PulsFilterData(2:end,5) = TVRegDiffCells;



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
%     LineFitFilterData = cell(22,6);
%     LineFitFilterData = cell(13,6);
%     LineFitFilterData(1,:) = {'Window Size','Shift','+grad','-grad','%+ve','Mean Time'};
% %     LineFitFilterData(2:end,1:2) = {20 10; 20 20;
% %                                     30 10; 30 20; 30 30;
% %                                     40 10; 40 20; 40 30; 40 40;
% %                                     60 10; 60 30; 60 50; 60 60;
% %                                     80 10; 80 40; 80 50; 80 80;
% %                                     120 10;120 50; 120 90; 120 120};
%     LineFitFilterData(2:end,1:2) = {20 10; 20 20; 30 10; 30 30;
%                                     40 10; 40 40; 60 10; 60 60;
%                                     80 40; 80 80; 120 10; 120 120};
%     for i2 = 2:size(LineFitFilterData,1)
%         windowSize = LineFitFilterData{i2,1};
%         shift = LineFitFilterData{i2,2};
%         startPoint = 1;
%         endPoint = windowSize;
%         yPoints = NaN(size(ydata));
%         blueLine = 0;
%         redLine = 0;
%         tot_t = 0;%time taken to do polyfit
%         fitCount = 0;%number of polyfit performed
%         while endPoint <= numel(ydata)
%             if isempty(ydata(startPoint:endPoint))
%                 break;
%             end
%             strt = clock;
%             p = polyfit(xdata(startPoint:endPoint),ydata(startPoint:endPoint),1);
%             fnsh = clock;
%             tot_t = tot_t + etime(fnsh,strt);
%             fitCount = fitCount + 1;
%             yPoints(startPoint:endPoint) = polyval(p,xdata(startPoint:endPoint));
% 
%             lineColor = '-b';
%             if p(1) > 0
%                 lineColor = '-r';
%                 redLine = redLine + 1;
%     %             Red = plot(xdata(startPoint:endPoint),yPoints(startPoint:endPoint),lineColor);
%             else
%                 blueLine = blueLine + 1;
%     %             Blue = plot(xdata(startPoint:endPoint),yPoints(startPoint:endPoint),lineColor);
%             end
% 
% 
%             startPoint = startPoint + shift;
%             endPoint = startPoint + windowSize - 1;
%             if endPoint == numel(ydata)
%                 break;
%             end
%             if endPoint > numel(ydata)
%                 endPoint = numel(ydata);
%             end
%         end
%         LineFitFilterData{i2,3} = blueLine;
%         LineFitFilterData{i2,4} = redLine;
%         LineFitFilterData{i2,5} = blueLine / (redLine + blueLine) * 100;
%         LineFitFilterData{i2,6} = tot_t/fitCount;
%     %     legend([Blue,Red],{num2str(blueLine/(redLine+blueLine)),num2str(redLine/(redLine+blueLine))})
%     %     hold off
%     %     
%     %     ylabel('\boldmath Amplitude', 'Interpreter', 'Latex',...
%     %            'FontSize',20,'FontWeight','bold')
%     %     xlabel('\boldmath distance', 'Interpreter', 'Latex',...
%     %        'FontSize',20,'FontWeight','bold')
%     %     ylim([0 max(yPulsZeros)]);
%     %     fig = gcf;
%     %     fig.PaperPositionMode = 'auto';
%     %     fig_pos = fig.PaperPosition;
%     %     fig.PaperSize = [fig_pos(3) fig_pos(4)];
%     %     print(fig,sprintf('%s%s_windowSize-%d',filename,'_lineFit',windowSize),'-dpdf')
%     end