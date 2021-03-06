USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_CAMPANIA_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_CAMPANIA_INGRESO]
	-- Add the parameters for the stored procedure here	
		 @Cod_Campaña	numeric(18, 0)
		,@Nombre_Campaña	varchar(MAX)
		,@ID_Org	numeric(18, 0)
		,@Fecha_Inicio	datetime
		,@Fecha_Termino	datetime
		,@ID_Usro_Crea	numeric(18, 0)
		,@ID_Usro_Act	numeric(18, 0)
		,@Vigencia	varchar(1)
		,@Cod_Item NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SELECT * FROM [Inventario_Campaña_Propietarios_Dueños]
    -- Insert statements for procedure here
    IF (@Cod_Campaña = 0 OR @Cod_Campaña =NULL) BEGIN
    
		DECLARE @RETORNO TABLE(ID NUMERIC(18, 0));
    
		INSERT INTO [dbo].[Inventario_Campaña_Propietarios_Dueños]
				   ([Nombre_Campaña]
				   ,[ID_Org]
				   ,[Fecha_Inicio]
				   ,[Fecha_Termino]
				   ,ID_Usro_Act
				   ,[ID_Usro_Crea]
				   ,[Fech_Creacion]
                   ,[Fech_Actualiza]
				   ,[Vigencia]
				   ,Cod_Item)
				   OUTPUT INSERTED.Cod_Campaña 
				   INTO @RETORNO(ID)				   
			 VALUES
				   (@Nombre_Campaña
					,@ID_Org
					,@Fecha_Inicio
					,@Fecha_Termino
					,1
					,@ID_Usro_Crea
					,GETDATE()
                    ,GETDATE()
					,@Vigencia
					,@Cod_Item);

		SELECT ID FROM @RETORNO

				UPDATE [dbo].[Inventario_Campaña_Propietarios_Dueños]
		   SET	 ID_Usro_Act = null
		WHERE [ID_Org] = @ID_Org AND Cod_Campaña != (SELECT ID FROM @RETORNO) and Cod_Item = @Cod_Item
				
	END
	ELSE BEGIN
		UPDATE [dbo].[Inventario_Campaña_Propietarios_Dueños]
		   SET   Nombre_Campaña = @Nombre_Campaña
				,ID_Org = @ID_Org
				,Fecha_Inicio = @Fecha_Inicio
				,Fecha_Termino = @Fecha_Termino
				,ID_Usro_Act = @ID_Usro_Act
				,Fech_Actualiza = GETDATE()
				,Vigencia = @Vigencia
				,Cod_Item = @Cod_Item
		WHERE [ID_Org] = @ID_Org AND Cod_Campaña = @Cod_Campaña


		UPDATE [dbo].[Inventario_Campaña_Propietarios_Dueños]
		   SET  ID_Usro_Act = null
		WHERE [ID_Org] = @ID_Org AND Cod_Campaña != @Cod_Campaña and Cod_Item = @Cod_Item
		
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
