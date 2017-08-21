%close previous ROS node if exist
rosshutdown

%init to roscore on SENSO-PC
%Viktor PC
    %rosinit('10.0.3.171')
%SENSO PC
    rosinit('10.0.1.24')

%Initialisation settings for variables in Simulink !!!!!!!
    %Input:
        joint1_desired_value = 0;
        joint2_desired_value = 0;
        joint3_desired_value = 0;
    %Output:
        joint_state_joint1 = 0;
        joint_state_joint2 = 0;
        joint_state_joint3 = 0;
        joint1_torque = 0;
        joint2_torque = 0;
        gripper_magnetOpen = 0;
        gripper_magnetClose = 0;
        gripper_pushButton = 0;
        gripper_lightBarrier = 0;
    %TO DO: Get these variables from Simulink
    i=0;
    
  
%Create publisher nodehandle
    %Just testing :
        %chatterpub = rospublisher('/chatter', 'std_msgs/String')
        %pause(2) % Wait to ensure publisher is registered
        %chattermsg = rosmessage(chatterpub);
    
    %Publisher for publishing JointStates from Simulink:    
        joint_state_pub = rospublisher('/scara_jointStates','sensor_msgs/JointState');
        pause(2)    % Wait to ensure publisher is registered
        joint_state_msg = rosmessage(joint_state_pub);
        %init variables in JointState message
        joint_state_msg.Position = [0.0 0.0 0.0];
        joint_state_msg.Velocity = [0.1 0.1 0.1];
        joint_state_msg.Effort = [0.2 0.2 0.2];
        joint_state_msg.Header.FrameId = '/world';
        %Create String Cell array
        joints(1) = java.lang.String('Joint1');
        joints(2) = java.lang.String('Joint2');
        joints(3) = java.lang.String('Joint_GripperBase');
        joints_cell = cell(joints);
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

%Some modes
    a=1;
    b = 0;
    mode = 1;

while 1
    
    if b>=1
        mode = 0;
    end
    if b<=-1
        mode = 1;
    end
        
    if mode ==1
        b=b+0.005;
    end
    if mode ==0
        b= b-0.005;
    end

    
    %Send data via publisher : 
        %chattermsg.Data = num2str(i);
        %send(chatterpub,chattermsg);
        %i = i+1;

    %JointStates init time, actual positions and send via Publisher    
        time = rostime('now');
        joint_state_msg.Header.Stamp = time;
        joint_state_msg.Position = [b b b/25] %b/25+1.02
        send(joint_state_pub,joint_state_msg);
        positions = [b b b/25]
        
    %Just test : Get the published JointStates via subscriber
       %if a==1
            %desired_joint_values = receive (desired_pose) %subscribing for the publisher
            %Start ROS subscriber - just once then the messages are
            %incomming automatically
            %a=2;
        %end
        %desired_joint_values


        %Just for delay - cca 15Hz
        pause(0.05)
        
        
        
        
        
    end

%shutdown matlab local roscore
rosshutdown;