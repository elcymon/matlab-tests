% % rpm_files = {'data.txt','data_rpmVSpwm1.txt','data_rpmVSpwm2.txt','data_rpmVSpwm3.txt'};
% rpm_files = {'20180418115624data_1hz.txt','20180418121135data_5hz.txt','20180418122128data_10hz.txt'};
%  figure(1)
% for f = 1:length(rpm_files)
%     disp(rpm_files{f})
%     fileID = fopen(rpm_files{f},'r');
%     A = textscan(fileID,'%f,%f,%f,%f,%f,%f,%f,%f,%f','HeaderLines',2);
%     fclose(fileID);
% 
%     pwm = A{1};
%     rps = A{2};
%     hdg = A{6};
% 
%     [~, x] = unique(pwm,'legacy');
% 
%     st = 1;
%     mean_rps = NaN(size(x));
%     ppwm = NaN(size(x));
%     p = 1;
% 
%     for i = x'
%         %disp(pwm(i));
%         ppwm(p) = pwm(i);
%         mean_rps(p) = mean(rps(st:i));
%         if ppwm(p) < 1500
%             mean_rps(p) = - mean_rps(p);
%         end
%         if abs(ppwm(p)-1500) < 30
%             mean_rps(p) = 0.0;
%         end
%         st = i+1;
%         p = p + 1;
%     end
%      rps(abs(pwm - 1500) < 30) = 0.0;
%      rps(pwm < 1500) = - rps(pwm < 1500);
%      plot(pwm,rps, 'o')
% %      plot(ppwm,mean_rps,'LineWidth',1.5)
%      hold on
% end
% % legend('1hz','5hz','10hz','Location','best')
% legend('1hz','5hz','10hz','Location','best')
%  ylabel('rps')
%  xlabel('pwm signal')
% 
% 
% ax = gca;
% outerpos = ax.OuterPosition;
% ti = ax.TightInset; 
% left = outerpos(1) + ti(1);
% bottom = outerpos(2) + ti(2);
% ax_width = outerpos(3) - ti(1) - ti(3);
% ax_height = outerpos(4) - ti(2) - ti(4);
% % ax.Position = [left bottom ax_width ax_height];
% fig = gcf;
% fig.PaperPositionMode = 'auto';
% fig_pos = fig.PaperPosition;
% fig.PaperSize = [fig_pos(3) fig_pos(4)];
% print(fig,'20180418rpsVSpwm','-dpdf')
% hold off
% % 
% fileID1 = fopen('data_test1.txt','r');
% data_test1 = textscan(fileID1,'%f,%f,%f,%f,%f,%f','HeaderLines',2);
% hdg_test1 = data_test1{6};
% fileID2 = fopen('data_test2.txt','r');
% data_test2 = textscan(fileID2,'%f,%f,%f,%f,%f,%f','HeaderLines',2);
% hdg_test2 = data_test2{6};
imu_file = '20180430163701data_inbuiltIMU_test1' ;
fileID3 = fopen(strcat(imu_file,'.txt'),'r');
data_test3 = textscan(fileID3,'%f,%f,%f,%f,%f,%f,%f,%f,%f','HeaderLines',2);
hdg_test3 = data_test3{6};
imu_test3 = data_test3{8};
imu_test4 = data_test3{7};
% imu_test4 = mod((imu_test3 + 140),360);
figure(2)
t = data_test3{9};
t = t - t(1);
ax1 = subplot(3,1,1);
ax2 = subplot(3,1,2);
ax3 = subplot(3,1,3);
plot(ax1,t,hdg_test3);
ax1.XGrid = 'on';
ax1.XMinorGrid = 'on';
ax1.YGrid = 'on';
ax1.YMinorGrid = 'on';
title(ax1,'compass heading in degrees')
xlabel(ax1,'time in seconds')
xlim(ax1,[0,350])
ylim(ax1,[-180,180])

plot(ax2,t,imu_test3);
ax2.XGrid = 'on';
ax2.XMinorGrid = 'on';
ax2.YGrid = 'on';
ax2.YMinorGrid = 'on';
title(ax2,'IMU heading in degrees (raw)')
xlabel(ax2,'time in seconds')
xlim(ax2,[0,350])
ylim(ax2,[-180,180])

plot(ax3,t,imu_test4);
ax3.XGrid = 'on';
ax3.XMinorGrid = 'on';
ax3.YGrid = 'on';
ax3.YMinorGrid = 'on';
title(ax3,'IMU heading in degrees')
xlabel(ax3,'time in seconds')
xlim(ax3,[0,350])
ylim(ax3,[0,360])
% grid on
% legend('compass','imu_test3','imu_test4','New Encoder3','Location','northwest')
% ylabel('compass heading in degrees')
% xlabel('time in seconds')
% ylim([0,360])
% ax = gca;
% outerpos = ax.OuterPosition;
% ti = ax.TightInset; 
% left = outerpos(1) + ti(1);
% bottom = outerpos(2) + ti(2);
% ax_width = outerpos(3) - ti(1) - ti(3);
% ax_height = outerpos(4) - ti(2) - ti(4);
% ax.Position = [left bottom ax_width ax_height];
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,imu_file,'-dpdf')