function [J1_torq, J2_torq] = getTorqueValues (tg, J1_torq_id, J2_torq_id)

    J1_torq = tg.getsignal(J1_torq_id)
    J2_torq = tg.getsignal(J2_torq_id)
    
end