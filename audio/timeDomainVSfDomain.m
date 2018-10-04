% Load time data and plot together with FFT data
filename = '20180609103950data_omnimicwhitenoise_wav';
dataStruct = load(strcat(filename,'.mat'));
figure(1)
    plot(flipud(dataStruct.data))
    ylabel('\boldmath Amplitude', 'Interpreter', 'Latex',...
           'FontSize',20,'FontWeight','bold')
    xlabel('\boldmath Sample', 'Interpreter', 'Latex',...
       'FontSize',20,'FontWeight','bold')
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    print(fig,strcat(filename,'_instantaneous'),'-dpdf')
    
figure(2)
    plot(flipud(abs(dataStruct.data)))
    ylabel('\boldmath Amplitude', 'Interpreter', 'Latex',...
           'FontSize',20,'FontWeight','bold')
    xlabel('\boldmath Sample', 'Interpreter', 'Latex',...
       'FontSize',20,'FontWeight','bold')
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    print(fig,strcat(filename,'_abs'),'-dpdf')
    
figure(3)
    audio_file = '20180609103950data_omnimicwhitenoise';
    xy = csvread(strcat(audio_file,'.txt'));
    xdata = xy(:,2);
    ydata = xy(:,end);
    plot(xdata,ydata)
    ylabel('\boldmath Amplitude', 'Interpreter', 'Latex',...
           'FontSize',20,'FontWeight','bold')
    xlabel('\boldmath Distance', 'Interpreter', 'Latex',...
       'FontSize',20,'FontWeight','bold')
    ylim([0 max(ydata)]);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    print(fig,strcat(filename,'_freq'),'-dpdf')

figure(4)
% rms
    Sqrs = flipud(dataStruct.data).^2;
    fs = 44100;
    Step = fs/10;
    stArt = 1;
    eNd = Step;
    rmsValues = NaN(1,ceil(numel(Sqrs)/eNd));
    i = 1;
    while eNd <= numel(Sqrs)
        rmsValues(i) = (mean(Sqrs(stArt:eNd)))^(0.5);
        if eNd == numel(Sqrs)
            break;
        end
        i = i + 1;
        stArt = eNd + 1;
        eNd =  eNd + Step;
        if eNd > numel(Sqrs)
            eNd = numel(Sqrs);
        end
        display(sprintf('%d %d',eNd,numel(Sqrs)))
    end
    plot(rmsValues)
    ylabel('\boldmath RMS', 'Interpreter', 'Latex',...
           'FontSize',20,'FontWeight','bold')
    xlabel('\boldmath Sample', 'Interpreter', 'Latex',...
       'FontSize',20,'FontWeight','bold')
    ylim([0 max(rmsValues)]);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    print(fig,strcat(filename,'_rms'),'-dpdf')