%close previous ROS node if exist
rosshutdown
%init to roscore on SENSO-PC
%SENSO PC
rosinit('10.0.1.24')

node1.delete;
node2.delete;
node3.delete;

node1 = robotics.ros.Node('/matlab_publish_jointStates');
node2 = robotics.ros.Node('/matlab_publish_buttonState');
node3 = robotics.ros.Node('/matlab_subscribe_mode');

%stop previous tg
tg.stop

%Get signal IDs
[J1_pos_id, J2_pos_id, J3_pos_id, J1_torq_id, J2_torq_id, J3_mo_id, J3_mc_id, J3_pb_id, J3_lb_id] = getSignalID(tg)

%Initialisation settings for variables in Simulink !!!!!!!
%Input:
    joint1_desired_value = 0;
    joint2_desired_value = 0;
    joint3_desired_value = 0;
%Output:
    J1_pos = 0;
    J2_pos = 0;
    J3_pos = 0;
    J1_vel = 0.1;
    J2_vel = 0.1;
    J3_vel = 0.1;
    
    J1_torq = 0;
    J2_torq = 0;
    J3_mo = 0;
    J3_mc = 0;
    J3_pb = 0;
    J3_lb = 0;


    
%Publisher for publishing JointStates from Simulink:  
    disp('creating publisher for joint_states  wait 2 seconds')
    joint_state_pub = robotics.ros.Publisher(node1,'/scara_jointStates','sensor_msgs/JointState');
    pause(2)    % Wait to ensure publisher is registered
    disp('...........publisher for joint_states created..........')
    joint_state_msg = rosmessage('sensor_msgs/JointState');
    joint_state_msg.Position = [J1_pos J2_pos J3_pos];  %init pos, vel, acc
    joint_state_msg.Velocity = [J1_vel J2_vel J3_vel];
    joint_state_msg.Effort = [J1_torq J2_torq 0.0];
    joint_state_msg.Header.FrameId = '/world';
    joints(1) = java.lang.String('Joint1');
    joints(2) = java.lang.String('Joint2');
    joints(3) = java.lang.String('Joint_GripperBase');
    joints_cell = cell(joints); %create a string array
    joint_state_msg.Name = joints_cell; %Insert joint names into JointStates
    
%Publisher for pushbutton
%     disp('creating publisher for pushbutton  ... wait 2 seconds')
%     pushbutton_pub = robotics.ros.Publisher(node2,'/scara_pushbutton','std_msgs/Byte');
%     pause(2)    % Wait to ensure publisher is registered
%     disp('........publisher for pushbutton created..............')
%     pushbutton_msg = rosmessage('std_msgs/Byte');
%     pushbutton_msg.Data = 0 ;
    
%Subscriber for mode select:
%     disp('Creating subscriber for mode select ... wait 2 seconds')
%     mode_subscriber = robotics.ros.Subscriber(node3, '/modeSelect', 'std_msgs/Byte');
%     pause(2);
%     disp('.............Subscriber created...................')
    
%Subscriber for poses:
    disp('Creating subscriber for poses ... wait 2 seconds')
    poses_subscriber = robotics.ros.Subscriber(node3, '/planned_poses_and_velocities', 'geometry_msgs/Pose');
    pause(2);
    disp('.............Subscriber created...................')

%start simulink realtime
    %tg.start;
    disp("wait for init 0.5s")
    pause(0.5)
    
    
%main fcn
a=1;
while 1
    tic
    [J1_pos,J2_pos,J3_pos,J1_torq,J2_torq,J3_mo,J3_mc,J3_pb] = getSignalValues(tg, J1_pos_id, J2_pos_id, J3_pos_id, J1_torq_id, J2_torq_id, J3_mo_id, J3_mc_id, J3_pb_id);
    time = rostime('now');
    joint_state_msg.Header.Stamp = time;
    joint_state_msg.Position = [J1_pos -J2_pos -J3_pos]; % - kvoli opacnemu natoceniu
    joint_state_msg.Effort = [J1_torq J2_torq 0.0];
    send(joint_state_pub,joint_state_msg);
    toc
    
        poses_subscriber.LatestMessage.Position.X
        poses_subscriber.LatestMessage.Position.Y
        poses_subscriber.LatestMessage.Position.Z

%     if mode_subscriber.LatestMessage.isvalid
%     
%         if  mode_subscriber.LatestMessage.Data == 7 
%                 setparam(tg,'controlParams/parDemo','Value', 7);
%         end
%         if mode_subscriber.LatestMessage.Data == 6
%                 setparam(tg,'controlParams/parDemo','Value', 6);
%         end
%     end

%     if J3_pb == 1
%         for i=0:1:5
%         pushbutton_msg.Data = 1 ;
%         send(pushbutton_pub,pushbutton_msg);
%         end
%     end

    
end
    
