function plotModels(varargin)
    if len(varargin) == 4
        mError = varargin{1};
        sError = varargin{2};
        pureSignal = varargin{3};
        experimentData = varargin{4};
    elseif len(varargin) == 0
        experimentData = readExperimentData();
        [tModel,xModel,pureSignal,mError,sError,A0nAlpha]...
            = developSoundModel(experimentData);
    else
        display('Invalid function call')
    end
%     mError = -0.8989;
%     sError = 20.5048;


    figure(1)
    % c = sum(cellfun(@numel, experimentData(1,:)));
    expDataY = cell2mat(experimentData(1,:)');
    expDataX = cell2mat(experimentData(2,:)');
    [expDataX, expDataOrder] = sort(expDataX);
    expDataY = expDataY(expDataOrder,:);
    % for i = 1:size(experimentData,2)
    %     plot(experimentData{2,i},...
    %         experimentData{1,i},'Color',[0.8,0.8,0.0],...
    %         'Marker','+','DisplayName','Experiment Data')
    % end

    ylabel('Sound Intensity')
    xlabel('Distance in metres')

    signal100pct = pureSignal + 1.0 * sError .* randn(size(pureSignal)) + mError;
    signal100pct(signal100pct < 0) = 0;
    p100 = plot(xModel,signal100pct,'bo','DisplayName','100%');
    hold on

    signal50pct = pureSignal + 0.50 * sError .* randn(size(pureSignal)) + mError;
    signal50pct(signal50pct < 0) = 0;
    p50 = plot(xModel,signal50pct,'ro','DisplayName','50%');

    signal25pct = pureSignal + 0.250 * sError .* randn(size(pureSignal)) + mError;
    signal25pct(signal25pct < 0) = 0;
    p25 = plot(xModel,signal25pct,'go','DisplayName','25%');

    pExp = plot(expDataX,expDataY,'LineWidth',1,...
        'DisplayName','Experiment Data');

    pExp.Color = [0.2,0.2,0,0.70];

    p0 = plot(xModel,pureSignal,'-k','LineWidth',2,'DisplayName','Pure');

    % grid on
    ylim([0 Inf])
    hold off
    legend('show')
    % legend({'Experiment Data','100%','50%','25%','Pure'})
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    print(fig,'line-modelled-data','-dpdf')

    % working on the pure signal to extract the gradient magnitudes
    figure(2)
    % ON INSTANTANEOUS DATA
    grads = diff(fliplr(pureSignal));
    xdistance = linspace(max(xModel),min(xModel),numel(grads));
    plot(xdistance,grads, 'LineWidth',2),ylim([0 Inf])
    ylabel('Magnitude of Gradient')
    xlabel('Distance in metres')

    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    print(fig,'gradient-magnitude-instantaneous-pure','-dpdf')

    figure(3)
    % ON 40 QSIZE
    xPts = 1:40:numel(pureSignal);
    signalChunks = NaN(size(xPts));

    for i = 1:numel(xPts)-1
        signalChunks(i) = mean(pureSignal(xPts(i):xPts(i+1)));
    end

    signalChunks = fliplr(signalChunks);
    grads40 = diff(signalChunks);
    xdistance40 = linspace(max(xModel), min(xModel), numel(grads40));

    plot(xdistance40,grads40,'LineWidth',2,...
        'DisplayName','QSize = 40'),ylim([0 Inf])
    ylabel('Magnitude of Gradient')
    xlabel('Distance in metres')

    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    print(fig,'gradient-magnitude-40-pure','-dpdf')
end