function [J3_mo, J3_mc, J3_pb, J3_lb] = getGripperStatus (tg, J3_mo_id, J3_mc_id, J3_pb_id, J3_lb_id)

    J3_mo = tg.getsignal(J3_mo_id)
    J3_mc = tg.getsignal(J3_mc_id)
    J3_pb = tg.getsignal(J3_pb_id)
    J3_lb = tg.getsignal(J3_lb_id)

end