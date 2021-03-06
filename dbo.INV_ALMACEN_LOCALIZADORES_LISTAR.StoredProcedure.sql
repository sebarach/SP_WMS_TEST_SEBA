USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_ALMACEN_LOCALIZADORES_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_ALMACEN_LOCALIZADORES_LISTAR 50, 'DSC.0.1.S.1', 17 --DSC.0.1.S.3.044
CREATE PROCEDURE [dbo].[INV_ALMACEN_LOCALIZADORES_LISTAR] 
	-- Add the parameters for the stored procedure here
	 @ID_SUBINV NUMERIC(18, 0)
	,@COMBINACION_LOCALIZADOR VARCHAR(50)
	,@ID_ORG NUMERIC(18, 0)
	--,@ID_LOTE VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT --LOC.ID_Subinv
		   LOC.ID_Localizador
		  ,LOC.Combinacion_Localizador
		  ,LOC.Volumen
		  --,Espacio_Disponible
		  --,Espacio_Utilizado
	  FROM dbo.Inventario_SubInv_Localizadores LOC
	  WHERE LOC.Cod_Tipo_SubInv = 200
		AND LOC.VIGENCIA = 'S'
		--AND ISNULL(SUGERIDO, 0) <> 1
		AND LOC.COD_ESTADO = 1
		AND LOC.ID_SUBINV = @ID_SUBINV
		AND LOC.ID_ORG = @ID_ORG
		AND COMBINACION_LOCALIZADOR LIKE @COMBINACION_LOCALIZADOR + '%'
		--AND LOC.ESPACIO_UTILIZADO = 0 --SI TIENE TODO EL ESPACIO DISPONIBLE
		--AND --LOC.VOLUMEN >= CANTIDAD LOTE * VOLUMENT DE PRODUCTO
	  ORDER BY LOC.ID_Localizador ASC, LOC.Volumen ASC

END

--SELECT * FROM Inventario_SubInv_Localizadores
GO
