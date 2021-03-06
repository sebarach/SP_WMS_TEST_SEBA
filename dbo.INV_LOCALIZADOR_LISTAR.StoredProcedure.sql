USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_LOCALIZADOR_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : LISTAR Informacion de tabla 
 Parametros
@ID_Holding  : identificador de la tabla
 Creado : .
 Modifado : 1.
 ***********************************************
 --Forma de Invocar.
 ***********************************************
 ***********************************************
*/
CREATE PROCEDURE [dbo].[INV_LOCALIZADOR_LISTAR]
	@ID_Subinv NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0)
AS
BEGIN
SET NOCOUNT ON;

SELECT [ID_Subinv]
      ,[ID_Localizador]
      ,[Nombre_Localizador]
      ,[Segmento1]
      ,[Segmento2]
      ,[Segmento3]
      ,[Segmento4]
      ,[Segmento5]
      ,[Segmento6]
      ,[Combinacion_Localizador]
      ,[ID_Org]
      ,[Largo]
      ,[Ancho]
      ,[Alto]
      ,[Volumen]
      ,LOC.[Cod_Tipo_SubInv]
      ,TIPOSUB.Nombre TIPOINV_NOMBRE
      ,LOC.[Cod_Estado]
      ,EST.NOMBRE ESTADO
      ,[Vigencia]
      ,[Control_Localizador]
  FROM [dbo].[Inventario_SubInv_Localizadores] LOC
	INNER JOIN Inventario_Tipo_SubInventario TIPOSUB
		ON LOC.[Cod_Tipo_SubInv] = TIPOSUB.[Cod_Tipo_SubInv]
	INNER JOIN Inventario_Estado_Localizadores EST
		ON LOC.COD_ESTADO = EST.COD_ESTADO
	WHERE LOC.ID_Subinv = @ID_Subinv AND ID_ORG = @ID_ORG


END
GO
