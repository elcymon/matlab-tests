% This script is to compute the wheel velocities for a robot to turn in
% direction of x within the view of camera image of width Imwidth. Ideas
% from the follower plugin is used
function vel = steering_pwm
max_angle = 400;
MAX_TURN = 1500 + max_angle;
MIN_TURN = 1500 - max_angle;
Kp = max_angle/180.0;
drd_hdg = 280;
hdg = 0:1:360;
% turn_amt = NaN(size(hdg));
%     function x = normalize_angle(theta)
%         x = 360 - theta;
%     end
    function turn_amt = move_forward()
%         for i = 1:size(hdg,2)
%             if hdg(i) >= 180
%                 hdg(i) = -normalize_angle(hdg(i));
%             end
%         end
%         if drd_hdg >= 180
%             drd_hdg = normalize_angle(drd_hdg);
%         end
        
        er = drd_hdg - hdg;
        
        for i = 1:size(er,2)
            if er(i) >=180
                er(i) = er(i) - 360;
            elseif er(i) <= -180
                er(i) = er(i) + 360;
            end
        end
        

        u = Kp * er;
        turn_amt = 1500 + u;
        turn_amt(turn_amt > MAX_TURN) = MAX_TURN;
        turn_amt(turn_amt < MIN_TURN)= MIN_TURN;
    end
vel = [hdg',move_forward'];
plot(vel(:,1),vel(:,2))
xlabel('heading direction')
ylabel('pwm signal')
title(strcat('PWM signal when desired heading is = ',' ',num2str(drd_hdg)))
%     end
% wheel_separation = 0.5;
% Imwidth = 320;
% Imheight = 240;
% vr = 0.4;
% maxTurnRate = vr*10;
% wheel_vels = NaN(Imwidth*Imheight,2);
% e = 0;
% ep = 0;
% t = 1;
% for x = 0:Imwidth
%       for y = 0:Imheight
%         turn = -(sqrt(x^2+y^2)/sqrt((Imwidth/2)^2+(Imheight/2)^2)) + 1;
%         e = e+turn;
%         va = turn * maxTurnRate + (turn - ep) * maxTurnRate ;
%         ep = turn;
%         l = vr + va * wheel_separation/2;
%         r = vr - va * wheel_separation/2;
% 
%         if l > vr
%             l = vr;
%         end
%         if l < 0
%             l = 0;
%         end
%         if r > vr 
%             r = vr;
%         end
%         if r < 0 
%             r = 0;
%         end
%         wheel_vels(t,:) = [l,r];
%         t = t+1;
%       end
% end
end