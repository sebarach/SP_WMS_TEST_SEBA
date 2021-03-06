USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_LOCALIZADOR_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_LOCALIZADOR_INGRESO]
	-- Add the parameters for the stored procedure here	
	 @ID_Subinv numeric(18, 0)
	,@ID_Localizador numeric(18, 0)
	,@Nombre_Localizador varchar(MAX)
	,@Segmento1 varchar(50)
	,@Segmento2 varchar(50)
	,@Segmento3 varchar(50)
	,@Segmento4 varchar(50)
	,@Segmento5 varchar(50)
	,@Segmento6 varchar(50)
	,@Combinacion_Localizador varchar(50)
	,@ID_Org numeric(18,0)
	,@Largo numeric(18,3)
	,@Ancho numeric(18,3)
	,@Alto numeric(18,3)
	,@Volumen numeric(18,3)
	,@Cod_Tipo_SubInv numeric(18,0)
	,@ID_Usro_Crea numeric(18,0)
	,@ID_Usro_Act numeric(18,0)
	,@Cod_Estado numeric(18,0)
	,@Vigencia varchar(1)
	,@Control_Localizador varchar(1)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    IF NOT EXISTS(SELECT ID_Localizador FROM Inventario_SubInv_Localizadores WHERE ID_Localizador = @ID_Localizador) BEGIN
    
		DECLARE @RETORNO TABLE(ID NUMERIC(18, 0));
    
		INSERT INTO [dbo].[Inventario_SubInv_Localizadores]
           ([ID_Subinv]
           ,[Nombre_Localizador]
           ,[Segmento1]
           ,[Segmento2]
           ,[Segmento3]
           ,[Segmento4]
           ,[Segmento5]
           ,[Segmento6]
           ,[Combinacion_Localizador]
           ,[ID_Org]
           ,[Largo]
           ,[Ancho]
           ,[Alto]
           ,[Volumen]
           ,[Cod_Tipo_SubInv]
           ,[ID_Usro_Crea]
           ,[Fech_Creacion]
           ,[Cod_Estado]
           ,[Vigencia]
           ,[Control_Localizador])
		   OUTPUT INSERTED.ID_Localizador 
		   INTO @RETORNO(ID)           
		VALUES
           ( @ID_Subinv
			,@Nombre_Localizador
			,@Segmento1
			,@Segmento2
			,@Segmento3
			,@Segmento4
			,@Segmento5
			,@Segmento6
			,@Combinacion_Localizador
			,@ID_Org
			,@Largo
			,@Ancho
			,@Alto
			,@Volumen
			,@Cod_Tipo_SubInv
			,@ID_Usro_Crea
			,GETDATE()
			,@Cod_Estado
			,@Vigencia
			,@Control_Localizador);			
		
		SELECT ID FROM @RETORNO
				
	END
	ELSE BEGIN
		UPDATE [dbo].[Inventario_SubInv_Localizadores]
		SET 
			 ID_Subinv = @ID_Subinv
			,Nombre_Localizador = @Nombre_Localizador
			,Segmento1 = @Segmento1
			,Segmento2 = @Segmento2
			,Segmento3 = @Segmento3
			,Segmento4 = @Segmento4
			,Segmento5 = @Segmento5
			,Segmento6 = @Segmento6
			,Combinacion_Localizador = @Combinacion_Localizador
			,ID_Org = @ID_Org
			,Largo = @Largo
			,Ancho = @Ancho
			,Alto = @Alto
			,Volumen = @Volumen
			,Cod_Tipo_SubInv = @Cod_Tipo_SubInv
			,ID_Usro_Act = @ID_Usro_Act
			,Fech_Actualiza = GETDATE()
			,Cod_Estado = @Cod_Estado
			,Vigencia = @Vigencia
			,Control_Localizador = @Control_Localizador
		WHERE ID_Localizador = @ID_Localizador
		
		SELECT @@ROWCOUNT FILAS_AFECTADAS
	
	END

	/*	
	SELECT * FROM Inventario_Items_Prop_Dueños
	
	SELECT * FROM Inventario_Items
	
	SELECT * FROM dbo.Adm_System_Holding
	
	SELECT * FROM dbo.Adm_System_Dueños
	*/
	
END
GO
