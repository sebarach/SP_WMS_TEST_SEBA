USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_CAMBIODUENO_GRABAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
/*
EXEC INV_CAMBIODUENO_GRABAR 17, 4,
'<root>	<f Id="1" 	PropietarioId="52" 	Propietario="PROCTER &amp; GAMBLE CHILE LIMITADA" 	DuenoId="756" 	Dueno="FERNANDA BIJIT " 	Sku="53265" 	Descriptor="MUEBLE BODEGA FICTICIO AFEITADO Y DEPILACION SALCO BRAND" 	LoteId="201710010320" 	LoteProveedor="S/L" 	FechaVencimiento="20/10/2018 0:00:00" 	SubInventarioId="10" 	SubInvinventario="SUBINVENTARIO F-22" 	LocalizadorId="1714" 	Localizador="DSC.0.1.D.2.022" 	EnMano="2" 	Disponible="2" 	Reserva="0" 	CantidadFisica="10" 	SubInventarioFisicoId="10" 	SubInventarioFisico="SUBINVENTARIO F-22" 	LocalizadorFisicoId="3088" 	LocalizadorFisico="DSC.0.1.O.2.001" 	Diferencia="8" 	Observacion="prueba" /></root>'

*/
CREATE PROCEDURE [dbo].[INV_CAMBIODUENO_GRABAR]
	-- Add the parameters for the stored procedure here
--DECLARE
	 @PROPIETARIO_ID NUMERIC(18, 0)
	,@DUENO_ID NUMERIC(18, 0)
	,@ID_Org numeric(18, 0)
	,@ID_USRO_ACT NUMERIC(18, 0)		
	,@XML varchar(MAX)
	,@DUENO_ORIGEN NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

/*
	SET @PROPIETARIO_ID = 143
	SET @DUENO_ID = 732
	SET @DUENO_ORIGEN = 564
	SET @ID_Org = 17
	SET @ID_USRO_ACT = 4
	SET @XML = '<root>
  <f Id="50983" Descriptor="ARAÑA PLEGABLE" />
</root>'
*/

	--DECLARE @ID_LOCALIZADOR_STAGE NUMERIC(18, 0) = (SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60)
	DECLARE @FECHA_TRANSACCION DATETIME = (SELECT GETDATE());	

	DECLARE @OXML XML;
	SET @OXML = N'''' + @XML + '''';
	
	--TABLA TEMPORAL DEL XML
	DECLARE @TABLAXML TABLE(
		Cod_Item numeric(18, 0)	,
		Descriptor_Corta varchar(256)	
	)
	
	
	INSERT INTO @TABLAXML
	SELECT
		Tbl.Col.value('@Id', 'numeric(18, 0)') Cod_Item,
		Tbl.Col.value('@Descriptor', 'varchar(256)') Descriptor_Corta
	FROM @OXML.nodes('//root/f') Tbl(Col)
	
	--SELECT * FROM Inventario_Detalle_Transacciones ORDER BY FECHA_TRX DESC
	--SELECT * FROM @TABLAXML
	
BEGIN TRAN
BEGIN TRY	
		
	--SELECT * FROM Inventario_Items_Prop_Dueños WHERE Cod_Item IN(SELECT Cod_Item FROM @TABLAXML)		
	--SELECT * FROM Inventario_Lotes WHERE Cod_Item IN(SELECT Cod_Item FROM @TABLAXML)		
	INSERT INTO Inventario_Historial_CambioDueños
			   (Id_Propietario
			   ,Id_Dueño_Origen
			   ,Id_Dueño_Destino
			   ,Cod_Item
			   ,ID_Usro
			   ,Fecha_Cambio
			   ,Id_Org)	
	SELECT 
		 @PROPIETARIO_ID
		,@DUENO_ORIGEN
		,@DUENO_ID
		,DESTINO.Cod_Item
		,@ID_USRO_ACT
		,@FECHA_TRANSACCION
		,@ID_Org
	FROM @TABLAXML DESTINO
		INNER JOIN Inventario_Items_Prop_Dueños ORIGEN
			ON DESTINO.Cod_Item = ORIGEN.Cod_Item
	WHERE ORIGEN.ID_Org = @ID_Org AND ORIGEN.ID_Propietario = @PROPIETARIO_ID AND ORIGEN.ID_Dueño = @DUENO_ORIGEN;
	
	
		
	--SELECT * 
	--FROM @TABLAXML T
	--	INNER JOIN 
	--(
	--SELECT O.COD_ITEM
	--FROM Inventario_Items_Prop_Dueños O
	--	INNER JOIN Inventario_Items_Prop_Dueños D
	--		ON O.Cod_Item = D.Cod_Item
	--WHERE O.ID_Propietario = @PROPIETARIO_ID
	--	AND O.ID_Dueño = @DUENO_ORIGEN
	--	AND D.ID_Propietario = @PROPIETARIO_ID
	--	AND D.ID_Dueño = @DUENO_ID
	--) TBL
	--	ON T.COD_ITEM = TBL.COD_ITEM
	IF EXISTS(	SELECT * 
				FROM @TABLAXML T
					INNER JOIN 
				(
				SELECT O.COD_ITEM
				FROM Inventario_Items_Prop_Dueños O
					INNER JOIN Inventario_Items_Prop_Dueños D
						ON O.Cod_Item = D.Cod_Item
				WHERE O.ID_Propietario = @PROPIETARIO_ID
					AND O.ID_Dueño = @DUENO_ORIGEN
					AND D.ID_Propietario = @PROPIETARIO_ID
					AND D.ID_Dueño = @DUENO_ID
				) TBL
					ON T.COD_ITEM = TBL.COD_ITEM) BEGIN
		
		
		DELETE FROM Inventario_Items_Prop_Dueños
		WHERE ID_Propietario = @PROPIETARIO_ID
			AND ID_Dueño = @DUENO_ID
			AND COD_ITEM IN (
				SELECT T.COD_ITEM 
				FROM @TABLAXML T
					INNER JOIN 
				(
				SELECT O.COD_ITEM
				FROM Inventario_Items_Prop_Dueños O
					INNER JOIN Inventario_Items_Prop_Dueños D
						ON O.Cod_Item = D.Cod_Item
				WHERE O.ID_Propietario = @PROPIETARIO_ID
					AND O.ID_Dueño = @DUENO_ORIGEN
					AND D.ID_Propietario = @PROPIETARIO_ID
					AND D.ID_Dueño = @DUENO_ID
				) TBL
					ON T.COD_ITEM = TBL.COD_ITEM						
			)
	
	END
	
	
	UPDATE Inventario_Items_Prop_Dueños SET ID_DUEÑO = @DUENO_ID
	WHERE ID_Org = @ID_Org
		AND Cod_Item IN(SELECT Cod_Item FROM @TABLAXML)	
		AND ID_DUEÑO = @DUENO_ORIGEN
	
	
	UPDATE Inventario_Lotes SET ID_DUEÑO = @DUENO_ID, FECH_ACTUALIZA = @FECHA_TRANSACCION, ID_USRO_ACT = @ID_USRO_ACT
	WHERE ID_Org = @ID_Org
		AND Cod_Item IN(SELECT Cod_Item FROM @TABLAXML)
		AND ID_DUEÑO = @DUENO_ORIGEN
	
	
	--SELECT * FROM Inventario_Items_Prop_Dueños WHERE Cod_Item IN(SELECT Cod_Item FROM @TABLAXML)		
	--SELECT * FROM Inventario_Lotes WHERE Cod_Item IN(SELECT Cod_Item FROM @TABLAXML)		

	--SELECT @@TRANCOUNT--ROLLBACK
	COMMIT TRANSACTION
	
	SELECT 1 CORRECTO, 'Producto(s) Cambiados(s) exitosamente' MENSAJE
		
	
END TRY
BEGIN CATCH
	
	/* Hay un error, deshacemos los cambios*/ 
	ROLLBACK TRANSACTION -- O solo ROLLBACK
	
	DECLARE @MENSAJEERROR VARCHAR(MAX) = ERROR_MESSAGE();
	DECLARE @SEVERIDADERROR BIGINT = ERROR_SEVERITY();
	DECLARE @ESTADOERROR BIGINT = ERROR_STATE();
	DECLARE @LINEAERROR VARCHAR(5) = CAST(ERROR_LINE() AS VARCHAR(5));
	DECLARE @ERRORMENSAJE VARCHAR(MAX);
	SET @ERRORMENSAJE = (@LINEAERROR + ' - ' + @MENSAJEERROR);
	
     RAISERROR (@ERRORMENSAJE, @SEVERIDADERROR, @ESTADOERROR)
				 
     --PRINT ERROR_SEVERITY()    
     --PRINT ERROR_STATE()  
     --PRINT ERROR_PROCEDURE()   
     --PRINT ERROR_LINE()   
     --PRINT ERROR_MESSAGE() 
	
END CATCH

	
END

GO
