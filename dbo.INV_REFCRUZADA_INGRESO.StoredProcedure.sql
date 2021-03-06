USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_REFCRUZADA_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_REFCRUZADA_INGRESO]
	-- Add the parameters for the stored procedure here	
	 @IDREF numeric(18, 0)
	,@Cod_Item numeric(18, 0)
	,@ID_Ref_Pred numeric(18, 0)
	,@Referencia_Cruzada varchar(MAX)
	,@Valor_Referencia varchar(MAX)
	,@ID_Usro_Crea numeric(18,0)
	,@ID_Usro_Act numeric(18,0)
	,@Vigencia varchar(1)
	,@Id_Org numeric(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    IF NOT EXISTS(SELECT ID_Ref_Pred FROM Inventario_Referencias_Cruzadas WHERE IDREF = @IDREF) BEGIN
    
		--DECLARE @RETORNO TABLE(ID NUMERIC(18, 0));
    
		INSERT INTO [dbo].[Inventario_Referencias_Cruzadas]
           ([Cod_Item]
           ,[ID_Ref_Pred]
           ,[Referencia_Cruzada]
           ,[Valor_Referencia]
           ,[ID_Usro_Crea]
           ,[Fech_Creacion]
           ,[Vigencia]
           ,[Id_Org])
		   --OUTPUT INSERTED.Cod_Item 
		   --INTO @RETORNO(ID)           
		VALUES
           ( @Cod_Item
			,@ID_Ref_Pred
			,@Referencia_Cruzada
			,@Valor_Referencia
			,@ID_Usro_Crea
			,GETDATE()
			,@Vigencia
			,@Id_Org);			
		
		SELECT @@ROWCOUNT ID --FROM @RETORNO
				
	END
	ELSE BEGIN
		UPDATE [dbo].[Inventario_Referencias_Cruzadas]
		SET 
			 Cod_Item = @Cod_Item
			,ID_Ref_Pred = @ID_Ref_Pred
			,Referencia_Cruzada = @Referencia_Cruzada
			,Valor_Referencia = @Valor_Referencia
			,ID_Usro_Act = @ID_Usro_Act
			,Fech_Actualiza = GETDATE()
			,Vigencia = @Vigencia
			,Id_Org = @Id_Org	
		WHERE IDREF = @IDREF
		
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
