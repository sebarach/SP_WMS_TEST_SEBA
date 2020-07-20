USE [iwmscl_testwms2]
GO
/****** Object:  StoredProcedure [dbo].[JOB_Actualiza_Prefijo_Lote]    Script Date: 20-07-2020 11:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Percy Ross.
Objetivo : Actualiza Tabla Inventario_Folios_Todos con prefijo lote según cambio de mes
*/
--select * from Inventario_Folios_Todos
CREATE PROCEDURE [dbo].[JOB_Actualiza_Prefijo_Lote]
AS
declare @AnnoMesChar varchar(6),
        @AnnoMesInt int,
        @fechaHoy date,
        @MesTabla int,
        @MesActual int

--Rescata el mes de campo folio_prefijo_lote        
select @MesTabla =  convert (int,right(convert(varchar(6),Folio_Prefijo_Lote),2)) 
from Inventario_Folios_Todos 

--Rescata el mes actual
select @MesActual = MONTH(getdate())

If @MesActual <>  @MesTabla
   BEGIN
        select @fechaHoy =getdate()    
		select @AnnoMesChar = convert(varchar(8),@fechaHoy,112)
        select @AnnoMesInt  = convert(int,@AnnoMesChar)
        update  Inventario_Folios_Todos set Folio_Prefijo_Lote = @AnnoMesInt
   END
ELSE
  PRINT 'No hay cambio de Mes. Actualización no realizada'
GO
