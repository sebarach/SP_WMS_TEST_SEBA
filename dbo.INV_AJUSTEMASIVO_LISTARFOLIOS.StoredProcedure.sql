USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_AJUSTEMASIVO_LISTARFOLIOS]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Luis Zamorano Gómez
-- Create date: 31-12-2017
-- Description:	Obtiene los inventarios congelados
-- =============================================
--EXEC INV_AJUSTEMASIVO_LISTARFOLIOS 23, 17
CREATE PROCEDURE [dbo].[INV_AJUSTEMASIVO_LISTARFOLIOS]
	-- Add the parameters for the stored procedure here
	@FOLIO NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF (@FOLIO > 0) BEGIN
	    -- Insert statements for procedure here
		SELECT 
			 FOLIO_TOMAINV Folio
			,ISNULL(Convert(varchar(10),CONVERT(date,CONG.FECHA_INV,106),103), '') Fecha
			,DESCRIPCION_INV Descripcion
			,EST.Cod_Estado EstadoId
			,EST.ESTADO Estado
			,FILTRO Filtros
			,(SELECT MAX(ISNULL(CICLO, 0)) FROM Inventario_Congelar_Toma_Inv WHERE FOLIO_TOMAINV = CONG.FOLIO_TOMAINV) CICLOS
			,MIN(ISNULL(CICLO, 0)) CICLO_ACTUAL	
		FROM Inventario_Congelar_Toma_Inv CONG
			INNER JOIN Inventario_Estado_Toma_Inv EST
				ON CONG.COD_ESTADO = EST.Cod_Estado
		WHERE FOLIO_TOMAINV = @FOLIO --23
			AND ID_ORG = @ID_ORG --17
			AND EST.COD_ESTADO IN(1, 2)
		GROUP BY 
			 FOLIO_TOMAINV
			,Convert(varchar(10),CONVERT(date,CONG.FECHA_INV,106),103)
			,DESCRIPCION_INV
			,EST.Cod_Estado
			,EST.Estado
			,FILTRO			
			,CONG.ID_ORG			
		UNION
		SELECT 
			 FOLIO_TOMAINV Folio
			,ISNULL(Convert(varchar(10),CONVERT(date,CONG.FECHA_INV,106),103), '') Fecha
			,DESCRIPCION_INV Descripcion
			,EST.Cod_Estado EstadoId
			,EST.ESTADO Estado
			,FILTRO Filtros
			,(SELECT MAX(ISNULL(CICLO, 0)) FROM Inventario_Congelar_Toma_Inv WHERE FOLIO_TOMAINV = CONG.FOLIO_TOMAINV) CICLOS
			--,CASE
			--	WHEN EST.Cod_Estado IN(1, 2, 3, 4) THEN MIN(ISNULL(CICLO, 0))
			--	ELSE 0
			,MIN(ISNULL(CICLO, 0)) CICLO_ACTUAL	
		FROM Inventario_Congelar_Toma_Inv CONG
			INNER JOIN Inventario_Estado_Toma_Inv EST
				ON CONG.COD_ESTADO = EST.Cod_Estado
		WHERE FOLIO_TOMAINV = @FOLIO --23
			AND ID_ORG = @ID_ORG --17
			AND EST.COD_ESTADO IN(3, 4)
		GROUP BY 
			 FOLIO_TOMAINV
			,Convert(varchar(10),CONVERT(date,CONG.FECHA_INV,106),103)
			,DESCRIPCION_INV
			,EST.Cod_Estado
			,EST.Estado
			,FILTRO			
			,CONG.ID_ORG	
			,CONG.CICLO	
		ORDER BY FOLIO_TOMAINV DESC	
	END 
	ELSE BEGIN
		SELECT 
			 FOLIO_TOMAINV Folio
			,ISNULL(Convert(varchar(10),CONVERT(date,CONG.FECHA_INV,106),103), '') Fecha
			,DESCRIPCION_INV Descripcion
			,EST.Cod_Estado EstadoId
			,EST.ESTADO Estado
			,FILTRO Filtros
			,(SELECT MAX(ISNULL(CICLO, 0)) FROM Inventario_Congelar_Toma_Inv WHERE FOLIO_TOMAINV = CONG.FOLIO_TOMAINV) CICLOS
			,MIN(ISNULL(CICLO, 0)) CICLO_ACTUAL	
		FROM Inventario_Congelar_Toma_Inv CONG
			INNER JOIN Inventario_Estado_Toma_Inv EST
				ON CONG.COD_ESTADO = EST.Cod_Estado
		WHERE ID_ORG = @ID_ORG --17
			AND EST.COD_ESTADO IN(1, 2)
		GROUP BY 
			 FOLIO_TOMAINV
			,Convert(varchar(10),CONVERT(date,CONG.FECHA_INV,106),103)
			,DESCRIPCION_INV
			,EST.Cod_Estado
			,EST.Estado
			,FILTRO			
			,CONG.ID_ORG			
		UNION 
		SELECT 
			 FOLIO_TOMAINV Folio
			,ISNULL(Convert(varchar(10),CONVERT(date,CONG.FECHA_INV,106),103), '') Fecha
			,DESCRIPCION_INV Descripcion
			,EST.Cod_Estado EstadoId
			,EST.ESTADO Estado
			,FILTRO Filtros
			,(SELECT MAX(ISNULL(CICLO, 0)) FROM Inventario_Congelar_Toma_Inv WHERE FOLIO_TOMAINV = CONG.FOLIO_TOMAINV) CICLOS
			--,CASE
			--	WHEN EST.Cod_Estado IN(1, 2, 3, 4) THEN MIN(ISNULL(CICLO, 0))
			--	ELSE 0
			,MIN(ISNULL(CICLO, 0)) CICLO_ACTUAL	
		FROM Inventario_Congelar_Toma_Inv CONG
			INNER JOIN Inventario_Estado_Toma_Inv EST
				ON CONG.COD_ESTADO = EST.Cod_Estado
		WHERE ID_ORG = @ID_ORG --17
			--AND CONG.COD_ESTADO IN(1,3)
			AND EST.COD_ESTADO IN(3, 4)
		GROUP BY 
			 FOLIO_TOMAINV
			,Convert(varchar(10),CONVERT(date,CONG.FECHA_INV,106),103)
			,DESCRIPCION_INV
			,EST.Cod_Estado
			,EST.Estado
			,FILTRO			
			,CONG.ID_ORG	
			,CONG.CICLO	
		ORDER BY FOLIO_TOMAINV DESC	
	END
	
	
	
	
	
END
GO
