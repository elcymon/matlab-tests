% Experiments on different filtering approaches
Tests = {10,0;10,10;20,0;10,20;30,0;10,30;...
                                 20,20;40,0;20,40;60,0;
                                 40,40;80,0;40,80;120,0};
experimentData = readExperimentData();
Analysis = analyseData(experimentData,Tests);
xlswrite('GradientAnalysis.xlsx',Analysis,'Real Experiments','A1');

[tModel,xModel,pureSignal,meanError,stdError,A0nAlpha] = developSoundModel(experimentData);

% 100% Standard deviation error
errScale = 1.0;
Analysis = analyseData({pureSignal,xModel,tModel},Tests,stdError,meanError,errScale);
xlswrite('GradientAnalysis.xlsx',Analysis,'100Pct Error','A1');
gradientComputationStepped(pureSignal,xModel,tModel, stdError, meanError, errScale)

% 50% Standard deviation error
errScale = 0.50;
Analysis = analyseData({pureSignal,xModel,tModel},Tests,stdError,meanError,errScale);
xlswrite('GradientAnalysis.xlsx',Analysis,'50Pct Error','A1');
gradientComputationStepped(pureSignal,xModel,tModel, stdError, meanError, errScale)

% 25% Standard deviation error
errScale = 0.25;
Analysis = analyseData({pureSignal,xModel,tModel},Tests,stdError,meanError,errScale);
xlswrite('GradientAnalysis.xlsx',Analysis,'25Pct Error','A1');
gradientComputationStepped(pureSignal,xModel,tModel, stdError, meanError, errScale)

