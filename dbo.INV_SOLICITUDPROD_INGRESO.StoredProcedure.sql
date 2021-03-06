USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_SOLICITUDPROD_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_SOLICITUDPROD_INGRESO]
	-- Add the parameters for the stored procedure here	
	 @Folio_Documento numeric(18, 0)
	,@Id_Docu numeric(18, 0)
	,@Nro_Linea numeric(18, 0)
	,@Descriptor varchar(MAX)
	,@Cod_Item numeric(18, 0)
	,@Cantidad numeric(18, 0)
	,@Cantidad_Pdte numeric(18, 0)
	,@Precio numeric(18, 0)
	,@Id_Org numeric(18, 0)
	,@ID_Lote varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    IF NOT EXISTS(SELECT Folio_Documento FROM Inventario_Detalle_Documentos 
				  WHERE Folio_Documento = @Folio_Documento AND Id_Org = @Id_Org AND Id_Docu = @Id_Docu AND Nro_Linea = @Nro_Linea) BEGIN
    
		INSERT INTO [dbo].[Inventario_Detalle_Documentos]
			   ([Folio_Documento]
			   ,[Id_Docu]
			   ,[Nro_Linea]
			   ,[Descriptor]
			   ,[Cod_Item]
			   ,[Cantidad]
			   ,[Cantidad_Pdte]
			   ,[Precio]
			   ,[Id_Org]
			   ,[ID_Lote])		   
		 VALUES
			   (@Folio_Documento
			   ,@Id_Docu
			   ,@Nro_Linea
			   ,@Descriptor
			   ,@Cod_Item
			   ,@Cantidad
			   ,@Cantidad_Pdte
			   ,@Precio
			   ,@Id_Org
			   ,@ID_Lote);		
		
		SELECT @@ROWCOUNT FILAS_AFECTADAS
				
	END
	ELSE BEGIN
		UPDATE [dbo].[Inventario_Detalle_Documentos]
		SET 
			 Folio_Documento = @Folio_Documento
			,Id_Docu = @Id_Docu
			,Nro_Linea = @Nro_Linea
			,Descriptor = @Descriptor
			,Cod_Item = @Cod_Item
			,Cantidad = @Cantidad
			,Cantidad_Pdte = @Cantidad_Pdte
			,Precio = @Precio
			,Id_Org = @Id_Org
			,ID_Lote = @ID_Lote
		WHERE Folio_Documento = @Folio_Documento AND Id_Org = @Id_Org AND Id_Docu = @Id_Docu AND Nro_Linea = @Nro_Linea
		
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
