function [J1_vel, J1_acc, J2_vel, J2_acc, J3_vel, J3_acc] = getVelAndAccValues(tg, J1_vel_id, J1_acc_id, J2_vel_id, J2_acc_id, J3_vel_id, J3_acc_id)

    J1_vel = tg.getsignal(J1_vel_id);
    J1_acc = tg.getsignal(J1_acc_id);
    J2_vel = tg.getsignal(J2_vel_id);
    J2_acc = tg.getsignal(J2_acc_id);
    J3_vel = tg.getsignal(J3_vel_id);
    J3_acc = tg.getsignal(J3_acc_id);

end