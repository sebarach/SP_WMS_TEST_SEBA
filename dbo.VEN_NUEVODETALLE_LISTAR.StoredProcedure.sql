USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_NUEVODETALLE_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_NUEVODETALLE_LISTAR]
	-- Add the parameters for the stored procedure here
	 @ID_HOLDING_PROPIETARIO NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @CODIGO NUMERIC(18, 0)

	DECLARE @TABLA TABLE(CODIGO NUMERIC(18, 0), VALOR NUMERIC(18, 8))

	DECLARE CTIPOCAMBIO CURSOR FOR
	SELECT 
		DISTINCT Cod_Moneda 
	FROM Ventas_Tipo_Cambio



	OPEN CTIPOCAMBIO

	FETCH CTIPOCAMBIO INTO @CODIGO

	WHILE (@@FETCH_STATUS = 0) BEGIN
		
		INSERT INTO @TABLA	
		SELECT TOP 1
			Cod_Moneda
		   ,Valor
		FROM Ventas_Tipo_Cambio
		WHERE VIGENCIA = 'S' AND Cod_Moneda = @CODIGO
		ORDER BY AÑO DESC, MES DESC, DIA DESC

		FETCH CTIPOCAMBIO INTO @CODIGO

	END

	CLOSE CTIPOCAMBIO

	DEALLOCATE CTIPOCAMBIO


	--SELECT CODIGO, VALOR FROM @TABLA

	SELECT 
		 UC.COD_SERVICIO CodigoServicio
		,S.NOMBRE Servicio
		,CAST(UC.VALOR_VENTA AS NUMERIC(18, 2)) ValorVenta
		,M.MONEDA TipoMoneda
		,CAST(T.VALOR AS NUMERIC(18, 2)) ValorMoneda
		,CAST(UC.Tarifa_Diaria AS NUMERIC(18, 5)) TarifaDiaria
	FROM Ventas_Unidades_Cobro UC
		INNER JOIN dbo.Ventas_Servicios S
			ON UC.COD_SERVICIO = S.COD_SERVICIO		
		INNER JOIN VENTAS_MONEDAS M
			ON UC.COD_MONEDA = M.COD_MONEDA
		INNER JOIN @TABLA T
			ON M.COD_MONEDA = T.CODIGO
	WHERE ID_HOLDING_PROPIETARIO = @ID_HOLDING_PROPIETARIO--52
		AND UC.VIGENCIA = 'S'
		AND S.VIGENCIA = 'S'
		AND M.VIGENCIA = 'S'

	
	
	
	
END
GO
