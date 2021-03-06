USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[verStockReal]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[verStockReal]  @coditem int
AS
SET NOCOUNT ON;
declare @total1 int,@total2 int , @total3 int;

set @total1 = (select sum(cantidad) from Inventario_Detalle_Recepcion where Cod_Item =  @coditem)
set @total2 = (select sum(Cant_Despacho)from Inventario_Detalle_Pedidos where Cod_Item =  @coditem)
set @total3 = @total1 - @total2

select @total3 TOTAL;
GO
