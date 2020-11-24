USE NHTest3
GO

CREATE PROCEDURE CancelacionServicio(@codigo INT)
AS
BEGIN
	IF EXISTS (SELECT * FROM OPERACIONES.Servicio S WHERE S.CServicio = @codigo AND S.FDisponible = 1)
	BEGIN
		UPDATE OPERACIONES.Servicio 
		SET FDisponible = 0
		WHERE CServicio = @codigo
		SELECT * FROM OPERACIONES.Servicio S WHERE S.CServicio = @codigo
		PRINT 'SE CANCEL� EL SERVICIO DEBIDO A UN INESPERADO IMPREVISTO'
	END
	ELSE
		PRINT 'ESTE SERVICIO NO PUEDE CANCELARSE PORQUE NO EXISTE O NO EST� DISPONIBLE'
END
GO

EXEC CancelacionServicio 6
GO

UPDATE OPERACIONES.Servicio
SET FDisponible = 1
WHERE CServicio != 4

SELECT * FROM OPERACIONES.Servicio
GO