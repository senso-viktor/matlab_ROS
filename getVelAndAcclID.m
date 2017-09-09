function [J1_vel_id, J1_acc_id, J2_vel_id, J2_acc_id, J3_vel_id, J3_acc_id] =getVelAndAcclID (tg)

    %velocities
    J1_vel_id = tg.getsignalidsfromlabel('sigA1Velocity');
    J2_vel_id = tg.getsignalidsfromlabel('sigA2Velocity');
    J3_vel_id = tg.getsignalidsfromlabel('sigA3Velocity');
    
    %accelerations
    J1_acc_id = tg.getsignalidsfromlabel('sigA1Acceleration');
    J2_acc_id = tg.getsignalidsfromlabel('sigA2Acceleration');
    J3_acc_id = tg.getsignalidsfromlabel('sigA3Acceleration');


end