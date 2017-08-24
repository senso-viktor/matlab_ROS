function [J1_pos, J2_pos, J3_pos, J1_torq, J2_torq, J3_mo, J3_mc, J3_pb, J3_lb] = getSignalValues (tg, J1_pos_id, J2_pos_id, J3_pos_id, J1_torq_id, J2_torq_id, J3_mo_id, J3_mc_id, J3_pb_id, J3_lb_id)

    J1_pos = tg.getsignal(J1_pos_id)
    J2_pos = tg.getsignal(J2_pos_id)
    J3_pos = tg.getsignal(J3_pos_id)
    J1_torq = tg.getsignal(J1_torq_id)
    J2_torq = tg.getsignal(J2_torq_id)
    J3_mo = tg.getsignal(J3_mo_id)
    J3_mc = tg.getsignal(J3_mc_id)
    J3_pb = tg.getsignal(J3_pb_id)
    J3_lb = tg.getsignal(J3_lb_id)

end