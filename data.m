fileID = fopen('data.txt','r');
A = textscan(fileID,'%f,%f,%f,%f,%f,%f','HeaderLines',2);
fclose(fileID);

pwm = A{1};
rps = A{2};

[~, x] = unique(pwm,'legacy');

st = 1;
mean_rps = NaN(size(x));
ppwm = NaN(size(x));
p = 1;

for i = x'
    %disp(pwm(i));
    ppwm(p) = pwm(i);
    mean_rps(p) = mean(rps(st:i));
    if ppwm(p) < 1500
        mean_rps(p) = - mean_rps(p);
    end
    st = i+1;
    p = p + 1;
end

plot(ppwm,mean_rps)