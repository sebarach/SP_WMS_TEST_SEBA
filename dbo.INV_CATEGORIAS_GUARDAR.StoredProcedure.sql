USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_CATEGORIAS_GUARDAR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_CATEGORIAS_GUARDAR]
	-- Add the parameters for the stored procedure here
	 @KEY VARCHAR(50)
	,@ELEMENTO VARCHAR(100)
	,@NIVEL NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @SECUENCIA INTEGER = 0

	IF LTRIM(RTRIM(@ELEMENTO)) = '' BEGIN
		SELECT 0 CORRECTO, 'El valor debe contener al menos un caracter' MENSAJE 
		RETURN
	END


BEGIN TRAN
BEGIN TRY

    -- Insert statements for procedure here
	IF @NIVEL = 1 BEGIN
	
		IF EXISTS(SELECT * FROM Inventario_Categoria1 WHERE Nombre_Categ1 = LTRIM(RTRIM(@ELEMENTO)) AND Vigente = 'S') BEGIN
			SELECT 0 CORRECTO, 'El valor ya existe en la lista' MENSAJE 
			RETURN
		END			
	
		SET @SECUENCIA = (SELECT MAX(CAST(Cod_Categ1 AS INTEGER)) + 1 FROM Inventario_Categoria1)
		
		INSERT INTO Inventario_Categoria1
				   (Cod_Categ1
				   ,Nombre_Categ1
				   ,Vigente)
			 VALUES
				   (CAST(@SECUENCIA AS VARCHAR(50))
				   ,LTRIM(RTRIM(@ELEMENTO))
				   ,'S')
		
		COMMIT
		
	END 
	
	
	IF @NIVEL = 2 BEGIN
	
		IF EXISTS(SELECT * FROM Inventario_Categoria2 WHERE Nombre_Categ2 = LTRIM(RTRIM(@ELEMENTO)) AND Cod_Categ1 = @KEY AND Vigente = 'S') BEGIN
			SELECT 0 CORRECTO, 'El valor ya existe en la lista' MENSAJE 
			RETURN
		END		
	
		SET @SECUENCIA = (SELECT MAX(CAST(Cod_Categ2 AS INTEGER)) + 1 FROM Inventario_Categoria2)			
		
		INSERT INTO Inventario_Categoria2
				   (Cod_Categ2
				   ,Nombre_Categ2
				   ,Cod_Categ1
				   ,Vigente)
		 VALUES
			   (CAST(@SECUENCIA AS VARCHAR(50))
			   ,LTRIM(RTRIM(@ELEMENTO))
			   ,@KEY
			   ,'S')
	
		COMMIT
	
	END 	
	
	
	
	IF @NIVEL = 3 BEGIN
	
		IF EXISTS(SELECT * FROM Inventario_Categoria3 WHERE Nombre_Categ3 = LTRIM(RTRIM(@ELEMENTO)) AND Cod_Categ2 = @KEY AND Vigente = 'S') BEGIN
			SELECT 0 CORRECTO, 'El valor ya existe en la lista' MENSAJE 
			RETURN
		END		
	
		SET @SECUENCIA = (SELECT MAX(CAST([Cod_Categ3] AS INTEGER)) + 1 FROM Inventario_Categoria3)
		
		INSERT INTO Inventario_Categoria3
				   (Cod_Categ3
				   ,Nombre_Categ3
				   ,Cod_Categ2
				   ,Vigente)
		 VALUES
			   (CAST(@SECUENCIA AS VARCHAR(50))
			   ,LTRIM(RTRIM(@ELEMENTO))
			   ,@KEY
			   ,'S')
			   
		COMMIT
	
	END 	
	
	SELECT 1 CORRECTO, 'Valor agregado exitosamente' MENSAJE 


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
