    function experimentData = readExperimentData()
    filename = {'20180909231249datagoexp1a','20180909231651datagoexp1b',...
                '20180909232055data','20180909232518data','20180909232933data'};
    experimentData = cell(3,numel(filename));
    for i1 = 1:numel(filename)
        xy = csvread(strcat(filename{i1},'.txt'));
        experimentData{3,i1} = xy(:,1);
        experimentData{2,i1}= xy(:,2);
        experimentData{1,i1} = xy(:,end);
    end
end