%   Double Pendulum with Damping
%   Dmitriy Kats
%   October 2015 
clear; close all;

mBar1= 0.043;  %   mBar1 mass, kg
mEnd1= 0.135;  %   mEnd1 mass, kg
L1= 0.176;     %   bar1 length, m
mBar2= 0.021;  %   mBar2 mass, kg
mEnd2= 0.085;  %   mEnd2 mass, kg
L2= 0.135;     %   bar2 length, m
 
g= 9.81;    %   acceleration due to gravity, m/s^2
 
time=[];    %   array to store time values
data1=[];    %   array to store data1 to plot
data2=[];    %   array to store data2 to plot
 
deltat= 0.001;    %   simulation time step, s
duration= 8;  %   simulation duration, s
timeSteps= round(duration/deltat)+1;    %   simulation # of steps
frameRate= 50;  %   Animation frame rate, frames/s
framePeriod= 1./frameRate;  %   period of one frame, s
 
theta1= 45; %   initial angle of bar 1, deg
theta1= theta1 *pi/ 180.;   %   initial angle of bar 1, rad
theta1dot= 0.;   %   initial angular velocity of bar 1, rad/s
theta2=45; %   initial angle of bar 2, deg
theta2= theta2 *pi/ 180.;   %   initial angle of bar 2, rad
theta2dot= 0.;   %   initial angular velocity of bar 2, rad/s
theta1ddot=0; %initial angular acceleration of bar 1, rad/s^2

damping1=2.73*(2*L1^2*(mBar1+3*mBar2+3*mEnd1+3*mEnd2)); %Nms
damping2=1.02*(2*L2^2*(mBar2+3*mEnd2)); %Nms


% Draw initial figure
fig= figure(1);
axs= axes('Parent',fig);
 
% Open the movie file.
vidObj= VideoWriter('animateClass.avi');
vidObj.FrameRate= frameRate;
open(vidObj);
 
 
bar1= line([0,L1*sin(theta1)], [0,-L1*cos(theta1)]);
bar2= line([L1*sin(theta1),L1*sin(theta1)+L2*sin(theta2)], ...
    [-L1*cos(theta1),-L1*cos(theta1)-L2*cos(theta2)]);
border= line([-5*L1, -5*L1, 5*L1, 5*L1, -5*L1], [-5*L1, 5*L1, 5*L1, -5*L1, -5*L1]);
axis(axs,[-5*L1, 5*L1, -5*L1, 5*L1] );
axis(axs,'square');
axis(axs,'off');
 
for i= 1:timeSteps
    t= (i-1)*deltat;
    
    set(bar1,'XData',[0,L1*sin(theta1)]);
    set(bar1,'YData',[0,-L1*cos(theta1)]);
    set(bar2,'XData',[L1*sin(theta1),L1*sin(theta1)+L2*sin(theta2)]);
    set(bar2,'YData',[-L1*cos(theta1),-L1*cos(theta1)-L2*cos(theta2)]);
    
    title(['Time(s):' num2str(t)])
    if(mod(t,framePeriod) == 0)
        currFrame = getframe;
        writeVideo(vidObj,currFrame);
        time= [time t];
        data1= [data1 theta1];
        data2=[data2 theta2];
    end
    
    ct2t1= cos(theta2-theta1);
    st2t1= sin(theta2-theta1);
    %Euler's method for theta2
    theta2ddot= -1.3533* theta1ddot*cos(theta1-theta2) + ...
    1.3533011272141706*theta1dot^2*sin(theta1-theta2)- ...
     75.43115942028986*sin(theta2)-theta2dot*damping2/...
     (2*L2^2*(mBar2+3*mEnd2));
    theta2dot= theta2dot + theta2ddot*deltat;
    theta2= theta2 + theta2dot*deltat;
    
    %Euler's method for theta1
    theta1ddot=-0.286891*theta2ddot*cos(theta1-theta2)-... 
    0.2868910218371707*theta2dot^2*sin(theta1-theta2) -...
     57.30310200569665*sin(theta1)-theta1dot*damping1 /...
     (2*L1^2*(mBar1+3*mBar2+3*mEnd1+3*mEnd2));
    theta1dot= theta1dot + theta1ddot*deltat;
    theta1= theta1 +theta1dot *deltat;
end
 
% Close the movie file.
close(vidObj);
 
graph= figure(2);
plot(time,data1);
xlabel('Time (s)')
ylabel('Theta_1(rad)')
title(['Initial Theta_1 (degrees):' num2str(20) ' Initial Theta_2 (degrees):' num2str(20)])

graph=figure(3);
plot(time,data2,'-r');
xlabel('Time (s)')
ylabel('Angle(rad)')
title(['Initial Theta_1 (degrees):' num2str(45) ' Initial Theta_2 (degrees):' num2str(45)])
hold on
plot(time,data1,'-.b');
legend('Theta_1','Theta_2')
hold off
