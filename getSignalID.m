function [J1_pos_id, J2_pos_id, J3_pos_id, J1_torq_id, J2_torq_id, J3_mo_id, J3_mc_id, J3_pb_id, J3_lb_id] =getSignalID (tg)

    %positions
    J1_pos_id = tg.getsignalidsfromlabel('sigA1Unireg12Position');
    J2_pos_id = tg.getsignalidsfromlabel('sigA2Unireg12Position');
    J3_pos_id = tg.getsignalidsfromlabel('sigA3smci12DemandPosition');
    
    %torques
    J1_torq_id = tg.getsignalidsfromlabel('sigA1SimexTorque');
    J2_torq_id = tg.getsignalidsfromlabel('sigA2SimexTorque');
    
    %gripper status
    J3_mo_id = tg.getsignalidsfromlabel('sigA3magnetOpen');
    J3_mc_id = tg.getsignalidsfromlabel('sigA3magnetClose');
    J3_pb_id = tg.getsignalidsfromlabel('sigA3pushButton');
    J3_lb_id = tg.getsignalidsfromlabel('sigA3lightBarrier');

end