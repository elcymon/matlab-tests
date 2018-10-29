% Experiments on different filtering approaches

filename = {'20180909231249datagoexp1a','20180909231651datagoexp1b',...
            '20180909232055data','20180909232518data','20180909232933data'};
experimentData = cell(size(filename));
for i1 = numel(filename)
    xy = csvread(strcat(filename{i1},'.txt'));
    t = xy(:,1);
    xdata = xy(:,2);
    ydata = xy(:,end);
end
