
CREATE VIEW VW_RN6 AS 
SELECT datediff(day,S.DInicioEstadia ,S.DFinEstadia) AS DATEDIF,S.CReserva,M.MMonto*0.95 AS 'Descuento'
FROM MARKETING.Reserva S ,MARKETING.Comprobante M 
WHERE S.CComprobante=M.CComprobante 


CREATE PROCEDURE  RN_06
@CRESERVA INT 
as begin
select  *
from VW_RN06 V6
WHERE V6DATEDIF>7
end

