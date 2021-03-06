USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[rebajarStockNegativoFecha]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rebajarStockNegativoFecha]  @lote varchar(60),@en_mano int ,@disponible int,@reserva int,@fechaActualizacion varchar(50)
AS
SET NOCOUNT ON;

declare @codItem int;
declare @nueEnmano int,@nueDisponible int,@nueReserva int;

begin
set @codItem = (select cod_item from Inventario_Lotes where ID_Lote = @lote)

UPDATE Inventario_Stock_Lotes
SET En_Mano = @en_mano
WHERE ID_Lote = @lote  and Fech_Actualiza = @fechaActualizacion;


UPDATE Inventario_Stock_Lotes
SET Disponible = @disponible
WHERE ID_Lote = @lote  and Fech_Actualiza = @fechaActualizacion;


UPDATE Inventario_Stock_Lotes
SET Reserva = @reserva
WHERE ID_Lote = @lote  and Fech_Actualiza = @fechaActualizacion;
END

IF @@ROWCOUNT > 0
select i.ID_Lote,h.Nombre,i.Cod_Item,s.En_Mano,s.Disponible,s.Reserva,s.ID_Localizador,loc.Combinacion_Localizador,s.Fech_Actualiza from Inventario_Stock_Lotes s 
inner join Inventario_Lotes i on s.ID_Lote = i.ID_Lote
inner join Inventario_Items_Prop_Dueños p on i.Cod_Item = p.Cod_Item
inner join Adm_System_Holding h on p.ID_Propietario = h.ID_Holding
inner join Inventario_SubInv_Localizadores loc on s.ID_Localizador = loc.ID_Localizador
where i.Cod_Item = @codItem and i.ID_Lote = @lote
order by s.Fech_Actualiza desc ,i.Cod_Item desc
ELSE
select 'No se pudo modificar el Registro'  Resultado
GO
