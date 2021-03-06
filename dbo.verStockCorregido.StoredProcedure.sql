USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[verStockCorregido]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verStockCorregido] 

AS


BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    declare @coditem int;
    declare @cantidad1 int;
    declare @contador int = 1;

    -- Insert statements for procedure here
    -- cursor
DECLARE db_cursor CURSOR FOR 

	select distinct i.Cod_Item  from Inventario_Stock_Lotes s 
    inner join Inventario_Lotes i on s.ID_Lote = i.ID_Lote
    inner join Inventario_Items_Prop_Dueños p on i.Cod_Item = p.Cod_Item
    inner join Adm_System_Holding h on p.ID_Propietario = h.ID_Holding
    inner join Inventario_SubInv_Localizadores loc on s.ID_Localizador = loc.ID_Localizador
    where p.ID_Propietario = 52 and i.Cod_Item between 58000 and 58500;

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @coditem 

WHILE @@FETCH_STATUS = 0  
BEGIN  

      set @cantidad1 = (select sum(Cantidad_TRX) from Inventario_Detalle_Transacciones where Cod_Item = @coditem)

      IF (@cantidad1 > 0)
BEGIN
  print @coditem;
  print @cantidad1  
  print '------------'
END


      FETCH NEXT FROM db_cursor INTO @coditem 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 

   

END
GO
