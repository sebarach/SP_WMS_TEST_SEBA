USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_RECSOLPRODUCTO_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INV_RECSOLPRODUCTO_INGRESO]
	-- Add the parameters for the stored procedure here	
	 @ID_Propietario	numeric(18, 0)
	,@ID_Dueño	numeric(18, 0)
	,@Cod_Item	numeric(18, 0)
	,@ID_Org	numeric(18, 0)
	,@Descriptor_Corta	varchar(256)
	,@Descriptor_Larga	varchar(max) 
	,@ID_UM	numeric(18, 0)
	,@Ficha_Imagen	varchar(200)
	,@Largo	numeric(18, 3)
	,@Ancho	numeric(18, 3)
	,@Alto	numeric(18, 3)
	,@Volumen	numeric(18, 3)
	,@Dias_En_Estante	numeric(18, 0)
	,@Cod_Campaña	numeric(18, 0)
	,@Precio_Compra	numeric(18, 0)
	,@Control_Lote	varchar(1)
	,@Combinacion_Categoria	varchar(max)
	,@Nota	varchar(max)
	,@ID_Usro_Crea	numeric(18, 0)
	,@ID_Usro_Act	numeric(18, 0)
	,@Vigencia	varchar(1)
	,@Id_Docu numeric(18, 0)
	,@Folio_Documento numeric(18, 0)
	,@Nro_Linea numeric(18, 0)
	,@Total_Cajas_Pallets numeric(18, 0)
	,@Unidades_Cajas numeric(18, 0)
	,@Total_Unidades_Pallets numeric(18, 0)
	,@Peso_Gramos numeric(18, 3)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    IF (@Cod_Item = 0) BEGIN
    
		DECLARE @RETORNO TABLE(ID NUMERIC(18, 0));
		DECLARE @NUEVOID NUMERIC(18, 0);
    
		INSERT INTO [dbo].[Inventario_Items]
			   ([Descriptor_Corta]
			   ,[Descriptor_Larga]
			   ,[ID_UM]
			   ,[Ficha_Imagen]
			   ,[Largo]
			   ,[Ancho]
			   ,[Alto]
			   ,[Volumen]
			   ,[Dias_En_Estante]
			   ,[Precio_Compra]
			   ,[Control_Lote]
			   ,[Combinacion_Categoria]
			   ,[Nota]
			   ,[ID_Usro_Crea]
			   ,[Fech_Creacion]
			   ,[ID_Org]
			   ,[Vigencia]
				,Total_Cajas_Pallets
				,Unidades_Cajas
				,Total_Unidades_Pallets
				,Peso_Gramos)
			   OUTPUT INSERTED.Cod_Item 
			   INTO @RETORNO(ID)			   
		 VALUES
			   ( @Descriptor_Corta
				,@Descriptor_Larga
				,@ID_UM
				,@Ficha_Imagen
				,@Largo --CAST(@Largo AS DECIMAL(18, 3)) --cast(MyValues as decimal(28,20))
				,@Ancho --CAST(@Ancho AS DECIMAL(18, 3))
				,@Alto --CAST(@Alto AS DECIMAL(18, 3))
				,@Volumen --CAST(@Volumen AS DECIMAL(18, 3))
				,@Dias_En_Estante
				,@Precio_Compra
				,@Control_Lote
				,@Combinacion_Categoria
				,@Nota
				,@ID_Usro_Crea
				,GETDATE()
				,@ID_Org
				,@Vigencia
				,@Total_Cajas_Pallets
				,@Unidades_Cajas
				,@Total_Unidades_Pallets
				,@Peso_Gramos);
		
		SET @NUEVOID = (SELECT ID FROM @RETORNO);
		
		INSERT INTO [dbo].[Inventario_Items_Prop_Dueños]
				   ([ID_Propietario]
				   ,[ID_Dueño]
				   ,[Cod_Item]
				   ,[ID_Org])
			 VALUES
				   ( @ID_Propietario
					,@ID_Dueño
					,@NUEVOID
					,@ID_Org);				
		
		--ACTUALIZACIÓN DE PRODUCTO EN DETALLE DOCUMENTO
		UPDATE Inventario_Detalle_Documentos
			SET Cod_Item = @NUEVOID, Descriptor = @Descriptor_Corta
		WHERE Id_Org = @ID_Org AND Id_Docu = @Id_Docu AND Folio_Documento = @Folio_Documento AND Nro_Linea = @Nro_Linea;		
		
		SELECT ID FROM @RETORNO
				
	END
	ELSE BEGIN
		UPDATE [dbo].[Inventario_Items]
		SET 
				[Descriptor_Corta] = @Descriptor_Corta
			   ,[Descriptor_Larga] = @Descriptor_Larga
			   ,[ID_UM] = @ID_UM
			   ,[Ficha_Imagen] = @Ficha_Imagen
			   ,[Largo] = @Largo --CAST(@Largo AS DECIMAL(18, 3))
			   ,[Ancho] = @Ancho --CAST(@Ancho AS DECIMAL(18, 3))
			   ,[Alto] = @Alto --CAST(@Alto AS DECIMAL(18, 3))
			   ,[Volumen] = @Volumen --CAST(@Volumen AS DECIMAL(18, 3))
			   ,[Dias_En_Estante] = @Dias_En_Estante
			   ,[Precio_Compra] = @Precio_Compra
			   ,[Control_Lote] = @Control_Lote
			   ,[Combinacion_Categoria] = @Combinacion_Categoria
			   ,[Nota] = @Nota
			   ,[ID_Usro_Act] = @ID_Usro_Act
			   ,[Fech_Actualiza] = GETDATE()
			   ,[ID_Org] = @ID_Org	
				,Total_Cajas_Pallets = @Total_Cajas_Pallets
				,Unidades_Cajas = @Unidades_Cajas
				,Total_Unidades_Pallets = @Total_Unidades_Pallets
				,Peso_Gramos = @Peso_Gramos			   	
		WHERE [ID_Org] = @ID_Org AND Cod_Item = @Cod_Item
		
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
