CREATE OR REPLACE package body BOLINF.XXSV_PO_REPORT_UTL as

cursor requisition_data ( P_Req_Distribution_Id number) is
SELECT RH.SEGMENT1, RH.CREATION_DATE, P1.FULL_NAME, RD.DISTRIBUTION_ID
          FROM APPS.PO_REQUISITION_HEADERS_ALL RH,
               APPS.PO_REQUISITION_LINES_ALL RL,
               APPS.PO_REQ_DISTRIBUTIONS_ALL RD,
               APPS.PER_PEOPLE_F P1
         WHERE RH.REQUISITION_HEADER_ID = RL.REQUISITION_HEADER_ID
           AND RL.REQUISITION_LINE_ID = RD.REQUISITION_LINE_ID      
           AND RH.PREPARER_ID = P1.PERSON_ID
           AND RD.DISTRIBUTION_ID = P_Req_Distribution_Id
;

cursor  FLEX_VALUE_DESCRIPTION_DATA( p_FLEX_VALUE_SET_NAME varchar, p_FLEX_VALUE varchar) is 
 select FLEX_VALUE_SET_NAME, FV1.FLEX_VALUE, FVT1.DESCRIPTION 
   from APPS.FND_FLEX_VALUE_SETS FVS1
       ,APPS.FND_FLEX_VALUES FV1
       ,APPS.FND_FLEX_VALUES_TL FVT1
   where FVS1.FLEX_VALUE_SET_NAME = p_FLEX_VALUE_SET_NAME /*'XX_INV_MIC_SEGMENT_VALUES_VS'*/
     AND FVS1.FLEX_VALUE_SET_ID = FV1.FLEX_VALUE_SET_ID
     AND FV1.FLEX_VALUE_ID = FVT1.FLEX_VALUE_ID
     AND FVT1.LANGUAGE = 'US'
     and FV1.FLEX_VALUE = p_FLEX_VALUE
     ;

cursor CATEGORY_CODE_data (p_INVENTORY_ITEM_ID number ) is
        SELECT SI.INVENTORY_ITEM_ID,
               CT.SEGMENT1 ,
               CT.SEGMENT2 ,
               CT.SEGMENT3 ,
               CT.SEGMENT4 
          FROM APPS.MTL_SYSTEM_ITEMS SI,
               APPS.MTL_ITEM_CATEGORIES IC,
               APPS.MTL_CATEGORIES CT     
         WHERE SI.ORGANIZATION_ID = 85 /* MASTER ORG  */
           and SI.INVENTORY_ITEM_ID = p_INVENTORY_ITEM_ID /* 153408*/
           AND SI.INVENTORY_ITEM_ID = IC.INVENTORY_ITEM_ID
           AND SI.ORGANIZATION_ID = IC.ORGANIZATION_ID
           AND IC.CATEGORY_ID = CT.CATEGORY_ID
           AND CT.STRUCTURE_ID = 101 /* NACIONES UNIDAS */     
           ;

cursor invoice_data (p_PO_DISTRIBUTION_ID number)
is
  SELECT MIN(AI.INVOICE_NUM) INVOICE_NUM,
               MIN(AI.INVOICE_DATE) INVOICE_DATE,
               MIN(AI.TERMS_DATE) TERMS_DATE, 
               MIN(T1.NAME) TERMS_NAME,
               MIN(TL1.DUE_DAYS) DUE_DAYS,
               MIN(AI.INVOICE_AMOUNT) INVOICE_AMOUNT,
               MIN(U.USER_NAME) INVOICE_USER_NAME,
               AID.PO_DISTRIBUTION_ID
         FROM APPS.AP_INVOICES_ALL AI,
              APPS.AP_INVOICE_DISTRIBUTIONS_ALL AID,
              APPS.AP_TERMS T1,
              APPS.AP_TERMS_LINES TL1,
              APPS.FND_USER U
        WHERE AI.INVOICE_ID = AID.INVOICE_ID
          AND AI.CREATED_BY = U.USER_ID
          AND AI.TERMS_ID = T1.TERM_ID
          AND T1.TERM_ID = TL1.TERM_ID
          AND AID.PO_DISTRIBUTION_ID = p_PO_DISTRIBUTION_ID /*397619*/
         GROUP BY AID.PO_DISTRIBUTION_ID
         ;

cursor payment_data  (p_PO_DISTRIBUTION_ID number)
is
   SELECT MIN(CH.CHECK_NUMBER) CHECK_NUMBER,
          MIN(CH.CHECK_DATE) CHECK_DATE,
          MIN(IP.AMOUNT) AMOUNT,
          MIN(U.USER_NAME) USER_NAME
     FROM APPS.AP_INVOICES_ALL AI,
          APPS.AP_INVOICE_DISTRIBUTIONS_ALL AID,
          APPS.AP_CHECKS_ALL CH,
          APPS.AP_INVOICE_PAYMENTS_ALL IP,
          APPS.FND_USER U
    WHERE AI.INVOICE_ID = AID.INVOICE_ID
      AND AI.INVOICE_ID = IP.INVOICE_ID
      AND IP.CHECK_ID = CH.CHECK_ID
      AND CH.CREATED_BY = U.USER_ID
      AND AID.PO_DISTRIBUTION_ID = p_PO_DISTRIBUTION_ID /* 397619  */
      ;
      
FUNCTION replace_latin_chr (Pin_string VARCHAR2) as
   RETURN VARCHAR2
IS
   pout_string   VARCHAR2 (4000);
   special_chr   VARCHAR2 (150);
   replace_chr   VARCHAR2 (150);
BEGIN
   special_chr   :=    CHR (50048)
                    || CHR (50049)
                    || CHR (50050)
                    || CHR (50051)
                    || CHR (50052)
                    || CHR (50056)
                    || CHR (50057)
                    || CHR (50058)
                    || CHR (50059)
                    || CHR (50060)
                    || CHR (50061)
                    || CHR (50062)
                    || CHR (50063)
                    || CHR (50065)
                    || CHR (50066)
                    || CHR (50067)
                    || CHR (50068)
                    || CHR (50069)
                    || CHR (50070)
                    || CHR (50073)
                    || CHR (50074)
                    || CHR (50075)
                    || CHR (50076)
                    || CHR (50080)
                    || CHR (50081)
                    || CHR (50082)
                    || CHR (50083)
                    || CHR (50084)
                    || CHR (50085)
                    || CHR (50086)
                    || CHR (50088)
                    || CHR (50089)
                    || CHR (50090)
                    || CHR (50091)
                    || CHR (50092)
                    || CHR (50093)
                    || CHR (50094)
                    || CHR (50095)
                    || CHR (50097)
                    || CHR (50098)
                    || CHR (50099)
                    || CHR (50100)
                    || CHR (50101)
                    || CHR (50102)
                    || CHR (50105)
                    || CHR (50106)
                    || CHR (50107)
                    || CHR (50108)
                    || CHR (50087)
                    || CHR (50055);

   replace_chr   := 'AAAAAEEEEIIIINOOOOOUUUUaaaaaaeeeeeiiiinooooouuuucC';
   pout_string   := TRANSLATE (pin_string, special_chr, replace_chr);

   RETURN pout_string;
END;
      
      
Function Operating_Units      (P_Operating_Units VARCHAR2) return VARCHAR2 is
v_Operating_Units VARCHAR2(240);
begin
    SELECT NAME
     into  v_Operating_Units
  FROM HR_OPERATING_UNITS
     where ORGANIZATION_ID = ORGANIZATION_ID
     ;
    return v_Operating_Units;
exception when others then
    return v_Operating_Units;
end;

Function Solicitante        ( P_Req_Distribution_Id Number ) Return Varchar2 is
v_FULL_NAME varchar2(240);
begin
    for X in requisition_data (P_Req_Distribution_Id) loop
        v_FULL_NAME := X.FULL_NAME;
    end loop;
    
    return(v_FULL_NAME);
exception when others then
    return (v_FULL_NAME);
end;

Function Numero_Solicitud        ( P_Req_Distribution_Id Number ) Return Varchar2 is
v_SEGMENT1 varchar2(240);
begin
    for X in requisition_data (P_Req_Distribution_Id) loop
        v_SEGMENT1 := X.SEGMENT1;
    end loop;
    
    return(v_SEGMENT1);
exception when others then
    return (v_SEGMENT1);
end;

Function Fecha_Solicitud        ( P_Req_Distribution_Id Number ) Return Varchar2 is
v_CREATION_DATE varchar2(240);
begin
    for X in requisition_data (P_Req_Distribution_Id) loop
        v_CREATION_DATE := X.CREATION_DATE;
    end loop;
    
    return(v_CREATION_DATE);
exception when others then
    return (v_CREATION_DATE);
end;

function RELEASE_NUM        (PO_HEADER_ID Number,  PO_RELEASE_ID Number ) return number is
v_RELEASE_NUM number;
begin
    SELECT RELEASE_NUM
     into  v_RELEASE_NUM
  FROM PO_RELEASES_ALL PD
     where PD.PO_HEADER_ID = PO_HEADER_ID
     AND PD.PO_RELEASE_ID = PO_RELEASE_ID
     ;
    return v_RELEASE_NUM;
exception when others then
    return v_RELEASE_NUM;
end;

function POSITION_HIERARCHY_NAME ( P_WF_ITEM_KEY varchar2 ) return varchar2 is
v_POSITION_HIERARCHY_NAME varchar2(30);
begin
    SELECT PSH.POSITION_HIERARCHY_NAME
    into v_POSITION_HIERARCHY_NAME
  FROM APPS.WF_ITEM_ATTRIBUTE_VALUES IAV,
       APPS.HRFV_POSITION_HIERARCHIES PSH
 WHERE IAV.NAME = 'APPROVAL_PATH_ID'
   AND IAV.ITEM_TYPE = 'POAPPRV'
   AND PSH.POSITION_HIERARCHY_ID = IAV.NUMBER_VALUE
   AND PSH.POSITION_HIERARCHY_LEVEL = 1
   and IAV.ITEM_KEY = P_WF_ITEM_KEY
   ;
    return v_POSITION_HIERARCHY_NAME;
exception when others then
    return v_POSITION_HIERARCHY_NAME;
end;



function FLEX_VALUE_DESCRIPTION ( p_FLEX_VALUE_SET_NAME varchar, p_FLEX_VALUE varchar) return varchar2 is
v_description varchar2(240);
begin
    for X in  FLEX_VALUE_DESCRIPTION_data( p_FLEX_VALUE_SET_NAME , p_FLEX_VALUE ) loop
        v_description := x.DESCRIPTION;
    end loop;
    return v_description;
exception when others then
    return v_description;
end;

function CATEGORY_CODE_SEGMENT ( P_INVENTORY_ITEM_ID number, segment_num number) return varchar2 is
    
V_CATEGORY_CODE varchar2(240);
begin
    for X in  CATEGORY_CODE_data( P_INVENTORY_ITEM_ID ) loop
        case segment_num 
        when 1 then V_CATEGORY_CODE := x.SEGMENT1;
        when 2 then V_CATEGORY_CODE := x.SEGMENT2;
        when 3 then V_CATEGORY_CODE := x.SEGMENT3;
        when 4 then V_CATEGORY_CODE := x.SEGMENT4;
        end case;
    end loop;
    return V_CATEGORY_CODE;
exception when others then
    return V_CATEGORY_CODE;
end;

function CATEGORY_SEGMENT ( P_INVENTORY_ITEM_ID number, segment_num number) return varchar2 is
    
V_CATEGORY varchar2(240);
begin
    for X in  CATEGORY_CODE_data( P_INVENTORY_ITEM_ID ) loop
        case segment_num 
        when 1 then V_CATEGORY := FLEX_VALUE_DESCRIPTION('XX_INV_MIC_SEGMENT_VALUES_VS',x.SEGMENT1);
        when 2 then V_CATEGORY := FLEX_VALUE_DESCRIPTION('XX_INV_MIC_FAMILY_VALUES_VS',x.SEGMENT1||x.SEGMENT2);
        when 3 then V_CATEGORY := FLEX_VALUE_DESCRIPTION('XX_INV_MIC_CLASS_VALUES_VS',x.SEGMENT1||x.SEGMENT2||x.SEGMENT3);
        when 4 then V_CATEGORY := FLEX_VALUE_DESCRIPTION('XX_INV_MIC_COMMODITY_VALUES_VS',x.SEGMENT1||x.SEGMENT2||x.SEGMENT3||x.SEGMENT4);
        end case;
    end loop;
    return V_CATEGORY;
exception when others then
    return V_CATEGORY;
end;


FUNCTION QUANTITY_RECEIVED (P_po_line_id NUMBER) RETURN NUMBER IS 
V_AMOUNT NUMBER;
BEGIN
       select POS_PO_RCV_QTY.
                  get_net_qty_rcv (
                                   rt.shipment_line_id
                                  ,rt.quantity
                                  ,rt.transaction_id
                                  ) net_qty_rcv
 into V_AMOUNT
  from rcv_shipment_lines rsl
      ,rcv_transactions rt
 WHERE rt.shipment_line_id = rsl.shipment_line_id
   and rsl.po_line_id = P_po_line_id
   AND rt.transaction_type IN ('RECEIVE', 'MATCH')
   ;
    return NVL(V_AMOUNT,0);
exception when others then return NVL(V_AMOUNT,0);
end;
  
FUNCTION TOTAL_NET_RECEIVED (P_PO_HEADER_ID NUMBER) RETURN NUMBER IS 
V_AMOUNT NUMBER;
BEGIN
       select sum(POS_PO_RCV_QTY.
                  get_net_qty_rcv (
                                   rt.shipment_line_id
                                  ,rt.quantity
                                  ,rt.transaction_id
                                  )  * pla.UNIT_PRICE )
  into V_AMOUNT                   
  from rcv_shipment_lines rsl
      ,rcv_transactions rt
      ,po_lines_all pla
 WHERE rt.shipment_line_id = rsl.shipment_line_id
   and pla.po_header_id = P_PO_HEADER_ID
   AND pla.po_line_id = rsl.po_line_id
   AND rt.transaction_type IN ('RECEIVE', 'MATCH')
   ;
    return NVL(V_AMOUNT,0);
exception when others then return NVL(V_AMOUNT,0);
end;

FUNCTION LAST_DATE_RECEIVED (P_PO_LINE_ID NUMBER) RETURN date IS 
V_date date;
BEGIN
       select rt.Transaction_date 
 into V_date
  from rcv_shipment_lines rsl
      ,rcv_transactions rt
 WHERE rt.shipment_line_id = rsl.shipment_line_id
   and rsl.po_line_id = P_po_line_id
   AND rt.transaction_type IN ('RECEIVE', 'MATCH')
   ;
    return NVL(V_date,null);
exception when others then return NVL(V_date,null);
end;


function REQ_PROYECT ( P_REQ_DISTRIBUTION_ID number ) return varchar2 is
v_value varchar(100);
begin
    select rqh.segment1
     into v_value
  from PO_REQUISITION_HEADERS_ALL rqh
      ,PO_REQUISITION_LINES_ALL rql
      ,PO_REQ_DISTRIBUTIONS_ALL rqd
 where  rqd.DISTRIBUTION_ID  = P_REQ_DISTRIBUTION_ID
    and rqd.REQUISITION_LINE_ID = rql.REQUISITION_LINE_ID
    and rql.REQUISITION_HEADER_ID = rqh.REQUISITION_HEADER_ID
    ;
    return v_value;   
exception when others then return v_value;
end;


         
function INVOICE_NUM (P_PO_DISTRIBUTION_ID NUMBER) RETURN varchar2 is
v_value varchar2(50);
begin
    for x in invoice_data(P_PO_DISTRIBUTION_ID) loop
        v_value := X.INVOICE_NUM;
    end loop;
    return v_value;   
exception when others then return v_value;
end;
function INVOICE_DATE (P_PO_DISTRIBUTION_ID NUMBER) RETURN date is
v_value date;
begin
    for x in invoice_data(P_PO_DISTRIBUTION_ID) loop
        v_value := X.INVOICE_DATE;
    end loop;
    return v_value;   
exception when others then return v_value;
end;
function INVOICE_AMOUNT (P_PO_DISTRIBUTION_ID NUMBER) RETURN number is
v_value number;
begin
    for x in invoice_data(P_PO_DISTRIBUTION_ID) loop
        v_value := X.INVOICE_AMOUNT;
    end loop;
    return v_value;   
exception when others then return v_value;
end;
function TERMS_DATE (P_PO_DISTRIBUTION_ID NUMBER) RETURN date is
v_value date;
begin
    for x in invoice_data(P_PO_DISTRIBUTION_ID) loop
        v_value := X.TERMS_DATE;
    end loop;
    return v_value;   
exception when others then return v_value;
end;
function TERMS_NAME (P_PO_DISTRIBUTION_ID NUMBER) RETURN varchar2 is
v_value varchar2(100);
begin
    for x in invoice_data(P_PO_DISTRIBUTION_ID) loop
        v_value := X.TERMS_NAME;
    end loop;
    return v_value;   
exception when others then return v_value;
end;
function INVOICE_USER_NAME (P_PO_DISTRIBUTION_ID NUMBER) RETURN varchar2 is
v_value varchar2(150);
begin
    for x in invoice_data(P_PO_DISTRIBUTION_ID) loop
        v_value := X.INVOICE_USER_NAME;
    end loop;
    return v_value;   
exception when others then return v_value;
end;
function FECHA_PROGRAMADA_PAGO (P_PO_DISTRIBUTION_ID NUMBER) RETURN date is
v_value date;
begin
    for x in invoice_data(P_PO_DISTRIBUTION_ID) loop
        v_value := X.TERMS_DATE + X.DUE_DAYS;
    end loop;
    return v_value;   
exception when others then return v_value;
end;

function PAYMENT_NUMBER (P_PO_DISTRIBUTION_ID NUMBER) RETURN varchar2 is
v_value varchar2(50);
begin
    for x in payment_data(P_PO_DISTRIBUTION_ID) loop
        v_value := X.CHECK_NUMBER;
    end loop;
    return v_value;   
exception when others then return v_value;
end;
function PAYMENT_USER (P_PO_DISTRIBUTION_ID NUMBER) RETURN varchar2 is
v_value varchar2(150);
begin
    for x in payment_data(P_PO_DISTRIBUTION_ID) loop
        v_value := X.USER_NAME;
    end loop;
    return v_value;   
exception when others then return v_value;
end;

function PAYMENT_DATE (P_PO_DISTRIBUTION_ID NUMBER) RETURN date is
v_value date;
begin
    for x in payment_data(P_PO_DISTRIBUTION_ID) loop
        v_value := X.CHECK_DATE;
    end loop;
    return v_value;   
exception when others then return v_value;
end;
function MONTO_PAGADO (P_PO_DISTRIBUTION_ID NUMBER) RETURN number is
v_value number;
begin
    for x in payment_data(P_PO_DISTRIBUTION_ID) loop
        v_value := X.AMOUNT;
    end loop;
    return v_value;   
exception when others then return v_value;
end;
function APPROVER  (P_PO_HEADER_ID NUMBER, P_SEQUENCE NUMBER) RETURN varchar2 IS 
V_NAME VARCHAR2(500);

BEGIN 
 SELECT  
 papf.full_name employee_name
 INTO V_NAME
            FROM po_action_history poah,
                 per_all_people_f papf
           WHERE 
              poah.employee_id = papf.person_id(+)
             AND TRUNC (SYSDATE) BETWEEN NVL (papf.effective_start_date,
                                              TRUNC (SYSDATE)
                                             )
                                     AND NVL (papf.effective_end_date,
                                              TRUNC (SYSDATE + 1)
                                             )
             AND poah.object_id = P_PO_HEADER_ID
             AND  poah.sequence_num = P_SEQUENCE
             AND poah.object_type_code = 'PO';
             RETURN V_NAME;
 EXCEPTION WHEN OTHERS THEN RETURN NULL;
 
END;

function APPROVED_DATE  (P_PO_HEADER_ID NUMBER, P_SEQUENCE NUMBER) RETURN DATE IS 

V_DATE DATE;

BEGIN 
 SELECT  
 poah.action_date action_date
 INTO V_DATE
            FROM po_action_history poah
           WHERE 
              poah.object_id = P_PO_HEADER_ID
             AND  poah.sequence_num = P_SEQUENCE
             AND poah.object_type_code = 'PO';
             RETURN V_DATE;
 EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;

function DATE_PLACED_IN_SERVICE (P_ASSET_ID NUMBER) RETURN DATE IS 

V_DATE_SERVICE DATE;

BEGIN

select b.date_placed_in_service 
INTO V_DATE_SERVICE
from fa_books b,
   FA_ADDITIONS a where A.ASSET_ID = B.ASSET_ID;
   RETURN V_DATE_SERVICE;
   EXCEPTION WHEN OTHERS THEN RETURN NULL;

END;
function DATE_EFFECTIVE  (P_ASSET_ID NUMBER) RETURN DATE IS

V_DATE_EFFECTIVE DATE;


BEGIN
select b.date_effective
INTO V_DATE_EFFECTIVE
from fa_books b,
   FA_ADDITIONS a where A.ASSET_ID = B.ASSET_ID;
   RETURN V_DATE_EFFECTIVE;
   EXCEPTION WHEN OTHERS THEN RETURN NULL;
   
   END;
function ASSET_TYPE (P_ASSET_ID NUMBER) RETURN VARCHAR2 IS 

V_ASSET_TYPE VARCHAR2(11);

  BEGIN
   select a.ASSET_TYPE
  INTO V_ASSET_TYPE
    from fa_books b, FA_ADDITIONS a
    where A.ASSET_ID = B.ASSET_ID;
    RETURN V_ASSET_TYPE;
   EXCEPTION WHEN OTHERS THEN RETURN NULL;
   
   END;

end;
/
exit
/
