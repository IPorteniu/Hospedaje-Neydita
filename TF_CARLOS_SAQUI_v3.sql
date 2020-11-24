CREATE VIEW VW_RN6 AS 
SELECT datediff(day,S.DInicioEstadia ,S.DFinEstadia) AS DATEDIF,S.CReserva,M.MMonto*0.95 AS 'Descuento'
FROM MARKETING.Reserva S ,MARKETING.Comprobante M 
WHERE S.CComprobante=M.CComprobante 


create PROCEDURE  RN_06
@CRESERVA INT 
as begin
select  *
from VW_RN6 as V6
WHERE V6.DATEDIF > 7 and v6.CReserva = @CRESERVA
end

exec RN_06 1

