% Experiments on different filtering approaches

filename = {'20180909231249datagoexp1a','20180909231651datagoexp1b',...
            '20180909232055data','20180909232518data','20180909232933data'};
experimentData = cell(3,numel(filename));
for i1 = 1:numel(filename)
    xy = csvread(strcat(filename{i1},'.txt'));
    experimentData{3,i1} = xy(:,1);
    experimentData{2,i1}= xy(:,2);
    experimentData{1,i1} = xy(:,end);
end
Analysis = analyseData(experimentData);
xlswrite('GradientAnalysis.xlsx',Analysis,'Real Experiments','A1');

[tModel,xModel,pureSignal,meanError,stdError,AnAlpha] = developSoundModel(experimentData);

% 100% Standard deviation error
Analysis = analyseData({pureSignal,xModel,tModel},stdError,meanError,1.0);
xlswrite('GradientAnalysis.xlsx',Analysis,'100Pct Error','A1');

% 50% Standard deviation error
Analysis = analyseData({pureSignal,xModel,tModel},stdError,meanError,0.5);
xlswrite('GradientAnalysis.xlsx',Analysis,'50Pct Error','A1');

% 25% Standard deviation error
Analysis = analyseData({pureSignal,xModel,tModel},stdError,meanError,0.25);
xlswrite('GradientAnalysis.xlsx',Analysis,'25Pct Error','A1');