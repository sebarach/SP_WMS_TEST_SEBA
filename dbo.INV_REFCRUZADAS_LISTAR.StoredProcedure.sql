USE [iwmscl_testwms2]
GO
/****** Object:  StoredProcedure [dbo].[INV_REFCRUZADAS_LISTAR]    Script Date: 20-07-2020 11:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[INV_REFCRUZADAS_LISTAR]
	@COD_ITEM NUMERIC(18, 0),
	@ID_Ref_Pred NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0)
AS
SET NOCOUNT ON;

SELECT IDREF
	  ,[Cod_Item]
      ,[ID_Ref_Pred]
      ,[Referencia_Cruzada]
      ,[Valor_Referencia]
      ,Vigencia
FROM [dbo].[Inventario_Referencias_Cruzadas]
WHERE Cod_Item = @COD_ITEM AND ID_Ref_Pred = @ID_Ref_Pred
GO
