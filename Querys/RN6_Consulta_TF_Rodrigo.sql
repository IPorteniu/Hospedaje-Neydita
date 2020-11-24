USE NHTest3
GO

CREATE FUNCTION CLIENTE_COMPROBANTE()
RETURNS TABLE
AS
	RETURN
			(
				SELECT p.CPersona,p.TEmail,hr.CReserva,r.CComprobante,c.DEmision,c.FBoleta,c.MMonto
				FROM VENTAS.Persona p 
				INNER JOIN VENTAS.Huesped_Reserva hr ON hr.CHuesped = p.CPersona
				INNER JOIN MARKETING.Reserva r ON hr.CReserva = r.CReserva
				INNER JOIN MARKETING.Comprobante c ON r.CComprobante = c.CComprobante
			)
GO

SELECT * FROM dbo.CLIENTE_COMPROBANTE() c
ORDER BY c.CPersona ASC
GO

CREATE FUNCTION CorreoDelCliente(@codpers INT)
RETURNS NVARCHAR(30)
AS 
BEGIN
	DECLARE @correo NVARCHAR(30)
	SELECT @correo=c.TEmail FROM dbo.CLIENTE_COMPROBANTE() c WHERE c.TEmail IS NOT NULL
	RETURN @correo
END
GO

SELECT dbo.CorreoDelCliente(1382) AS EMAIL
GO

CREATE PROCEDURE MetodoParaRecibirBoleta(@codpers INT)
AS
BEGIN
	IF EXISTS(SELECT * FROM dbo.CLIENTE_COMPROBANTE() c WHERE c.CPersona = @codpers AND c.FBoleta = 1)
		IF EXISTS (SELECT * FROM dbo.CLIENTE_COMPROBANTE() c WHERE c.CPersona = @codpers AND c.TEmail IS NOT NULL)
		BEGIN
			DECLARE @email NVARCHAR(30) = dbo.CorreoDelCliente(@codpers)
			SELECT * 
			FROM dbo.CLIENTE_COMPROBANTE() c 
			WHERE c.CPersona = @codpers AND c.FBoleta = 1
			PRINT 'EL CLIENTE RECIBIRÁ LA BOLETA MEDIANTE SU CORREO: ' + @email 
		END
		ELSE
			PRINT 'EL CLIENTE RECIBIRÁ LA BOLETA MEDIANTE UN MEDIO FÍSICO'
	ELSE
		PRINT 'EL COMPROBANTE DEL CLIENTE NO ES UNA BOLETA'
END
GO

EXEC MetodoParaRecibirBoleta @codpers=2749