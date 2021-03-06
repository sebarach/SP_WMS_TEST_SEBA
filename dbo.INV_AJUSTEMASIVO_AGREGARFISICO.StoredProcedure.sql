USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_AJUSTEMASIVO_AGREGARFISICO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_AJUSTEMASIVO_AGREGARFISICO]
	-- Add the parameters for the stored procedure here
	 @Folio_TomaInv numeric(18, 0)
	,@ID_Etiqueta numeric(18, 0)
	,@ID_Localizador numeric(18, 0)
	,@Cod_Item numeric(18, 0)
	,@ID_Lote numeric(18, 0)
	,@Lote_Prov varchar(50)
	,@Vence VARCHAR(20)
	,@Cantidad_Fisica numeric(18, 3)
	,@Fecha_Toma VARCHAR(20)
	,@ID_Usro_Crea numeric(18, 0)
	,@ID_Org numeric(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

BEGIN TRY

	--Obtención de datos sku y fecha toma
	DECLARE @obt_Cod_Item numeric(18, 0), @obt_Fecha_Toma VARCHAR(20)
	
	SET @obt_Fecha_Toma = (SELECT DISTINCT FECHA_INV FROM Inventario_Congelar_Toma_Inv WHERE FOLIO_TOMAINV = @Folio_TomaInv AND ID_ORG = @ID_Org)
	
	SET @obt_Cod_Item = (SELECT COD_ITEM FROM INVENTARIO_LOTES WHERE ID_LOTE = @ID_Lote AND ID_ORG = @ID_ORG)
	
    -- Insert statements for procedure here
    IF EXISTS(SELECT * FROM Inventario_Toma_Fisica_Inv WHERE Folio_TomaInv = @Folio_TomaInv AND ID_Etiqueta = @ID_Etiqueta AND ID_Org = @ID_Org) BEGIN
		
		--SELECT * FROM INVENTARIO_LOTES WHERE ID_LOTE = ''
		UPDATE INVENTARIO_LOTES
			SET LOTE_PROVEEDOR = @Lote_Prov,
				FECHA_EXPIRA = CONVERT(date, @Vence,103)
		WHERE ID_LOTE = @ID_Lote;
		
		UPDATE Inventario_Toma_Fisica_Inv
		   SET ID_Localizador = @ID_Localizador
				,Cod_Item = @obt_Cod_Item
				,ID_Lote = @ID_Lote
				,Lote_Prov = @Lote_Prov
				,Vence = CONVERT(date, @Vence,103)
				,Cantidad_Fisica = @Cantidad_Fisica
				,Fecha_Toma = CONVERT(date, @obt_Fecha_Toma,103)
				,ID_Usro_Crea = @ID_Usro_Crea
		 WHERE Folio_TomaInv = @Folio_TomaInv AND ID_Etiqueta = @ID_Etiqueta AND ID_Org = @ID_Org
		 
		 SELECT 1 CORRECTO, '' MENSAJE

	END 
	ELSE BEGIN
		
		--DBCC CHECKIDENT (Inventario_Congelar_Toma_Inv)
		DECLARE @MAX_ID_ETIQUETA NUMERIC(18, 0)
		--SET @MAX_ID_ETIQUETA = (SELECT MAX(ID_ETIQUETA)+1 FROM Inventario_Congelar_Toma_Inv)
		
		--DBCC CHECKIDENT (Inventario_Congelar_Toma_Inv, RESEED, @MAX_ID_ETIQUETA)
		
		IF EXISTS(SELECT * FROM Inventario_Toma_Fisica_Inv WHERE Folio_TomaInv = @Folio_TomaInv AND @ID_Lote = ID_Lote AND ID_Org = @ID_Org) BEGIN
		
			SELECT 0 CORRECTO, 'El Lote ya se encuentra agregado' MENSAJE
			RETURN
		END
		

		--select * from dbo.Inventario_Congelar_Toma_Inv
		INSERT INTO Inventario_Congelar_Toma_Inv
           ([Folio_TomaInv]
           ,[Fecha_Inv]
           ,[Descripcion_Inv]
           ,[Filtro]
           ,[ID_Propietario]
           ,[Cod_Item]
           ,[ID_Lote]
           ,[Etiq_Pallet_Antiguo]
           ,[ID_Localizador]
           ,[En_Mano]
           ,[Disponible]
           ,[Reserva]
           ,[ID_Usro_Crea]
           ,[ID_Org]
           ,[Motivo_Elimina]
           ,[Vigencia]
           ,[Cod_Estado])
		VALUES(
			 @Folio_TomaInv
			,@obt_Fecha_Toma
			,(SELECT DISTINCT DESCRIPCION_INV FROM Inventario_Congelar_Toma_Inv WHERE Folio_TomaInv = @Folio_TomaInv AND ID_Org = @ID_Org)
			,(SELECT DISTINCT FILTRO FROM Inventario_Congelar_Toma_Inv WHERE Folio_TomaInv = @Folio_TomaInv AND ID_Org = @ID_Org)
			,(SELECT DISTINCT ID_PROPIETARIO FROM Inventario_Congelar_Toma_Inv WHERE Folio_TomaInv = @Folio_TomaInv AND ID_Org = @ID_Org)
			,@obt_Cod_Item
			,@ID_Lote
			,(SELECT ETIQ_PALLET_ANTIGUO FROM Inventario_LOTES WHERE ID_Lote = @ID_Lote AND ID_Org = @ID_Org)
			,@ID_Localizador
			,@Cantidad_Fisica
			,0
			,0
			,@ID_Usro_Crea
			,@ID_Org
			,NULL
			,'S'
			,1
		);

		SET @MAX_ID_ETIQUETA = (SELECT MAX(ID_ETIQUETA) FROM Inventario_Congelar_Toma_Inv);

		
		INSERT INTO Inventario_Toma_Fisica_Inv
           ([Folio_TomaInv]
           ,[ID_Etiqueta]
           ,[ID_Localizador]
           ,[Cod_Item]
           ,[ID_Lote]
           ,[Lote_Prov]
           ,[Vence]
           ,[Cantidad_Fisica]
           ,[Fecha_Toma]
           ,[ID_Usro_Crea]
           ,[ID_Org])
		VALUES(
			 @Folio_TomaInv
			,@MAX_ID_ETIQUETA
			,@ID_Localizador
			,@obt_Cod_Item
			,@ID_Lote
			,@Lote_Prov
			,CONVERT(date, @Vence,103)
			,@Cantidad_Fisica
			,CONVERT(date, @obt_Fecha_Toma,103)
			,@ID_Usro_Crea
			,@ID_Org			
			);
			
		SELECT 1 CORRECTO, 'Lote agregado exitosamente' MENSAJE			
			
	END 
	
	
END TRY
BEGIN CATCH
	
	/* Hay un error, deshacemos los cambios*/ 
	--ROLLBACK TRANSACTION -- O solo ROLLBACK
	
	DECLARE @MENSAJEERROR VARCHAR(MAX) = ERROR_MESSAGE();
	DECLARE @SEVERIDADERROR BIGINT = ERROR_SEVERITY();
	DECLARE @ESTADOERROR BIGINT = ERROR_STATE();
	DECLARE @LINEAERROR VARCHAR(5) = CAST(ERROR_LINE() AS VARCHAR(5));
	DECLARE @ERRORMENSAJE VARCHAR(MAX);
	SET @ERRORMENSAJE = (@LINEAERROR + ' - ' + @MENSAJEERROR);
	
    --RAISERROR (@ERRORMENSAJE, @SEVERIDADERROR, @ESTADOERROR)
	
	SELECT 0 CORRECTO, @ERRORMENSAJE MENSAJE
		 
     --PRINT ERROR_SEVERITY()    
     --PRINT ERROR_STATE()  
     --PRINT ERROR_PROCEDURE()   
     --PRINT ERROR_LINE()   
     --PRINT ERROR_MESSAGE() 
	
END CATCH		
	
END
GO
