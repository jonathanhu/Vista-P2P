
drop package XXSV_PO_REPORT_UTL;

drop view xxsv_p2p_v;

revoke all from XXSV_PO_REPORT_UTL;

grant all on XXSV_P2P_V to apps;



grant select on XXSV_P2P_V to SV_DWUSER;

grant all on GL_CODE_COMBINATIONS_KFV to apps with grant option;

grant all on FA_BOOKS_V to apps with grant option; 

