USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[loopsSeba]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[loopsSeba]

as

DECLARE @cnt INT = 0;
declare @start int = 59498;
DECLARE @val INT = 0;
DECLARE @VAL2 VARCHAR(50) = '';
WHILE @cnt < 56
BEGIN
SET NOCOUNT ON;


   SET @VAL2 ='/images/productos/'+CAST(@start AS varchar)+'.jpg';

   print @VAL2;
   print @start;

   update Inventario_Items
   set Ficha_Imagen  = @VAL2
   where  Cod_Item = @start;

   SET @start = @start +1;
   set @cnt = @cnt + 1;



END;
GO
