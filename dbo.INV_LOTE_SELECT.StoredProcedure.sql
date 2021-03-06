USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_LOTE_SELECT]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_LOTE_SELECT 1, 25581, 17
CREATE PROCEDURE [dbo].[INV_LOTE_SELECT] 
	-- Add the parameters for the stored procedure here
	 @ID_REPCEPCION NUMERIC(18, 0)
	,@Cod_Item numeric(18, 0)
	,@ID_Org numeric(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DET.Nro_Linea
		  ,LOTE.ID_Lote --Lote interno
		  --,Fecha_Origen
		  ,ISNULL(Convert(varchar(10),CONVERT(date,LOTE.Fecha_Expira,106),103), '') Fecha_Expira --Fecha vencimiento
		  ,LOTE.Lote_Proveedor --Lote proveedor
		  ,lote.Cod_Item 
		  ,det.cantidad
		  ,DET.Cantidad_Falta
		  ,DET.Cantidad_Excede
	  FROM dbo.Inventario_Lotes LOTE
		INNER JOIN Inventario_Detalle_Recepcion DET
			ON LOTE.Cod_Item = DET.Cod_Item AND LOTE.ID_Lote = DET.ID_Lote AND LOTE.ID_Org = DET.ID_Org
	  WHERE --LOTE.Cod_Item = @Cod_Item AND 
		LOTE.ID_Org = @ID_Org AND DET.ID_Recepcion = @ID_REPCEPCION
	  ORDER BY DET.Nro_Linea ASC
	  
	  /*
	  
	SELECT [ID_Lote]
		  ,[Fecha_Origen]
		  ,[Fecha_Expira]
		  ,[Lote_Proveedor]
		  ,[Cod_Item]
		  ,[ID_Org]
		  ,[ID_Usro_Crea]
		  ,[ID_Usro_Act]
		  ,[Fech_Creacion]
		  ,[Fech_Actualiza]
	  FROM [dbo].[Inventario_Lotes]	  
	  
	SELECT [ID_Recepcion]
		  ,[Nro_Linea]
		  ,[Cod_Item]
		  ,[Cantidad]
		  ,[Cantidad_Excede]
		  ,[Cantidad_Falta]
		  ,[ID_Lote]
		  ,[ID_Org]
		  ,[ID_TRX_Recep]
	  FROM [dbo].[Inventario_Detalle_Recepcion]	  
	  
	  
		SELECT [Folio_Documento]
			  ,[Id_Docu]
			  ,[Nro_Linea]
			  ,[Descriptor]
			  ,[Cod_Item]
			  ,[Cantidad]
			  ,[Cantidad_Pdte]
			  ,[Precio]
			  ,[Id_Org]
			  ,[ID_Lote]
		  FROM [dbo].[Inventario_Detalle_documentos]	  
	   
	  
	  
	  SELECT * FROM Inventario_Folios_Todos
	  
	  
	  
	  
	  
	  
	  */
	  
	  
	  
END
GO
