%           HELP functions
%Readout signals from simulink
%Every signal *
    %getSignalValues(tg, J1_pos_id, J2_pos_id, J3_pos_id, J1_torq_id, J2_torq_id, J3_mo_id, J3_mc_id, J3_pb_id, J3_lb_id)
%Just positions
    %[J1_pos J2_pos J3_pos] =  getPositionValues(tg, J1_pos_id, J2_pos_id, J3_pos_id)
%Just torques
    %[J1_torq, J2_torq] = getTorqueValues (tg, J1_torq_id, J2_torq_id)
%Just gripper status
    %[J3_mo J3_mc J3_pb J3_mlb] = getGripperStatus(tg,J3_mo_id, J3_mc_id, J3_pb_id, J3_lb_id)
    
%start simulink
    %tg.start
%stop simulink
    %tg.stop
%************Help functions*************%




%close previous ROS node if exist
rosshutdown
%init to roscore on SENSO-PC
%SENSO PC
rosinit('10.0.1.24')

%stop previous tg
tg.stop

%Get signal IDs
[J1_pos_id, J2_pos_id, J3_pos_id, J1_torq_id, J2_torq_id, J3_mo_id, J3_mc_id, J3_pb_id, J3_lb_id] = getSignalID(tg)

%getparam(tg, 'controlParams/parDemo','Value')
%setparam(tg,'controlParams/parDemo','Value', 2)


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
    joint_state_pub = rospublisher('/scara_jointStates','sensor_msgs/JointState');
    pause(2)    % Wait to ensure publisher is registered
    joint_state_msg = rosmessage(joint_state_pub);
    joint_state_msg.Position = [J1_pos J2_pos J3_pos];  %init pos, vel, acc
    joint_state_msg.Velocity = [J1_vel J2_vel J3_vel];
    joint_state_msg.Effort = [0.2 0.2 0.2];
    joint_state_msg.Header.FrameId = '/world';
    joints(1) = java.lang.String('Joint1');
    joints(2) = java.lang.String('Joint2');
    joints(3) = java.lang.String('Joint_GripperBase');
    joints_cell = cell(joints); %create a string array
    pause(2);
    %Insert joint names into JointStates
    joint_state_msg.Name = joints_cell;
    
 %Create subscribe node_hanlde
    %Just testing :
        %desired_pose = rossubscriber('/SLSC_pose')
        %pause(2) % Wait to ensure subscriber is registered
        %Create and start subscriber
        %desired_joint_values = receive (desired_pose)
        %desired_pose = rossubscriber('/scara_jointStates')
        %pause(2)
        %desired_joint_values = receive (desired_pose)
        
        tg.start;
        setparam(tg,'controlParams/parDemo','Value', 2) %choose mode
        
        

    %wait  for init
    disp("wait for init 5s")
    pause(5)
   % tg.start
j1=[]
j2=[]
j3=[]

while 1
    
    %get data from simulink
    [J1_pos J2_pos J3_pos] =  getPositionValues(tg, J1_pos_id, J2_pos_id, J3_pos_id);
    
    %JointStates init time, actual positions and send via Publisher
    time = rostime('now');
    joint_state_msg.Header.Stamp = time;
    joint_state_msg.Position = [J1_pos -J2_pos -J3_pos]; % - kvoli opacnemu natoceniu
    send(joint_state_pub,joint_state_msg);
    positions = [J1_pos -J2_pos -J3_pos]
    % j1=[j1 J1_pos];
    % j2=[j2 -J2_pos];
    % j3=[j3 -J3_pos];


    %Just for delay - cca 15Hz
    %pause(0.05)
        
        
        
        
        
end

%shutdown matlab local roscore
rosshutdown;