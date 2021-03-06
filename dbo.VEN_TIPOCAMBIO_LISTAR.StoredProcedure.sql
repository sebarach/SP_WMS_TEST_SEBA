USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_TIPOCAMBIO_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_TIPOCAMBIO_LISTAR]
	-- Add the parameters for the stored procedure here
	 @COD_MONEDA NUMERIC(18, 0)
	,@ANIO NUMERIC(18, 0)
	,@MES NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TC.Cod_Moneda MonedaId
		  ,M.Moneda
		  ,TC.Año Anio
		  ,TC.Mes Mes
		  ,TC.Dia Dia
		  ,TC.Valor Valor
		  ,TC.Vigencia Vigencia
	FROM Ventas_Tipo_Cambio TC
		INNER JOIN Ventas_Monedas M
			ON TC.Cod_Moneda = M.Cod_Moneda
	WHERE TC.Cod_Moneda = @COD_MONEDA
			and Año = @ANIO
			AND Mes = @MES
	
	
	
END
GO
