USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_UNIDADCOBRO_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_UNIDADCOBRO_LISTAR]
	-- Add the parameters for the stored procedure here
	 @ID_HOLDING NUMERIC(18, 0)
	,@COD_SERVICIO NUMERIC(18, 0)
	,@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UC.Cod_Unidad Id
		  ,UC.ID_Holding_Propietario PropietarioId
		  ,P.NOMBRE Propietario
		  ,UC.ID_Org OrganizacionId
		  ,UC.Cod_Servicio CodigoServicio
		  ,S.NOMBRE Servicio
		  ,UC.Cod_Moneda MonedaId
		  ,M.MONEDA Moneda
		  ,UC.Valor_Costo ValorCosto
		  ,UC.Valor_Venta ValorVenta
		  ,UC.Valor_Utilidad ValorUtilidad
		  ,UC.Dias_Mes DiaMes
		  ,UC.Total_Pos_Base TotalPosicionBase
		  ,UC.Tarifa_Diaria TarifaDiaria
		  ,UC.Vigencia Vigencia
		  ,UC.Posicion_Proporcional PosicionProporcional
	FROM Ventas_Unidades_Cobro UC
		INNER JOIN Adm_System_Holding P
			ON UC.ID_Holding_Propietario = P.ID_HOLDING AND UC.ID_ORG = P.ID_ORG AND P.ESPROPIETARIO = 1
		INNER JOIN Ventas_Servicios S
			ON UC.COD_SERVICIO = S.COD_SERVICIO AND UC.ID_ORG = S.ID_ORG 
		INNER JOIN Ventas_Monedas M
			ON UC.COD_MONEDA = M.COD_MONEDA 
	WHERE UC.ID_Holding_Propietario = @ID_HOLDING
		--AND UC.Cod_Servicio = @COD_SERVICIO 
		AND UC.ID_ORG = @ID_ORG
  
	--SELECT * FROM Adm_System_Holding
	
	
END
GO
