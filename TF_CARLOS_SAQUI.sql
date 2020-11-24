CREATE VIEW VW8_RN_06 AS 
SELECT S.MPrecio*0.8 AS 'Descuento'
FROM OPERACIONES.Servicio S 


CREATE PROCEDURE  RN_06_09
@CRESERVA INT 
as begin
select DISTINCT R.CReserva,VW1.DATEDIF,VW2.Descuento
from OPERACIONES.Detalle_Servicio DS,VW2_RN06 VW1,VW8_RN_06  VW2,MARKETING.Reserva R ,OPERACIONES.Servicio S
WHERE DS.Reserva_CReserva=R.CReserva AND DS.Servicio_CServicio=S.CServicio AND
VW1.DATEDIF>7 AND R.CReserva=@CRESERVA
end

EXEC RN_06_09  1
