USE [iwmscl_testwms2]
GO
/****** Object:  StoredProcedure [dbo].[verStockReal]    Script Date: 20-07-2020 11:56:18 ******/
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
