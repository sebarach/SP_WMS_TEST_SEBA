USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_AJUSTEMASIVO_CAMBIARESTADO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_AJUSTEMASIVO_CAMBIARESTADO]
	-- Add the parameters for the stored procedure here
	 @Folio_TomaInv numeric(18, 0)
	,@COD_ESTADO NUMERIC(18, 0)
	,@MOTIVO VARCHAR(500)
	,@ID_Org numeric(18, 0)
	,@CICLO_ACTUAL NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

BEGIN TRY	
	
    -- Insert statements for procedure here
	UPDATE Inventario_Congelar_Toma_Inv 
		SET COD_ESTADO = @COD_ESTADO,
			MOTIVO_ELIMINA = @MOTIVO
	WHERE FOLIO_TOMAINV = @Folio_TomaInv AND ID_ORG = @ID_Org AND ISNULL(CICLO, 0) = @CICLO_ACTUAL
	
	IF @COD_ESTADO = 4 BEGIN
	
		SELECT 1 CORRECTO, 'Inventario anulado exitosamente' MENSAJE
		RETURN
	END
	ELSE BEGIN
	
		SELECT 1 CORRECTO, 'Inventario cerrado exitosamente' MENSAJE
		RETURN
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
