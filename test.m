
%close previous ROS node if exist
rosshutdown
%init to roscore on SENSO-PC
%SENSO PC
rosinit('10.0.1.24')


disp('Creating subscriber for mode select ... wait 2 seconds')
mode_subscriber = rossubscriber('/modeSelect');
pause(1);
disp('.............Subscriber created...................')
disp('Starting subscriber for mode select ... wait 2 seconds')
mode = receive (mode_subscriber);
pause(1);
disp('.............Subscriber started....................')
        
        a = 1;
while 1
    
    if a==1
       mode = receive (mode_subscriber);
       a = 2;
    end
    %mode = receive (mode_subscriber,10);
    mode.Data
    
end