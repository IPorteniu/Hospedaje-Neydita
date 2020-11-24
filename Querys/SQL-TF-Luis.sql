use NHTest3
go

--Muestra cantidad de visitas realizadas por año por huesped

create view vw_visitasxhuesped
as
select h.CHuesped,count(r.CReserva) as 'Visitas' ,YEAR(r.DInicioEstadia) 'año'
from VENTAS.Huesped as h
join VENTAS.Huesped_Reserva as hr
	on hr.CHuesped = h.CHuesped
join MARKETING.Reserva as r
	on r.CReserva = hr.CReserva
where h.FAdulto = 1 
group by h.CHuesped, year(r.DInicioEstadia)
go

-- Funcion que devuelve las temporadas altas del hotel segun los parametros ingresados
create function [MARKETING].[fn_temporadas_altas]
	(
	@mesI int,
	@mesF int,
	@año int
	)
returns table 
as
	return
	(
		select count(h.CHuesped) 'Cantidad de huespedes', MONTH(r.DInicioEstadia) 'Mes del año',year(r.DInicioEstadia) as 'Año'
		  from marketing.Reserva as r
		  join ventas.Huesped_Reserva as h
		  on h.CReserva = r.CReserva
		  where  
					MONTH(r.DInicioEstadia)	between		@mesI			and			@mesF			and year(r.DInicioEstadia) = @año
				or	MONTH(r.DInicioEstadia) =			@mesI			and			@mesF is null	and	year(r.DInicioEstadia) = @año
				or										@mesI is null	and			@mesF is null 	and	year(r.DInicioEstadia) = @año
				or	MONTH(r.DInicioEstadia)	between		@mesI			and			@mesF			and		@año is null
				or	MONTH(r.DInicioEstadia) =			@mesI			and			@mesF is null	and		@año is null
		  group by	MONTH(r.DInicioEstadia),year(r.DInicioEstadia)
	)
GO

--


create view [VENTAS].[vw_monto_consumo] as
select r.CReserva, sum(p.MPrecio*dc.QConsumo) 'Monto Consumo'
from MARKETING.Reserva r 
left join OPERACIONES.Detalle_Consumo dc on dc.CReserva = r.CReserva 
left join OPERACIONES.Producto p on dc.CProducto = p.CProducto
group by r.CReserva
go

create view [VENTAS].[vw_monto_hab] as
select r.CReserva,h.NHabitacion,th.MPrecio,datediff(day, r.DInicioEstadia,r.DFinEstadia) 'Días de estadía' ,(th.MPrecio*datediff(day, r.DInicioEstadia,r.DFinEstadia)) 'Monto de estadía' 
from MARKETING.Reserva r 
left join OPERACIONES.Reserva_Habitacion rh on rh.CReserva = r.CReserva 
left join OPERACIONES.Habitacion h on h.NHabitacion = rh.CHabitacion 
left join OPERACIONES.Tipo_Habitacion th on th.CTipo_Habitacion = h.CTipo_Habitacion
go

create view [VENTAS].[vw_monto_servicio] as
select r.CReserva, sum(MPrecio) 'Monto Servicio'
from MARKETING.Reserva r 
left join OPERACIONES.Detalle_Servicio ds on ds.Reserva_CReserva = r.CReserva 
left join OPERACIONES.Servicio s on s.CServicio = ds.Servicio_CServicio
group by r.CReserva
go

create view vw_monto_total as
select v1.CReserva, SUM((v1.[Monto Consumo]+v2.[Monto de estadía]+v3.[Monto Servicio])*(1-c.NumDescuento)) as 'Monto_Total'
from VENTAS.vw_monto_consumo v1 
join VENTAS.vw_monto_hab v2 on v1.CReserva = v2.CReserva 
join VENTAS.vw_monto_servicio v3 on v1.CReserva = v3.CReserva 
join VENTAS.Huesped_Reserva hr on hr.CReserva = v1.CReserva 
join VENTAS.Huesped h on h.CHuesped = hr.CHuesped 
join VENTAS.Huesped_Categoria hc on hc.CHuesped = h.CHuesped 
join VENTAS.Categoria c on c.CCategoria = hc.CCategoria
group by v1.CReserva
go

--Se crea procedimiento que actualiza el comprobante recibiendo un ID de parametro
create procedure VENTAS.uspGenerarComprobante
	@CReserva int
as begin
	update MARKETING.Comprobante set MMonto=v1.Monto_Total
	from vw_monto_total v1
	where MARKETING.comprobante.CComprobante = (select r.CComprobante from MARKETING.Reserva as r where r.CReserva = @CReserva) 
							and v1.CReserva = @CReserva
print concat(N'Comprobante actualizado satisfactoriamente para la Reserva con numero ', @CReserva)
end
 exec ventas.uspGenerarComprobante 1

 select * from MARKETING.Comprobante


