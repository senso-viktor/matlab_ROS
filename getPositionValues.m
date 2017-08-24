function [J1_pos, J2_pos, J3_pos] = getPositionValues(tg, J1_pos_id, J2_pos_id, J3_pos_id)

    J1_pos = tg.getsignal(J1_pos_id)
    J2_pos = tg.getsignal(J2_pos_id)
    J3_pos = tg.getsignal(J3_pos_id)
    
end