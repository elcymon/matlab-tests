function figID = plotModelsV2(sError1,experimentData,sError,mError,figID)
    [~,xModel,pureSignal,~,~,~]...
            = developSoundModel(experimentData);
    figID = figID + 1;
    figure(figID)
    expDataY = cell2mat(experimentData(1,:)');
    expDataX = cell2mat(experimentData(2,:)');
    [expDataX, expDataOrder] = sort(expDataX);
    expDataY = expDataY(expDataOrder,:);
    
    ylabel('Sound Intensity')
    xlabel('Distance in metres')

    signal100pct = normrnd(pureSignal, pureSignal .* ...
        normrnd(mError,sError,size(pureSignal)));
    signal100pct(signal100pct < 0) = 0;
    p100 = plot(xModel,signal100pct,'b','LineWidth',0.1,...
        'DisplayName','100%');
    hold on

    signal50pct = normrnd(pureSignal, 0.5 * pureSignal .* ...
        normrnd(mError,sError,size(pureSignal)));
    signal50pct(signal50pct < 0) = 0;
    
    p50 = plot(xModel,signal50pct,'r','LineWidth',0.1,...
        'DisplayName','50%');

    signal25pct = normrnd(pureSignal, 0.25 * pureSignal .* ...
        normrnd(mError,sError,size(pureSignal)));
    signal25pct(signal25pct < 0) = 0;
    
    p25 = plot(xModel,signal25pct,'g','LineWidth',0.1,...
        'DisplayName','25%');

    pExp = plot(expDataX,expDataY,'LineWidth',0.1,...
        'DisplayName','Experiment Data');
    
    pExp.Color = [0.2,0.2,0,0.50];

    p0 = plot(xModel,pureSignal,'-k','LineWidth',1,'DisplayName','Pure');

    % grid on
    ylim([0 Inf])
    hold off
    legend('show')
    
    savePlot(gcf,'line-modelled-data-updated')
    
    figID = figID + 1;
    figure(figID)
    plot(xModel,signal100pct,'b','LineWidth',0.1,...
        'DisplayName','100%');
    axis square
    ylim([0 500])
    ylabel('Sound Intensity')
    xlabel('Distance in metres')
    legend('show')
    savePlot(gcf,'100%-noise')
    
    figID = figID + 1;
    figure(figID)
    plot(cell2mat(experimentData(2,1)),cell2mat(experimentData(1,1)),'LineWidth',0.1,...
        'DisplayName','Experiment Data Sample');
    axis square
    ylim([0 500])
    ylabel('Sound Intensity')
    xlabel('Distance in metres')
    legend('show')
    savePlot(gcf,'expData')
    
    figID = figID + 1;
    figure(figID)
    ylabel('Sound Intensity')
    xlabel('Distance in metres')

    signal100pct = pureSignal + 1.0 * sError1 .* randn(size(pureSignal));
    signal100pct(signal100pct < 0) = 0;
    p100 = plot(xModel,signal100pct,'b','DisplayName','100%');
    hold on

    signal50pct = pureSignal + 0.50 * sError1 .* randn(size(pureSignal));
    signal50pct(signal50pct < 0) = 0;
    p50 = plot(xModel,signal50pct,'r','DisplayName','50%');

    signal25pct = pureSignal + 0.250 * sError1 .* randn(size(pureSignal));
    signal25pct(signal25pct < 0) = 0;
    p25 = plot(xModel,signal25pct,'g','DisplayName','25%');

    pExp = plot(expDataX,expDataY,'LineWidth',1,...
        'DisplayName','Experiment Data');

    pExp.Color = [0.2,0.2,0,0.50];

    p0 = plot(xModel,pureSignal,'-k','LineWidth',2,'DisplayName','Pure');

    % grid on
    ylim([0 Inf])
    hold off
    legend('show')
    
    savePlot(gcf,'line-modelled-data')

    % working on the pure signal to extract the gradient magnitudes
    figID = figID + 1;
    figure(figID)
    % ON INSTANTANEOUS DATA
    grads = diff(fliplr(pureSignal)) ./ diff(fliplr(xModel));
    xdistance = linspace(max(xModel),min(xModel),numel(grads));
    plot(xdistance,grads, 'LineWidth',2)
    yMax = 0;
    yMin = 0;
    if max(grads) > 0
        yMax = Inf;
    end
    if min(grads) < 0
        yMin = -Inf;
    end
    ylim([yMin yMax])
    ylabel('Gradient (dy/dx)')
    xlabel('Distance in metres')

    savePlot(gcf,'gradient-magnitude-instantaneous-pure')

    figID = figID + 1;
    figure(figID)
    % ON 40 QSIZE
    xPts = 1:40:numel(pureSignal);
    signalChunks = NaN(size(xPts));
    xChunks = NaN(size(xPts));

    for i = 1:numel(xPts)-1
        signalChunks(i) = mean(pureSignal(xPts(i):xPts(i+1)));
        xChunks(i) = mean(xModel(xPts(i):xPts(i+1)));
    end

    signalChunks = fliplr(signalChunks);
    xChunks = fliplr(xChunks);
    
    grads40 = diff(signalChunks) ./ diff(xChunks);
    xdistance40 = linspace(max(xChunks), min(xChunks), numel(grads40));

    plot(xdistance40,grads40,'LineWidth',2,...
        'DisplayName','QSize = 40')
    yMax = 0;
    yMin = 0;
    if max(grads40) > 0
        yMax = Inf;
    end
    if min(grads40) < 0
        yMin = -Inf;
    end
    ylim([yMin yMax])
    ylabel('Gradient (dy/dx)')
    xlabel('Distance in metres')

    savePlot(gcf,'gradient-magnitude-40-pure')
    
%     Combined plot of both gradients
    figID = figID + 1;
    figure(figID)
    plot(xdistance,grads, 'LineWidth',2,...
        'DisplayName','QSize = 1')
    yMax = 0;
    yMin = 0;
    if max([grads40,grads]) > 0
        yMax = Inf;
    end
    if min([grads40,grads]) < 0
        yMin = -Inf;
    end
    ylim([yMin yMax])
    hold on
    plot(xdistance40,grads40,'LineWidth',2,...
        'DisplayName','QSize = 40')
    ylabel('Gradient (dy/dx)')
    xlabel('Distance in metres')
    hold off
    
    legend('show')
    savePlot(gcf,'gradient-magnitude-40-vs-1-pure')
    
end