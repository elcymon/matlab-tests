% This script is to compute the wheel velocities for a robot to turn in
% direction of x within the view of camera image of width Imwidth. Ideas
% from the follower plugin is used
wheel_separation = 0.5;
Imwidth = 320;
Imheight = 240;
vr = 0.4;
maxTurnRate = vr*10;
wheel_vels = NaN(Imwidth*Imheight,2);
e = 0;
ep = 0;
t = 1;
for x = 0:Imwidth
      for y = 0:Imheight
        turn = -(sqrt(x^2+y^2)/sqrt((Imwidth/2)^2+(Imheight/2)^2)) + 1;
        e = e+turn;
        va = turn * maxTurnRate + (turn - ep) * maxTurnRate ;
        ep = turn;
        l = vr + va * wheel_separation/2;
        r = vr - va * wheel_separation/2;

        if l > vr
            l = vr;
        end
        if l < 0
            l = 0;
        end
        if r > vr 
            r = vr;
        end
        if r < 0 
            r = 0;
        end
        wheel_vels(t,:) = [l,r];
        t = t+1;
      end
end
