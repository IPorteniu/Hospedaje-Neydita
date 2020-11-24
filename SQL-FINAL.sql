












/*/16.   Se revisaría que los empleados hayan recibido una reduccion de su sueldo como mínimo en 5% que es el estipulado por mutuoa acuerdo a aquellos trabajadores que teienen menos de 5 años con nostros.*/


create function local_employees(@date int)
returns table
as
return(SELECT e.CEmpleado, YEAR(e.DContratacion)as anio,e.MSueldo FROM FINANZAS.Empleado e
where @date - YEAR(e.DContratacion) < 5 );
GO


CREATE procedure desc_employees
(
@sueldo float
)
as
begin
 If (SELECT COUNT(*) AS ANIO FROM FINANZAS.Empleado e
 WHERE year(e.DContratacion) in (select p.anio from local_employees(2020) p))>0
  begin
     UPDATE	FINANZAS.Empleado
	 SET		MSueldo = MSueldo - @sueldo*MSueldo
   end
end
GO
 
 DECLARE @sueldo float
 set @sueldo = 0.05
 EXEC desc_employees @sueldo

 select * from FINANZAS.Empleado

 /*procedimento con funcion*/
insert into Rol
select *from Servicio
SELECT *FROM Empleado
SELECT * FROM ROL

/*17.   Debido a ciertos protocolos alimenticios del hotel  Si existen snacks que estás por debajo de la cantidad mínimo  que son menos de  35 unidades se debe hacer un procedimiento que haga el procedimiento necesario para saber si esta sucediendo esto*/
/*Proc notificacion */
insert into OPERACIONES.Snack values(11,123)
select * from OPERACIONES.Snack
select * from OPERACIONES.Producto

create function fx_snack()returns int
as
begin
declare @f money
select @f = avg(s.QCant_stock)
       from OPERACIONES.Snack s
if @f is null
   set @f=0
return @f
end
go

select * from OPERACIONES.Snack
select * from FINANZAS.Lote
select * from FINANZAS.Proveedor

 dbo.fx_snack()
create procedure pro_snack
AS
BEGIN
declare @promedio  int
set @promedio = DBO.fx_snack()
print (@promedio)
  IF (SELECT COUNT(*) FROM OPERACIONES.Snack s WHERE s.QCant_stock > @promedio) > (SELECT COUNT(*) FROM OPERACIONES.Snack s )
       BEGIN
	   PRINT('HAY MAS INSUMOS CON MAYOR CANTIDAD QUE EL PROM')
	   end
  ELSE
	 BEGIN
	   PRINT('HAY MENOS INSUMOS CON MAYOR CANTIDAD QUE EL PROMEDIO')
	   end
end
go

exec pro_snack



/*17.MARCAR COMO CANCELADO*/

create Trigger TR_Facturas
ON  Marketing.Reserva for insert
As
set nocount on
update Reserva set FCancelado = 1
from inserted inner join Reserva
on inserted.CReserva = Reserva.CReserva
go

insert into MARKETING.Reserva values (18,1,null,convert(datetime,'20-11-20 10:34:09 AM',5),null,0)

/*20.El equipo de marketing requiere hacer promociones en platos. Por lo tanto, necesita una función que permita ingresar el plato y modificar su preciopara reservas de julio.*/

alter function fx_mark(@Aanio int)
returns table
as
return(select r.DInicioEstadia as anio from MARKETING.Reserva r
where (MONTH(r.DInicioEstadia) = 7) and (YEAR(r.DInicioEstadia) >= @Aanio))

select*from dbo.fx_mark(2015)

create procedure Proc_result
(
@descount float
)
as
 begin
   if ( select COUNT(*) from dbo.fx_mark(2015) p WHERE p.anio IN (select r.DInicioEstadia from MARKETING.Reserva r)) > 0
    begin
	  UPDATE OPERACIONES.PRODUCTO
	  SET MPrecio = MPrecio - MPrecio*@descount
	  print('Exitoso')
	  end
	  else
	  print('No hay reservas en julio')
	
 end
GO
select * from OPERACIONES.PRODUCTO
exec Proc_result 0.015

SELECT * FROM Producto
select * from Reserva


Create Trigger TRG_PLATO


/*create trigger tg_estado_habitacion
on Reserva_Habitacion
for Insert
as begin
		update Habitacion
		set FOcupado = 1
		from Habitacion h join inserted e on e.CHabitacion=h.CHabitacion
		where e.CHabitacion = h.CHabitacion
end

/*prueba:*/ 
insert into Reserva_Habitacion(CReserva,CHabitacion) values (12,103)

select h.FOcupado
from Habitacion h
where h.CHabitacion=103*/



