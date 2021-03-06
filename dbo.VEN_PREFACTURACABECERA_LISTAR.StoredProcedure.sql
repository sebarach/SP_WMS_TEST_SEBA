USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[VEN_PREFACTURACABECERA_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VEN_PREFACTURACABECERA_LISTAR]
--DECLARE
	 @Folio_Pref numeric(18, 0),
	 @ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	IF @Folio_Pref > 0 BEGIN
	
		SELECT 
		   [Folio_Pref] Folio
		  ,[Mes] Mes
		  ,[Año] Anio
		  ,P.ID_Holding_Propietario PropietarioId
		  ,P.ID_Dueño DuenoId
		  ,P.Cod_Centro CodCentro
		  ,ISNULL(Convert(varchar(10),CONVERT(date,Fecha_Emision,106),103), '') FechaEmision
		  ,ISNULL(P.Observaciones, '') Nota
		  ,ISNULL([Email], '') Email
		  ,P.Cod_Estado CodEstado
		  ,ESTADO.Estado Estado
		  ,PROP.NOMBRE Propietario
		  ,ISNULL(C.NOMBRES, '') + ' ' + ISNULL(C.APELLIDO_PATERNO, '') Dueno	
		  ,DIR.CALLE + ' #' + DIR.NUMERO + ', ' + COMUNA.NOMBRE  Direccion
		  ,PROP.RUT
		  ,CC.NOMBRE_CC Centro	   
		FROM Ventas_Cabecera_Prefactura P
			INNER JOIN Ventas_Estado_Prefact ESTADO
				ON P.Cod_Estado = ESTADO.Cod_Estado 
			INNER JOIN Adm_System_Dueños D
				ON P.ID_Dueño = D.ID_DUEÑO AND P.ID_Org = D.ID_ORG
			INNER JOIN Adm_System_Contactos C
				ON D.ID_CONTACTO = C.ID_CONTACTO AND D.ID_ORG = C.ID_ORG
			INNER JOIN Adm_System_Holding PROP
				ON P.ID_Holding_Propietario = PROP.ID_HOLDING AND P.ID_Org = PROP.ID_ORG AND PROP.ESPROPIETARIO = 1
			INNER JOIN Adm_System_Direcciones DIR
				ON PROP.Id_Direccion = DIR.ID_DIRECCION
			INNER JOIN Adm_System_Comunas COMUNA
				ON DIR.ID_COMUNA = COMUNA.ID_COMUNA
			INNER JOIN Adm_System_Provincias PROVINCIA
				ON COMUNA.ID_PROVINCIA = PROVINCIA.ID_PROVINCIA
			INNER JOIN Ventas_Centros_Costos_Propietarios CC
				ON P.Cod_Centro = CC.COD_CENTRO AND P.ID_Holding_Propietario = CC.ID_HOLDING_PROPIETARIO AND P.ID_Org = CC.ID_ORG
		WHERE P.ID_ORG = @ID_ORG AND CAST(Folio_Pref AS VARCHAR(18)) LIKE CAST(@Folio_Pref AS VARCHAR(18)) + '%'
		ORDER BY Folio_Pref DESC
	
	END
	ELSE BEGIN
	
		SELECT 
		   [Folio_Pref] Folio
		  ,[Mes] Mes
		  ,[Año] Anio
		  ,P.ID_Holding_Propietario PropietarioId
		  ,P.ID_Dueño DuenoId
		  ,[Cod_Centro] CodCentro
		  ,ISNULL(Convert(varchar(10),CONVERT(date,Fecha_Emision,106),103), '') FechaEmision
		  ,ISNULL([Observaciones], '') Nota
		  ,ISNULL([Email], '') Email
		  ,P.Cod_Estado CodEstado
		  ,ESTADO.Estado Estado
		  ,PROP.NOMBRE Propietario
		  ,ISNULL(C.NOMBRES, '') + ' ' + ISNULL(C.APELLIDO_PATERNO, '') + ' ' + ISNULL(C.APELLIDO_MATERNO, '') Dueno	
		  ,'' Direccion
		  ,'' Rut
		  ,'' Centro			  		  
		FROM Ventas_Cabecera_Prefactura P
			INNER JOIN Ventas_Estado_Prefact ESTADO
				ON P.Cod_Estado = ESTADO.Cod_Estado
			INNER JOIN Adm_System_Dueños D
				ON P.ID_Dueño = D.ID_DUEÑO AND P.ID_Org = D.ID_ORG
			INNER JOIN Adm_System_Contactos C
				ON D.ID_CONTACTO = C.ID_CONTACTO AND D.ID_ORG = C.ID_ORG
			INNER JOIN Adm_System_Holding PROP
				ON P.ID_Holding_Propietario = PROP.ID_HOLDING AND P.ID_Org = PROP.ID_ORG AND PROP.ESPROPIETARIO = 1				
		WHERE P.ID_ORG = @ID_ORG
		ORDER BY Folio_Pref DESC	
	
	END
	

					

	--SELECT 
	--	 DP.*, LOTE.FECHA_ORIGEN
	--FROM Ventas_Dias_Permanencia DP
	--	INNER JOIN INVENTARIO_LOTES LOTE
	--		ON DP.ID_LOTE = LOTE.ID_LOTE
	--WHERE DP.Año = @Año 
	--	AND DP.Mes = @Mes
	--	AND DP.ID_Holding_Propietario = @ID_Holding_Propietario
	--	AND DP.ID_Dueño = @ID_Dueño	

			
		
	
	
	

	--ELSE BEGIN 
	
	
	--END	

	--ROLLBACK
	
	/*
	SELECT * FROM Ventas_Cabecera_Prefactura
	
	SELECT * FROM Ventas_Detalle_Prefactura
	
	SELECT * FROM Ventas_Totales_Factura
	
	
	*/
	

	
	
END
GO
