%close previous ROS node if exist
rosshutdown

%node1.delete;
%init to roscore on SENSO-PC
%SENSO PC
rosinit('10.0.1.24')

%node1 = robotics.ros.Node('/matlab_subscriber_displayTrajectory');

%Subscriber
    disp('Creating subscriber ... wait 2 seconds')
    %trajectoryDisplay = robotics.ros.Subscriber(node1, '/move_group/display_planned_path', 'moveit_msgs/DisplayTrajectory');
     trajectoryDisplay = rossubscriber('/move_group/display_planned_path');
    pause(2);
    disp('.............Subscriber created...................')
    
   
    
    
    
while 1
     mode = receive (trajectoryDisplay);
     dlzka = length(trajectoryDisplay.LatestMessage.Trajectory.JointTrajectory.Points)
    
     positions = zeros(3,dlzka);
     for i=1:1:dlzka
         i
          tic
         positions(:,i) = trajectoryDisplay.LatestMessage.Trajectory.JointTrajectory.Points(1:end,1).Positions;
         toc
     end
     positions

    %trajectoryDisplay.LatestMessage
%     for i=1:1:size(trajectoryDisplay.LatestMessage.Trajectory.JointTrajectory.Points)
%         tic
%         i
%         trajectoryDisplay.LatestMessage.Trajectory.JointTrajectory.Points(i,1).Positions
%         a= toc
%     end
    %size(trajectoryDisplay.LatestMessage.Trajectory.JointTrajectory.Points)
    %trajectoryDisplay.LatestMessage.Trajectory.JointTrajectory.Points
    %trajectoryDisplay.LatestMessage.Trajectory.JointTrajectory.Points.Positions
    

    
end