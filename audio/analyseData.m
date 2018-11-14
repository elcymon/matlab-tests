function Analysis = analyseData(expData,Tests,varargin)
    if length(varargin) == 3
        sError = varargin{1};
        mError = varargin{2};
        errScale = varargin{3};
    elseif ~isempty(varargin) && length(varargin) ~= 3
        display('Invalid Function Call');
        return
    end
    Iters = 30;
    
    if isempty(varargin)
        Iters = size(expData,2);
    end
    
    PulsFitHeader = {'Pitch,Trough','%+ve (Means)',...
                            '%+ve LineFit','%+ve LinearReg',...
                            '%+ve TVRegDiff'};
    PulsFitTests = Tests;

    PulsFilterData = cell(size(PulsFitTests,1)+1,size(PulsFitHeader,2));
    PulsFilterData(1,:) = PulsFitHeader;
    for Si = 1:size(PulsFitTests,1)
        PulsFilterData{Si+1,1} = sprintf('%i,%i',PulsFitTests{Si,1},PulsFitTests{Si,2});
    end
%     PulsFilterData(2:end,1:2) = PulsFitTests;
    
    MeansFilter = NaN(size(PulsFilterData,1)-1,Iters);%number of rows equal test cases each done Iters time (columns)
    LineFitFilter = NaN(size(PulsFilterData,1)-1,Iters);
    LinRegFilter = NaN(size(PulsFilterData,1)-1,Iters);
    TVRegDiffFilter = NaN(size(PulsFilterData,1)-1,Iters);

    for ii = 1:Iters
        
        if isempty(varargin)
            soundData = expData{1,ii};
            xdata = expData{2,ii};
            tdata = expData{3,ii};
        else
            soundData = expData{1} + errScale*sError .* randn(size(expData{1})) + mError;
            xdata = expData{2};
            tdata = expData{3};
        end
        
        
        
        for i1 = 1:size(MeansFilter,1)
            w = PulsFitTests{i1,1};
            step = PulsFitTests{i1,2};

            stArt = 1;
            prevstArt = stArt;
            eNd = w;

            yPulsZeros = NaN(size(soundData));
            yPulsmeans = NaN(1,ceil(numel(soundData)/(step+w))-1);
            yPulsmax = NaN(1,ceil(numel(soundData)/(step+w))-1);
            j = 1;
%             i = 1;
        %     hold on
%             iw = w;
            bluePuls = 0;
            redPuls = 0;
            
            blueLineFit = 0;
            redLineFit = 0;
            
            redlineRegEq = 0;
            bluelineRegEq = 0;
            
%             Blue = 0;
%             Red = 0;

            blueTVRegDiff = 0;
            redTVRegDiff = 0;
            while eNd <= numel(soundData)
                if isempty(soundData(stArt:eNd))
                    break;
                end
                yPulsZeros(stArt:eNd) = soundData(stArt:eNd);
                yPulsmeans(j) = mean(soundData(stArt:eNd));

%                 lineColor = '-b';
                if j > 1
                    if yPulsmeans(j-1) < yPulsmeans(j)
%                         lineColor = '-r';
                        redPuls = redPuls + 1;
        %                 Red = plot(xPuls(j-1:j),yPulsmeans(j-1:j),lineColor);
                    else
                        bluePuls = bluePuls + 1;
        %                 Blue = plot(xPuls(j-1:j),yPulsmeans(j-1:j),lineColor);
                    end
                    ttdata = tdata(prevstArt:eNd);
                    txdata = xdata(prevstArt:eNd);
                    tyPulsZeros = yPulsZeros(prevstArt:eNd);
                    txdata = txdata(~isnan(tyPulsZeros));
                    ttdata = ttdata(~isnan(tyPulsZeros));
                    tyPulsZeros = tyPulsZeros(~isnan(tyPulsZeros));
                    p = polyfit(txdata,tyPulsZeros,1);
                    if p(1) > 0
                        redLineFit = redLineFit + 1;
        %                 plot(xdata(prevstArt:eNd),polyval(p,xdata(prevstArt:eNd)),'-r')
                    else
                        blueLineFit = blueLineFit + 1;
        %                 plot(xdata(prevstArt:eNd),polyval(p,xdata(prevstArt:eNd)),'-b')
                    end
                    myX = ttdata;
                    myY = tyPulsZeros;
                    
%                     linRegFilter is based on Linear Regression
%                     equation found in https://tinyurl.com/y7r6e4ej
                    
                    mylineGrad = (numel(myX) * sum(myX .* myY) - sum(myX) * sum(myY)) /...
                            (numel(myX) * sum(myX .^2) - (sum(myX)) ^ 2);
                    if mylineGrad > 0
                        redlineRegEq = redlineRegEq + 1;
                    else
                        bluelineRegEq = bluelineRegEq + 1;
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
            LinRegFilter(i1,ii) = bluelineRegEq / (redlineRegEq + bluelineRegEq) * 100;
            TVRegDiffFilter(i1,ii) = blueTVRegDiff/(redTVRegDiff+blueTVRegDiff) * 100;

            display(sprintf('(%03i/%03i):%.2f',ii,Iters,i1/numel(1:size(MeansFilter,1)) * 100))
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
    LineRegFilterCells = arrayfun(@(MN,STD) sprintf('%.2f $%s$ %.2f',MN,'\pm',STD),mean(LinRegFilter,2),std(LinRegFilter,0,2),...
                                    'UniformOutput',false);
    TVRegDiffCells = arrayfun(@(MN,STD) sprintf('%.2f $%s$ %.2f',MN,'\pm',STD),mean(TVRegDiffFilter,2),std(TVRegDiffFilter,0,2),...
                                    'UniformOutput',false);
                                
    PulsFilterData(2:end,2) = MeansFilterCells;
    PulsFilterData(2:end,3) = LineFitFilterCells;
    PulsFilterData(2:end,4) = LineRegFilterCells;
    PulsFilterData(2:end,5) = TVRegDiffCells;

    Analysis = PulsFilterData;
end