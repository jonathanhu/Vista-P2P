CREATE OR REPLACE PACKAGE BOLINF.XXSV_PO_REPORT_UTL AUTHID CURRENT_USER AS


function Operating_Units      (P_Operating_Units VARCHAR2) return VARCHAR2;
Function Solicitante        ( P_Req_Distribution_Id Number ) Return Varchar2;
Function Numero_Solicitud   ( P_Req_Distribution_Id Number ) Return Varchar2;
Function Fecha_Solicitud    ( P_Req_Distribution_Id Number ) Return Varchar2;

function RELEASE_NUM        (PO_HEADER_ID Number,  PO_RELEASE_ID Number ) return number;

function POSITION_HIERARCHY_NAME ( P_WF_ITEM_KEY varchar2 ) return varchar2;

function FLEX_VALUE_DESCRIPTION ( p_FLEX_VALUE_SET_NAME varchar, p_FLEX_VALUE varchar) return varchar2;

function CATEGORY_CODE_SEGMENT ( P_INVENTORY_ITEM_ID number, segment_num number) return varchar2;

function CATEGORY_SEGMENT ( P_INVENTORY_ITEM_ID number, segment_num number) return varchar2;

function REQ_PROYECT ( P_REQ_DISTRIBUTION_ID number ) return varchar2;

FUNCTION QUANTITY_RECEIVED (P_PO_LINE_ID NUMBER) RETURN NUMBER;
FUNCTION TOTAL_NET_RECEIVED (P_PO_HEADER_ID NUMBER) RETURN NUMBER;
FUNCTION LAST_DATE_RECEIVED (P_PO_LINE_ID NUMBER) RETURN date;

function INVOICE_NUM    (P_PO_DISTRIBUTION_ID NUMBER) RETURN varchar2;
function INVOICE_DATE   (P_PO_DISTRIBUTION_ID NUMBER) RETURN date;
function INVOICE_AMOUNT (P_PO_DISTRIBUTION_ID NUMBER) RETURN number;
function TERMS_DATE     (P_PO_DISTRIBUTION_ID NUMBER) RETURN date;
function TERMS_NAME     (P_PO_DISTRIBUTION_ID NUMBER) RETURN varchar2;
function INVOICE_USER_NAME  (P_PO_DISTRIBUTION_ID NUMBER) RETURN varchar2;
function FECHA_PROGRAMADA_PAGO  (P_PO_DISTRIBUTION_ID NUMBER) RETURN date;

function PAYMENT_NUMBER  (P_PO_DISTRIBUTION_ID NUMBER) RETURN varchar2;
function PAYMENT_DATE  (P_PO_DISTRIBUTION_ID NUMBER) RETURN date;
function MONTO_PAGADO  (P_PO_DISTRIBUTION_ID NUMBER) RETURN number;
function PAYMENT_USER  (P_PO_DISTRIBUTION_ID NUMBER) RETURN varchar2;
function APPROVER  (P_PO_HEADER_ID NUMBER, P_SEQUENCE NUMBER) RETURN varchar2;
function APPROVED_DATE  (P_PO_HEADER_ID NUMBER, P_SEQUENCE NUMBER) RETURN DATE;
function DATE_PLACED_IN_SERVICE (P_ASSET_ID NUMBER) RETURN DATE;
function DATE_EFFECTIVE  (P_ASSET_ID NUMBER) RETURN DATE;
function ASSET_TYPE (P_ASSET_ID NUMBER) RETURN VARCHAR2;

End;
/
exit
/