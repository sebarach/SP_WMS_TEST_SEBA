USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_SOLICITUD_PRODUCTO_LISTAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_SOLICITUD_PRODUCTO_LISTAR]
	-- Add the parameters for the stored procedure here	
	@Descriptor_Corta VARCHAR(256),
	@ID_PROPIETARIO NUMERIC(18, 0),
	@ID_DUENO NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0),
	@SKU_ANTIGUO VARCHAR(MAX),
	@SKU NUMERIC(18, 0)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    IF @SKU > 0 BEGIN 
    
		SELECT H.ID_HOLDING
			  ,H.NOMBRE PROPIETARIO
			  ,D.ID_DUEÑO
			  ,C.NOMBRES + ' ' + C.APELLIDO_PATERNO + ' ' + C.APELLIDO_MATERNO CONTACTO
			  ,P.COD_ITEM
			  ,P.Descriptor_Corta Descriptor_Larga
			  ,P.PRECIO_COMPRA
			  ,ISNULL(SUM(STOCK.EN_MANO), 0) EnMano
			  ,ISNULL(SUM(STOCK.DISPONIBLE), 0) Disponible
			  ,ISNULL(SUM(STOCK.RESERVA), 0) Reserva			  
		FROM Inventario_Items_Prop_Dueños PD
			INNER JOIN Inventario_Items P
				ON PD.Cod_Item = P.Cod_Item AND PD.ID_Org = P.ID_Org
			INNER JOIN Adm_System_Holding H
				ON PD.ID_Propietario = H.ID_HOLDING AND PD.ID_Org = H.ID_ORG
			INNER JOIN Adm_System_Dueños D
				ON PD.ID_Dueño = D.ID_DUEÑO AND PD.ID_Org = D.ID_ORG
			INNER JOIN Adm_System_Contactos C
				ON D.ID_CONTACTO = C.ID_CONTACTO AND D.ID_ORG = C.ID_ORG
			--INNER JOIN Inventario_Referencias_Cruzadas CRUZ
			--	ON P.COD_ITEM = CRUZ.COD_ITEM AND P.ID_ORG = CRUZ.ID_ORG
			--CAMPOS DE LECTURA SOLAMENTE
			LEFT JOIN INVENTARIO_LOTES LOTE
				ON P.COD_ITEM = LOTE.COD_ITEM AND P.ID_ORG = LOTE.ID_ORG
			LEFT JOIN INVENTARIO_STOCK_LOTES STOCK
				ON LOTE.ID_LOTE = STOCK.ID_LOTE AND LOTE.ID_ORG = STOCK.ID_ORG			
		WHERE --H.ESPROPIETARIO = 1 AND 
				P.ID_Org = @ID_ORG
			AND P.Vigencia = 'S'
			AND H.VIGENCIA = 'S'
			AND D.VIGENCIA = 'S'
			AND C.VIGENCIA = 'S'
			--AND P.Descriptor_Corta LIKE @Descriptor_Corta + '%' 
			--AND CRUZ.VALOR_REFERENCIA = @SKU_ANTIGUO
			AND PD.ID_Propietario = @ID_PROPIETARIO
			AND PD.ID_Dueño = @ID_DUENO
			--AND CRUZ.ID_REF_PRED = 1003
			AND P.COD_ITEM = @SKU
			--AND stock.Disponible > 0
		GROUP BY 
			   H.ID_HOLDING
			  ,H.NOMBRE
			  ,D.ID_DUEÑO
			  ,C.NOMBRES + ' ' + C.APELLIDO_PATERNO + ' ' + C.APELLIDO_MATERNO 
			  ,P.COD_ITEM
			  ,P.Descriptor_Corta 
			  ,P.PRECIO_COMPRA				
		
	END     
    
    IF @SKU_ANTIGUO <> '' BEGIN 
    
		SELECT H.ID_HOLDING
			  ,H.NOMBRE PROPIETARIO
			  ,D.ID_DUEÑO
			  ,C.NOMBRES + ' ' + C.APELLIDO_PATERNO + ' ' + C.APELLIDO_MATERNO CONTACTO
			  ,P.COD_ITEM
			  ,P.Descriptor_Corta Descriptor_Larga
			  ,P.PRECIO_COMPRA
			  ,ISNULL(SUM(STOCK.EN_MANO), 0) EnMano
			  ,ISNULL(SUM(STOCK.DISPONIBLE), 0) Disponible
			  ,ISNULL(SUM(STOCK.RESERVA), 0) Reserva			  
		FROM Inventario_Items_Prop_Dueños PD
			INNER JOIN Inventario_Items P
				ON PD.Cod_Item = P.Cod_Item AND PD.ID_Org = P.ID_Org
			INNER JOIN Adm_System_Holding H
				ON PD.ID_Propietario = H.ID_HOLDING AND PD.ID_Org = H.ID_ORG
			INNER JOIN Adm_System_Dueños D
				ON PD.ID_Dueño = D.ID_DUEÑO AND PD.ID_Org = D.ID_ORG
			INNER JOIN Adm_System_Contactos C
				ON D.ID_CONTACTO = C.ID_CONTACTO AND D.ID_ORG = C.ID_ORG
			INNER JOIN Inventario_Referencias_Cruzadas CRUZ
				ON P.COD_ITEM = CRUZ.COD_ITEM AND P.ID_ORG = CRUZ.ID_ORG
			--CAMPOS DE LECTURA SOLAMENTE
			LEFT JOIN INVENTARIO_LOTES LOTE
				ON P.COD_ITEM = LOTE.COD_ITEM AND P.ID_ORG = LOTE.ID_ORG
			LEFT JOIN INVENTARIO_STOCK_LOTES STOCK
				ON LOTE.ID_LOTE = STOCK.ID_LOTE AND LOTE.ID_ORG = STOCK.ID_ORG				
		WHERE --H.ESPROPIETARIO = 1 AND 
				P.ID_Org = @ID_ORG
			AND P.Vigencia = 'S'
			AND H.VIGENCIA = 'S'
			AND D.VIGENCIA = 'S'
			AND C.VIGENCIA = 'S'
			--AND P.Descriptor_Corta LIKE @Descriptor_Corta + '%' 
			AND CRUZ.VALOR_REFERENCIA = @SKU_ANTIGUO
			AND PD.ID_Propietario = @ID_PROPIETARIO
			AND PD.ID_Dueño = @ID_DUENO
			AND CRUZ.ID_REF_PRED = 1003
			--AND stock.Disponible > 0
		GROUP BY 
			   H.ID_HOLDING
			  ,H.NOMBRE
			  ,D.ID_DUEÑO
			  ,C.NOMBRES + ' ' + C.APELLIDO_PATERNO + ' ' + C.APELLIDO_MATERNO 
			  ,P.COD_ITEM
			  ,P.Descriptor_Corta 
			  ,P.PRECIO_COMPRA				
		
	END 
	
	IF @Descriptor_Corta <> '' BEGIN
	
		SELECT H.ID_HOLDING
			  ,H.NOMBRE PROPIETARIO
			  ,D.ID_DUEÑO
			  ,C.NOMBRES + ' ' + C.APELLIDO_PATERNO + ' ' + C.APELLIDO_MATERNO CONTACTO
			  ,P.COD_ITEM
			  ,P.Descriptor_Corta Descriptor_Larga
			  ,P.PRECIO_COMPRA
			  ,ISNULL(SUM(STOCK.EN_MANO), 0) EnMano
			  ,ISNULL(SUM(STOCK.DISPONIBLE), 0) Disponible
			  ,ISNULL(SUM(STOCK.RESERVA), 0) Reserva			  
		FROM Inventario_Items_Prop_Dueños PD
			INNER JOIN Inventario_Items P
				ON PD.Cod_Item = P.Cod_Item AND PD.ID_Org = P.ID_Org
			INNER JOIN Adm_System_Holding H
				ON PD.ID_Propietario = H.ID_HOLDING AND PD.ID_Org = H.ID_ORG
			INNER JOIN Adm_System_Dueños D
				ON PD.ID_Dueño = D.ID_DUEÑO AND PD.ID_Org = D.ID_ORG
			INNER JOIN Adm_System_Contactos C
				ON D.ID_CONTACTO = C.ID_CONTACTO AND D.ID_ORG = C.ID_ORG
			--CAMPOS DE LECTURA SOLAMENTE
			LEFT JOIN INVENTARIO_LOTES LOTE
				ON P.COD_ITEM = LOTE.COD_ITEM AND P.ID_ORG = LOTE.ID_ORG
			LEFT JOIN INVENTARIO_STOCK_LOTES STOCK
				ON LOTE.ID_LOTE = STOCK.ID_LOTE AND LOTE.ID_ORG = STOCK.ID_ORG
		WHERE --H.ESPROPIETARIO = 1 AND 
				P.ID_Org = @ID_ORG
			AND P.Vigencia = 'S'
			AND H.VIGENCIA = 'S'
			AND D.VIGENCIA = 'S'
			AND C.VIGENCIA = 'S'
			AND P.Descriptor_Corta LIKE @Descriptor_Corta + '%' 
			--AND CRUZ.VALOR_REFERENCIA = @SKU_ANTIGUO
			AND PD.ID_Propietario = @ID_PROPIETARIO
			AND PD.ID_Dueño = @ID_DUENO
			--AND CRUZ.ID_REF_PRED = 1003	
			--AND stock.Disponible > 0
		GROUP BY 
			   H.ID_HOLDING
			  ,H.NOMBRE
			  ,D.ID_DUEÑO
			  ,C.NOMBRES + ' ' + C.APELLIDO_PATERNO + ' ' + C.APELLIDO_MATERNO 
			  ,P.COD_ITEM
			  ,P.Descriptor_Corta 
			  ,P.PRECIO_COMPRA				
		
	END 	
		
		
	/*	
	SELECT * FROM Inventario_Items_Prop_Dueños
	
	SELECT * FROM Inventario_Items
	
	SELECT * FROM dbo.Adm_System_Holding
	
	SELECT * FROM dbo.Adm_System_Dueños
	
	SELECT * FROM Adm_System_Contactos
	
	*/
	
END
GO
