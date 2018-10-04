if false
    audio_file = '20180425072307data15m_1m_500hz';
    file_20180425063959data1m_5m_500hz = [405,1158;
                                        1797,2701;
                                        3346,4283;
                                        4927,5835;
                                        6451,7376];


    file_20180425064556data5m_1m_500hz = [213,1055;
                                        1832,2701;
                                        3315,4186;
                                        4799,5660;
                                        6223,7030];
    file_20180425065156data1m_15m_10khz = [317,1061;
                                            1667,2653;
                                            3397,4306;
                                            4995,5944;
                                            6735,7695;
                                            8429,9401;
                                            10192,11169;
                                            12019,12961;
                                            13647,14629;
                                            15378,16342;
                                            17006,17994;
                                            18663,19550;
                                            20164,21140;
                                            21896,22847;
                                            23550,24531];
    file_20180425070657data15m_1m_10khz = [310,1037;
                                            1612,2397;
                                            2984,3865;
                                            4449,5214;
                                            5767,6605;
                                            7221,8045;
                                            8673,9452;
                                            10047,10930;
                                            11699,12566;
                                            13230,14077;
                                            14748,15632;
                                            16248,17087;
                                            17862,18705;
                                            19256,20054;
                                            20684,21479];
    file_20180425072307data15m_1m_500hz = [351,1266;
                                            1987,2910;
                                            3441,4350;
                                            4903,5854;
                                            6392,7330;
                                            8216,9162;
                                            10088,10960;
                                            11491,12415;
                                            13063,13956;
                                            14649,15547;
                                            16545,17436;
                                            17995,18870;
                                            19454,20332;
                                            21010,21893;
                                            22576,23492];
    locs = file_20180425072307data15m_1m_500hz;
    file = fopen(strcat(audio_file,'.txt'),'r');
    file_data = textscan(file,'%f,%f,%f,%f,%f,%f,%f');

    raw_data = file_data{3};
    raw_data = flipud(raw_data);
    figure(1)
    plot(raw_data)
    if false
        y_val_cells = cell(1,size(locs,1));
        x_val_cells = cell(1,size(locs,1));
        for i = 1:15
            y_v = raw_data(locs(i,1):locs(i,2));
            x_v = zeros(1,length(y_v));
            x_v(:) = i;
            y_val_cells(i)={y_v};
            x_val_cells(i)={x_v};
        end
        y_value = cat(1,y_val_cells{:})';
        x_value = cat(2,x_val_cells{:});

        % y_value = raw_data(locs(5,1):locs(5,2));
        % plot(1:length(y_value),y_value)

        % x_value = zeros(1,length(y_value));
        % x_value(:) = 1;
        % 
    %     scatter(x_value,y_value)


        % % % Fitting into equations
        % Baldassare 2003 Equation A = 1/(1+(D^2/1000^2) * AF
        % Where D = distance
        %       AF = Attenuation factor between [0.1, 1.0] and depends on angle
        %       between microphone and speaker/sound source
        %       A = sound amplitude recorded.
        xdata = x_value;
        ydata = y_value;
        hrzz = vertcat(xdata,ydata)';
        csvwrite(strcat(audio_file,'.csv'),hrzz);
        % baldassare2003 = @(x,xdata)1./(1+(xdata.^2./1000^2)) * x;
        % x0 = 0.5;
        % x = lsqcurvefit(baldassare2003,x0,xdata,ydata);
        % dists = linspace(xdata(1),xdata(end));
        % plot(xdata,ydata,'ko',dists,baldassare2003(x,dists),'b-')
        % legend('Data','Fitted curve')
        % title('Fitting using BALDASSARE 2003 EQUATION')


        % % https://www.nde-ed.org/EducationResources/CommunityCollege/Ultrasonics/Physics/attenuation.php
        % Just assuming in this case that A0 and alpha = a are unknown.
        ndeed = @(x,xdata)x(1)*exp(-x(2)*xdata);
        x0 = [2000000,0];%[200000000,0]
        x = lsqcurvefit(ndeed,x0,xdata,ydata);
        dists = linspace(xdata(1),xdata(end));
       figure(2)
       plot(xdata,ydata,'ko',dists,ndeed(x,dists),'b-')
        legend('Data','Fitted curve')
        title('Fitting using nde-ed.org EQUATION')
        fig = gcf;
        fig.PaperPositionMode = 'auto';
        fig_pos = fig.PaperPosition;
        fig.PaperSize = [fig_pos(3) fig_pos(4)];
        print(fig,audio_file,'-dpdf')
    end
end

if true
    audio_file = '20180425072307data15m_1m_500hz';
    xy = csvread(strcat(audio_file,'.csv'));
    xdata = xy(:,1);
    ydata = xy(:,2);
    % % https://www.nde-ed.org/EducationResources/CommunityCollege/Ultrasonics/Physics/attenuation.php
    % Just assuming in this case that A0 and alpha = a are unknown.
    ndeed = @(x,xdata)x(1)*exp(-x(2)*xdata);
    x0 = [2000000,0];%[200000000,0]
    x = lsqcurvefit(ndeed,x0,xdata,ydata);
    dists = linspace(xdata(1),xdata(end));
   figure(2)
   plot(xdata,ydata,'ko',dists,ndeed(x,dists),'b-')
   ylabel('\boldmath $$A = A_0 e^{-\alpha d}+err \times d $$', 'Interpreter', 'Latex',...
       'FontSize',13,'FontWeight','bold')
    legend('Data','Fitted curve')
    xlabel('\boldmath $$d$$', 'Interpreter', 'Latex',...
       'FontSize',13,'FontWeight','bold')
    legend('Data','Fitted curve')
    title(strcat('Fitting using nde-ed.org: A_0 =',{' '},...
        num2str(x(1)),', \alpha = ',{' '},num2str(x(2))),'FontSize',10)%,...', err = ',{' '},num2str(x(3))
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    print(fig,audio_file,'-dpdf')
    
end