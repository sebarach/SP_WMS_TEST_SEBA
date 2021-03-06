USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_AJUSTEINDIVIDUAL_BUSCAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC INV_AJUSTEINDIVIDUAL_BUSCAR '', '', 17
CREATE PROCEDURE [dbo].[INV_AJUSTEINDIVIDUAL_BUSCAR]
	-- Add the parameters for the stored procedure here	
	@v_codItem NUMERIC(18,0),
	@ID_LOTE VARCHAR(50),
	@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--SET @Descriptor_Corta = ''
	--SET @ID_LOTE = ''
	--SET @ID_ORG = 17
	
    -- Insert statements for procedure here
    /*
    SELECT * FROM Inventario_Lotes
	SELECT * FROM Inventario_Items_Prop_Dueños
	SELECT * FROM Inventario_Items
	SELECT * FROM dbo.Adm_System_Holding
	SELECT * FROM dbo.Adm_System_Dueños
	SELECT * FROM Adm_System_Contactos   
	SELECT * FROM Inventario_Stock_Lotes 
	SELECT * FROM Inventario_SubInv_Localizadores
	SELECT * FROM Inventario_SubInventarios
    */
    
    IF @v_codItem <> 0  BEGIN 
    
		SELECT
			 PROP.ID_HOLDING PropietarioId
			,PROP.NOMBRE Propietario
			,DUENO.ID_DUEÑO DuenoId
			,C.NOMBRES + ' ' + C.APELLIDO_PATERNO + ' ' + C.APELLIDO_MATERNO Dueno
			,PROD.COD_ITEM Sku
			,PROD.DESCRIPTOR_CORTA Descriptor
			,LOTE.ID_Lote LoteId
			,LOTE.Lote_Proveedor LoteProveedor
			,LOTE.Fecha_Expira FechaVencimiento
			,SUBINV.ID_SUBINV SubInventarioId
			,SUBINV.DESCRIPCION SubInvinventario
			,LOC.ID_LOCALIZADOR LocalizadorId
			,LOC.COMBINACION_LOCALIZADOR Localizador
			,ISNULL(STOCK.EN_MANO, 0) EnMano
			,ISNULL(STOCK.DISPONIBLE, 0) Disponible
			,ISNULL(STOCK.RESERVA, 0) Reserva
		FROM Inventario_Items PROD
			INNER JOIN INVENTARIO_LOTES LOTE
				ON PROD.COD_ITEM = LOTE.COD_ITEM AND PROD.ID_ORG = LOTE.ID_ORG
			INNER JOIN Adm_System_Dueños DUENO
				ON LOTE.ID_DUEÑO = DUENO.ID_DUEÑO AND LOTE.ID_ORG = DUENO.ID_ORG
			INNER JOIN Adm_System_Holding PROP
				ON DUENO.ID_HOLDING_PROPIETARIO = PROP.ID_HOLDING AND DUENO.ID_ORG = PROP.ID_ORG
			INNER JOIN Inventario_Stock_Lotes STOCK
				ON LOTE.ID_LOTE = STOCK.ID_LOTE AND LOTE.ID_ORG = STOCK.ID_ORG
			INNER JOIN Inventario_SubInv_Localizadores LOC
				ON STOCK.ID_LOCALIZADOR = LOC.ID_LOCALIZADOR AND STOCK.ID_ORG = LOC.ID_ORG 
			INNER JOIN Inventario_SubInventarios SUBINV
				ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
			INNER JOIN Adm_System_Contactos C
				ON DUENO.ID_CONTACTO = C.ID_CONTACTO AND DUENO.ID_ORG = C.ID_ORG				
		WHERE PROD.ID_ORG = @ID_ORG
			AND PROP.VIGENCIA = 'S'
			AND DUENO.VIGENCIA = 'S'
			--AND PROD.VIGENCIA 
			--AND LOC.COD_TIPO_SUBINV = 200
			AND PROD.Cod_Item = @v_codItem 
		
	END     
    
    IF @ID_LOTE <> '' BEGIN 
    	
		SELECT
			 PROP.ID_HOLDING PropietarioId
			,PROP.NOMBRE Propietario
			,DUENO.ID_DUEÑO DuenoId
			,C.NOMBRES + ' ' + C.APELLIDO_PATERNO + ' ' + C.APELLIDO_MATERNO Dueno
			,PROD.COD_ITEM Sku
			,PROD.DESCRIPTOR_CORTA Descriptor
			,LOTE.ID_Lote LoteId
			,LOTE.Lote_Proveedor LoteProveedor
			,LOTE.Fecha_Expira FechaVencimiento
			,SUBINV.ID_SUBINV SubInventarioId
			,SUBINV.DESCRIPCION SubInvinventario
			,LOC.ID_LOCALIZADOR LocalizadorId
			,LOC.COMBINACION_LOCALIZADOR Localizador
			,ISNULL(STOCK.EN_MANO, 0) EnMano
			,ISNULL(STOCK.DISPONIBLE, 0) Disponible
			,ISNULL(STOCK.RESERVA, 0) Reserva
		FROM Inventario_Items PROD
			INNER JOIN INVENTARIO_LOTES LOTE
				ON PROD.COD_ITEM = LOTE.COD_ITEM AND PROD.ID_ORG = LOTE.ID_ORG
			INNER JOIN Adm_System_Dueños DUENO
				ON LOTE.ID_DUEÑO = DUENO.ID_DUEÑO AND LOTE.ID_ORG = DUENO.ID_ORG
			INNER JOIN Adm_System_Holding PROP
				ON DUENO.ID_HOLDING_PROPIETARIO = PROP.ID_HOLDING AND DUENO.ID_ORG = PROP.ID_ORG
			INNER JOIN Inventario_Stock_Lotes STOCK
				ON LOTE.ID_LOTE = STOCK.ID_LOTE AND LOTE.ID_ORG = STOCK.ID_ORG
			INNER JOIN Inventario_SubInv_Localizadores LOC
				ON STOCK.ID_LOCALIZADOR = LOC.ID_LOCALIZADOR AND STOCK.ID_ORG = LOC.ID_ORG 
			INNER JOIN Inventario_SubInventarios SUBINV
				ON LOC.ID_SUBINV = SUBINV.ID_SUBINV
			INNER JOIN Adm_System_Contactos C
				ON DUENO.ID_CONTACTO = C.ID_CONTACTO AND DUENO.ID_ORG = C.ID_ORG				
		WHERE PROD.ID_ORG = @ID_ORG
			AND PROP.VIGENCIA = 'S'
			AND DUENO.VIGENCIA = 'S'
			--AND PROD.VIGENCIA 
			--AND LOC.COD_TIPO_SUBINV = 200
			AND LOTE.ID_LOTE = @ID_LOTE  
		
	END 
	
END
GO
