USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[SOL_SOLICITUDPROD_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SOL_SOLICITUDPROD_LISTAR]
	-- Add the parameters for the stored procedure here	
	 @Folio_Documento NUMERIC(18, 0)
	,@Id_Docu NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT --Folio_Documento
		  --,Id_Docu
		  --,
		   Nro_Linea
		  ,Descriptor
		  ,Cod_Item
		  ,Cantidad
		  ,Cantidad_Pdte
		  ,Precio
		  ,ID_Lote
		  ,ISNULL((SELECT VALOR_REFERENCIA 
			FROM Inventario_Referencias_Cruzadas CRUZ
			WHERE Inventario_Detalle_Documentos.COD_ITEM = CRUZ.COD_ITEM 
				AND Inventario_Detalle_Documentos.ID_ORG = CRUZ.ID_ORG 
				AND CRUZ.ID_REF_PRED = 1003), 0) SkuAntiguo		  
	  FROM dbo.Inventario_Detalle_Documentos
	  WHERE Folio_Documento = @Folio_Documento AND Id_Docu = @Id_Docu AND ID_ORG = @ID_ORG
		
		
	/*	
		
	*/
	
END
GO
