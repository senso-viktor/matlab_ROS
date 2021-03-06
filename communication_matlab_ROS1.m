%close previous ROS node if exist
rosshutdown
%init to roscore on SENSO-PC
%SENSO PC
rosinit('10.0.1.24')
 
% node1.delete;
% node2.delete;
% node3.delete;
% node4.delete;
% node5.delete;
% node6.delete;
% node7.delete;
% node8.delete;

node1 = robotics.ros.Node('/matlab_publish_jointStates');
node2 = robotics.ros.Node('/matlab_publish_buttonState');
node3 = robotics.ros.Node('/matlab_subscribe_mode');
node4 = robotics.ros.Node('/matlab_subscirbe_pose_and_velocities');
node5 = robotics.ros.Node('/matlab_subscirbe_gripperState');
node6 = robotics.ros.Node('/matlab_subscirbe_centralStop');
node7 = robotics.ros.Node('/matlab_publish_accelerations');
node8 = robotics.ros.Node('/matlab_publish_lightbarrier');

%stop previous tg
tg.stop

%Get signal IDs
[J1_pos_id, J2_pos_id, J3_pos_id, J1_torq_id, J2_torq_id, J3_mo_id, J3_mc_id, J3_pb_id, J3_lb_id] = getSignalID(tg);
[J1_vel_id, J1_acc_id, J2_vel_id, J2_acc_id, J3_vel_id, J3_acc_id] = getVelAndAcclID(tg);

%Initialization settings for variables in Simulink !!!!!!!
%Input:
    joint1_desired_value = 0;
    joint2_desired_value = 0;
    joint3_desired_value = 0;
%Output:
    J1_pos = 0.0;
    J2_pos = 0.0;
    J3_pos = 0.0;
    J1_vel = 0.0;
    J2_vel = 0.0;
    J3_vel = 0.0;
    J1_acc = 0.0;
    J2_acc = 0.0;
    J3_acc = 0.0;
    
    J1_torq = 0;
    J2_torq = 0;
    J3_mo = 0;
    J3_mc = 0;
    J3_pb = 0;
    J3_pb_last = 0;
    J3_lb = 0;
    J3_lb_last = 0;


%%      Publishers
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
    
%Publisher for publishing accelerations
    disp('creating publisher for accelerations  wait 2 seconds')
    acc_pub = robotics.ros.Publisher(node7,'/actualAcceleration','geometry_msgs/Point');
    pause(1)    % Wait to ensure publisher is registered
    disp('........publisher for accelerations created..............')
    acceleration_msg = rosmessage('geometry_msgs/Point');
    acceleration_msg.X = J1_acc;    %message init
    acceleration_msg.Y = J2_acc;
    acceleration_msg.Z = J3_acc;
    
%Publisher for pushbutton
    disp('creating publisher for pushbutton  ... wait 2 seconds')
    pushbutton_pub = robotics.ros.Publisher(node2,'/scara_pushbutton','std_msgs/Byte');
    pause(1)    % Wait to ensure publisher is registered
    disp('........publisher for pushbutton created..............')
    pushbutton_msg = rosmessage('std_msgs/Byte');
    pushbutton_msg.Data = 0 ;   %init

%Publisher for lightBarrier
    disp('creating publisher for lightbarrier  ... wait 2 seconds')
    lightbarrier_pub = robotics.ros.Publisher(node8,'/scara_lightbarrier','std_msgs/Byte');
    pause(1)    % Wait to ensure publisher is registered
    disp('........publisher for pushbutton created..............')
    lightbarrier_msg = rosmessage('std_msgs/Byte');
    lightbarrier_msg.Data = 0 ;   %init
    
%%      Subscribers
% Subscriber for mode select:
    disp('Creating subscriber for mode select ... wait 2 seconds')
    mode_subscriber = robotics.ros.Subscriber(node3, '/modeSelect', 'std_msgs/Byte');
    pause(1);
    disp('.............Subscriber created...................')
    
%Subscriber for poses:
    disp('Creating subscriber for poses ... wait 2 seconds')
    poses_subscriber = robotics.ros.Subscriber(node4, '/planned_poses_and_velocities', 'geometry_msgs/Pose');
    pause(1);
    disp('.............Subscriber created...................')
    
%Subscriber for gripper:
    disp('Creating subscriber for gripper ... wait 2 seconds')
    gripper_subscriber = robotics.ros.Subscriber(node5, '/gripperCommand', 'std_msgs/Byte');
    pause(1);
    disp('.............Subscriber created...................')
    
%Subscriber for central stop:
    disp('Creating subscriber for CENTRAL STOP ... wait 2 seconds')
    centralStop_subscriber = robotics.ros.Subscriber(node6, '/centralStop', 'std_msgs/Int32');
    pause(1);
    disp('.............Subscriber created...................') 
    
%%      Init subscribers
    disp('waiting for poses init!')
    receive(poses_subscriber);
    disp('.....OK..........')
    disp('waiting for central stop init!')
    receive(gripper_subscriber);
    disp('......OK.........')   
    disp('waiting for central stop init!')
    receive(centralStop_subscriber);
    disp('......OK.........')
    

%%      Simulink init and stat
%start simulink realtime
    setparam(tg,'controlParams/parDemo','Value', 1);
    setparam(tg,'StateMachine/Subsystem/parDesPosA1','Value',0);
    setparam(tg,'StateMachine/Subsystem/parDesPosA2','Value',0);
    setparam(tg,'StateMachine/Subsystem/parDesVelA1','Value',0);
    setparam(tg,'StateMachine/Subsystem/parDesVelA2','Value',0);
    tg.start;
    disp("wait for init TG 0.5s")
    pause(0.5)
    
    
        
%%      Main function
a=1;
b=1;
init = 0;
while 1

    %end if the CENTRAL STOP button is pressed in GUI
    if centralStop_subscriber.LatestMessage.Data == 1
        break
    end
    
    
    %Get signal values from simulink
    [J1_pos,J2_pos,J3_pos,J1_torq,J2_torq,J3_mo,J3_mc,J3_pb,J3_lb] = getSignalValues(tg, J1_pos_id, J2_pos_id, J3_pos_id, J1_torq_id, J2_torq_id, J3_mo_id, J3_mc_id, J3_pb_id, J3_lb_id);
    [J1_vel, J1_acc, J2_vel, J2acc, J3_vel, J3_acc] = getVelAndAccValues(tg, J1_vel_id, J1_acc_id, J2_vel_id, J2_acc_id, J3_vel_id, J3_acc_id);
    time = rostime('now');
    joint_state_msg.Header.Stamp = time;
    joint_state_msg.Position = [J1_pos -J2_pos -J3_pos]; % - kvoli opacnemu natoceniu
    joint_state_msg.Velocity = [J1_vel -J2_vel -J3_vel];
    joint_state_msg.Effort = [J1_torq J2_torq 0.0];
    send(joint_state_pub,joint_state_msg);
    
    acceleration_msg.X = J1_acc;
    acceleration_msg.Y = J2_acc;
    acceleration_msg.Z = J3_acc;
    send(acc_pub,acceleration_msg);

        tic
        %subscribe to desired poses and velocities and set these poses to
        %simulink
        if (poses_subscriber.isvalid)
         tic   
             if (mode_subscriber.LatestMessage.isvalid)
                if (mode_subscriber.LatestMessage.Data == 6)
                    %disp('mode 6')
                    setparam(tg,'StateMachine/Subsystem/parDesPosA1','Value',-poses_subscriber.LatestMessage.Position.X);
                    setparam(tg,'StateMachine/Subsystem/parDesPosA2','Value',-poses_subscriber.LatestMessage.Position.Y);
                    setparam(tg,'StateMachine/Subsystem/parDesVelA1','Value',-poses_subscriber.LatestMessage.Orientation.X);
                    setparam(tg,'StateMachine/Subsystem/parDesVelA2','Value',-poses_subscriber.LatestMessage.Orientation.Y);
                    setparam(tg,'StateMachine/parDesPosA3','Value',poses_subscriber.LatestMessage.Position.Z);
                                        
                end
             end
        end
        toc
         
        %set mode in simulink
        if mode_subscriber.LatestMessage.isvalid
            if  (mode_subscriber.LatestMessage.Data == 7 )
                setparam(tg,'controlParams/parDemo','Value', 7);
            end
            if (mode_subscriber.LatestMessage.Data == 6)
                setparam(tg,'controlParams/parDemo','Value', 6);
                init = 1;
            end
            if (mode_subscriber.LatestMessage.Data == 2)
                setparam(tg,'controlParams/parDemo','Value', 2);
            end
        end
        
        %send light barrier state
        if J3_lb ~= J3_lb_last
            lightbarrier_msg.Data = J3_lb;
            send(lightbarrier_pub,lightbarrier_msg);
            J3_lb_last = J3_lb;
        end

        %send button state
        if J3_pb ~= J3_pb_last
            pushbutton_msg.Data = J3_pb;
            send(pushbutton_pub,pushbutton_msg);
            J3_pb_last = J3_pb;
        end

        if init == 1
            %set gripper on/off
            if gripper_subscriber.isvalid
                if gripper_subscriber.LatestMessage.Data == 1
                    setparam(tg,'StateMachine/parDesGripper','Value', 1);
                else
                    setparam(tg,'StateMachine/parDesGripper','Value', 0);
                end
            end
        end
    
end


%%      program end

tg.stop
node1.delete;
node2.delete;
node3.delete;
node4.delete;
node5.delete;
node6.delete;
node7.delete;

disp('program end');
    
