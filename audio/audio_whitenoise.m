if true
    audio_file = '20180909231249datagoexp1a';
    xy = csvread(strcat(audio_file,'.txt'));
    xdata = xy(:,2);
    ydata = xy(:,end);
    % % https://www.nde-ed.org/EducationResources/CommunityCollege/Ultrasonics/Physics/attenuation.php
    % Just assuming in this case that A0 and alpha = a are unknown.
%     ndeed = @(x,xdata)x(1)*(exp(-x(2)*xdata)) + x(3);
%     x0 = [1000,0.1,0];%[200000000,0]
%     ndeed = @(x,xdata)x(1)*(exp(-x(2)*(xdata-x(3)))) + 48.1824;
%     ndeed = @(x,xdata)x(1)*(exp(-x(2)*(xdata))) + 48.1824;
    ndeed = @(x,xdata)x(1)*(exp(-x(2)*(xdata))) + 48.1824;
    x0 = [200,1];%[200000000,0]
    x = lsqcurvefit(ndeed,x0,xdata,ydata);
    dists = linspace(0,15);
    A0 = x(1);
    Alpha = x(2);
    Ae = 48.1824;%x(3);%
   figure(2)
   plot(xdata,ydata,'go',dists,ndeed(x,dists),'b-',[0 25],[48.1824 48.1824],'r-')
   set(gca,'fontsize',15)
   ylabel('\boldmath $$A = A_0 e^{-\alpha d} + A_e $$', 'Interpreter', 'Latex',...
       'FontSize',20,'FontWeight','bold')
    xlabel('\boldmath $$d$$ metres', 'Interpreter', 'Latex',...
       'FontSize',20,'FontWeight','bold')
    lgd = legend('ydata','Fitted curve (A)');
    lgd.FontSize = 16;
    ylim([0 max(ydata)])
    xlim([0 20])
    grid on
%     title(strcat('Fitting data to A_0 =',{' '},...
%         num2str(A0),', \alpha = ',{' '},num2str(Alpha),', A_e = ',{' '},num2str(Ae)),'FontSize',10)%,...', err = ',{' '},num2str(x(3))
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    print(fig,audio_file,'-dpdf')
    
%     figure(3)
    y_pure = ndeed(x,xdata);
%     plot(xdata,ydata,xdata,y_pure)
    
    y_err = y_pure - ydata;
    
    y_snr = snr(y_pure,y_err);
    
    y_awgn = awgn(y_pure,y_snr,'measured');
    min_err = min(y_err);
    max_err = max(y_err);
    y_uniform = y_pure + (max_err - min_err) .* rand(size(y_pure)) + min_err;
    
    y_normal = y_pure + std(y_err) .* randn(size(y_pure)) + mean(y_err);
%     plot(xdata,ydata,...
%          xdata,y_pure,...
%          xdata,y_awgn,...
%          xdata,y_uniform,...
%          xdata,y_normal);
%      
%     legend({'ydata',...
%             'ypure',...
%             'yawgn',...
%             'yuniform',...
%             'ynormal'})
% %     plot(xdata,ydata,...
% %          xdata,y_pure,...
% %          xdata,y_uniform,...
% %          xdata,y_normal);
% %      
% %     legend({'ydata',...
% %             'ypure',...
% %             'yuniform',...
% %             'ynormal'})
%     ylabel('\boldmath $$A = A_0 e^{-\alpha d} + A_e $$', 'Interpreter', 'Latex',...
%        'FontSize',13,'FontWeight','bold')
%     
%     xlabel('\boldmath $$d$$', 'Interpreter', 'Latex',...
%        'FontSize',13,'FontWeight','bold')
%     title(strcat('Fitting data to A_0 =',{' '},...
%         num2str(A0),', \alpha = ',{' '},num2str(Alpha),', A_e = ',{' '},num2str(Ae)),'FontSize',10)%,...', err = ',{' '},num2str(x(3))
%     fig2 = gcf;
%     fig2.PaperPositionMode = 'auto';
%     fig_pos = fig2.PaperPosition;
%     fig2.PaperSize = [fig_pos(3) fig_pos(4)];
%     print(fig2,strcat(audio_file,'_noisy'),'-dpdf')
    
%     figure(4)
% %     plot(xdata,ydata,...
% %          xdata,y_pure,...
% %          xdata,y_normal);
%      plot(xdata,y_normal,'go',xdata,y_pure,'b-');
%     legend({'ynormal',...
%             'ypure'})
%     ylabel('\boldmath $$A = A_0 e^{-\alpha d} + A_e $$', 'Interpreter', 'Latex',...
%        'FontSize',13,'FontWeight','bold')
%     
%     xlabel('\boldmath $$d$$', 'Interpreter', 'Latex',...
%        'FontSize',13,'FontWeight','bold')
%     title(strcat('Fitting data to A_0 =',{' '},...
%         num2str(A0),', \alpha = ',{' '},num2str(Alpha),', A_e = ',{' '},num2str(Ae)),'FontSize',10)%,...', err = ',{' '},num2str(x(3))
%     fig3 = gcf;
%     fig3.PaperPositionMode = 'auto';
%     fig_pos = fig3.PaperPosition;
%     fig3.PaperSize = [fig_pos(3) fig_pos(4)];
%     print(fig3,strcat(audio_file,'_noisy_normal'),'-dpdf')
    
%     
%     figure(5)
%     plot(xdata,ydata,...
%          xdata,y_pure,...
%          xdata,y_uniform);
%      
%     legend({'ydata',...
%             'ypure',...
%             'yuniform'})
%     ylabel('\boldmath $$A = A_0 e^{-\alpha d} + A_e $$', 'Interpreter', 'Latex',...
%        'FontSize',13,'FontWeight','bold')
%     
%     xlabel('\boldmath $$d$$', 'Interpreter', 'Latex',...
%        'FontSize',13,'FontWeight','bold')
%     title(strcat('Fitting data to A_0 =',{' '},...
%         num2str(A0),', \alpha = ',{' '},num2str(Alpha),', A_e = ',{' '},num2str(Ae)),'FontSize',10)%,...', err = ',{' '},num2str(x(3))
%     fig4 = gcf;
%     fig4.PaperPositionMode = 'auto';
%     fig_pos = fig4.PaperPosition;
%     fig4.PaperSize = [fig_pos(3) fig_pos(4)];
%     print(fig4,strcat(audio_file,'_noisy_uniform'),'-dpdf')
%     
%     figure(6)
%     plot(xdata,ydata,...
%          xdata,y_pure,...
%          xdata,y_awgn);
%      
%     legend({'ydata',...
%             'ypure',...
%             'yawgn'})
%     ylabel('\boldmath $$A = A_0 e^{-\alpha d} + A_e $$', 'Interpreter', 'Latex',...
%        'FontSize',13,'FontWeight','bold')
%     
%     xlabel('\boldmath $$d$$', 'Interpreter', 'Latex',...
%        'FontSize',13,'FontWeight','bold')
%     title(strcat('Fitting data to A_0 =',{' '},...
%         num2str(A0),', \alpha = ',{' '},num2str(Alpha),', A_e = ',{' '},num2str(Ae)),'FontSize',10)%,...', err = ',{' '},num2str(x(3))
%     fig5 = gcf;
%     fig5.PaperPositionMode = 'auto';
%     fig_pos = fig5.PaperPosition;
%     fig5.PaperSize = [fig_pos(3) fig_pos(4)];
%     print(fig5,strcat(audio_file,'_noisy_awgn'),'-dpdf')
%     
    
    
% %     Filtering Data to reduce noise   yfiltnorm = arrayfun(@(i) mean(y_normal(i:i+n-1)),1:n:length(y_normal)-n+1);
    Step = 10;
    chunkSize=1:Step:100;
    T = cell(3,length(chunkSize)+1);
    T(:,1) = {'Chunk Size';'ydata';'ynormal'};
    T(1,2:end) = num2cell(chunkSize);
    
    for n = chunkSize
        ydatafilt = arrayfun(@(i) mean(ydata(i:i+n-1)),1:n:length(ydata)-n+1);
        ynormfilt = arrayfun(@(i) mean(y_normal(i:i+n-1)),1:n:length(y_normal)-n+1);
        
        
        ydatadiff = diff(ydatafilt);
        ynormdiff = diff(ynormfilt);
        
        ydatasign = sign(ydatadiff);
        ynormsign = sign(ynormdiff);
        
        ydataminus = ydatasign(ydatasign < 0);
        ynormminus = ynormsign(ynormsign < 0);
        
        ydatazero = ydatasign(ydatasign == 0);
        ynormzero = ynormsign(ynormsign == 0);
        
        ydataplus = ydatasign(ydatasign > 0);
        ynormplus = ynormsign(ynormsign > 0);
        
        xx = n + 1;
        if n >=Step
            xx = fix(n/Step)+2;
            
        end
        T{2,xx} = [numel(ydataminus)/numel(ydatadiff),...
                    numel(ydatazero)/numel(ydatadiff),...
                    numel(ydataplus)/numel(ydatadiff)];
        T{3,xx} = [numel(ynormminus)/numel(ydatadiff),...
                    numel(ynormzero)/numel(ydatadiff),...
                    numel(ynormplus)/numel(ynormdiff)];
    end
    
    windowSize=1:10;
    T1 = cell(3,length(chunkSize)+1);
    T1(:,1) = {'Window Size';'ydata';'ynormal'};
    T1(1,2:end) = num2cell(windowSize);
    
    for n = windowSize
        b = (1/n)*ones(1,n);
        ydatafilt1 = filter(b,1,ydata);
        ynormfilt1 = filter(b,1,y_normal);
        
        ydatadiff1 = diff(ydatafilt1);
        ynormdiff1 = diff(ynormfilt1);
        
        ydatasign1 = sign(ydatadiff1);
        ynormsign1 = sign(ynormdiff1);
        
        ydataminus1 = ydatasign1(ydatasign1 < 0);
        ynormminus1 = ynormsign1(ynormsign1 < 0);
        
        ydatazero1 = ydatasign1(ydatasign1 == 0);
        ynormzero1 = ynormsign1(ynormsign1 == 0);
        
        ydataplus1 = ydatasign1(ydatasign1 > 0);
        ynormplus1 = ynormsign1(ynormsign1 > 0);
        
        
        
        T1{2,n+1} = [numel(ydataminus1)/numel(ydatadiff1),...
                    numel(ydatazero1)/numel(ydatadiff1),...
                    numel(ydataplus1)/numel(ydatadiff1)];
        T1{3,n+1} = [numel(ynormminus1)/numel(ydatadiff1),...
                    numel(ynormzero1)/numel(ydatadiff1),...
                    numel(ynormplus1)/numel(ynormdiff1)];
    end
end