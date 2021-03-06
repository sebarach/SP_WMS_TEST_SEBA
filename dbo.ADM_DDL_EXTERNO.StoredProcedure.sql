USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_DDL_EXTERNO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_DDL_EXTERNO]
	-- Add the parameters for the stored procedure here
	@LISTA_VALOR VARCHAR(10),
	@ID_DUENO_EXTERNO NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

    IF @LISTA_VALOR = 'ORG' BEGIN
		SELECT ID_ORG VALOR, NOMBRE ELEMENTO FROM dbo.Adm_System_Organizaciones
		ORDER BY NOMBRE ASC
    END

    IF @LISTA_VALOR = 'PERFIL' BEGIN
		SELECT P.ID_PERFIL VALOR, U.USERNAME + ' (' + LOWER(T.TIPO) + ')' ELEMENTO
		FROM dbo.Adm_System_Perfiles_Usuarios P
			INNER JOIN dbo.Adm_System_Tipo_Usuarios T
				ON P.ID_TIPOUSRO = T.ID_TIPOUSRO AND P.ID_ORG = T.ID_ORG
			INNER JOIN Adm_System_Usuarios U
				ON P.ID_USRO = U.ID_USRO AND P.ID_ORG = U.ID_ORG
		WHERE P.ID_ORG = @ID_ORG
		ORDER BY T.TIPO ASC		
    END

    IF @LISTA_VALOR = 'SUBRESP' BEGIN
		SELECT ID_SUBRESP VALOR, NOMBRE ELEMENTO FROM dbo.Adm_System_Sub_Responsabilidades
		ORDER BY NOMBRE ASC
    END
    
    IF @LISTA_VALOR = 'USU' BEGIN
		SELECT ID_USRO VALOR, NOMBRES + ' ' + APELLIDO_PATERNO ELEMENTO FROM dbo.Adm_System_Usuarios
		WHERE ID_ORG = @ID_ORG
		ORDER BY NOMBRES ASC
    END    

    IF @LISTA_VALOR = 'ORIGEN' BEGIN
		SELECT ID_ORIGEN VALOR, TIPO_ORIGEN ELEMENTO FROM dbo.Adm_System_Origen_Usuarios
		ORDER BY TIPO_ORIGEN DESC
    END

    IF @LISTA_VALOR = 'GRUPAPRO' BEGIN
		SELECT ID_GRUPO VALOR, GRUPO_APROBACION ELEMENTO FROM dbo.Adm_System_Grupo_Aprobacion
		WHERE ID_ORG = @ID_ORG
		ORDER BY GRUPO_APROBACION ASC
    END
    
    IF @LISTA_VALOR = 'PROP' BEGIN
		SELECT PROP.ID_HOLDING VALOR, PROP.NOMBRE ELEMENTO 
		FROM dbo.Adm_System_Holding PROP
			INNER JOIN Adm_System_Dueños DUENO
				ON PROP.ID_HOLDING = DUENO.ID_HOLDING_PROPIETARIO
		WHERE ESPROPIETARIO = 1
			AND DUENO.ID_DUEÑO = @ID_DUENO_EXTERNO
		AND PROP.ID_ORG = @ID_ORG
		AND PROP.VIGENCIA = 'S'
		AND DUENO.VIGENCIA = 'S'
		ORDER BY NOMBRE ASC			 	
	 	--SELECT * FROM Adm_System_Holding
		--SELECT * FROM Adm_System_Dueños WHERE 
    END    

    IF @LISTA_VALOR = 'CONTACTO' BEGIN
		SELECT id_contacto VALOR, ISNULL(NOMBRES, '') + ' ' + ISNULL(APELLIDO_PATERNO, '') + ' ' + ISNULL(APELLIDO_MATERNO, '') ELEMENTO 
		FROM Adm_System_Contactos
		WHERE ID_ORG = @ID_ORG
		ORDER BY nombre_completo ASC
    END  
    
    IF @LISTA_VALOR = 'DUENO' BEGIN
		SELECT D.ID_DUEÑO VALOR, ISNULL(C.NOMBRES, '') + ' ' + ISNULL(C.APELLIDO_PATERNO, '') + ' ' + ISNULL(C.APELLIDO_MATERNO, '') ELEMENTO 
		FROM Adm_System_Dueños D
			INNER JOIN Adm_System_Contactos C
				ON D.ID_CONTACTO = C.ID_CONTACTO AND D.ID_ORG = C.ID_ORG
		WHERE D.ID_ORG = @ID_ORG
		ORDER BY C.NOMBRES ASC
    END    

    IF @LISTA_VALOR = 'CLASCARGO' BEGIN
		SELECT ID_Cargo VALOR, Descripcion ELEMENTO FROM Adm_System_Cargos_Dueños--dbo.Adm_System_Clas_Cargos
		WHERE ID_ORG = @ID_ORG
		ORDER BY Descripcion ASC
		--SELECT * FROM Adm_System_Clas_Cargos
    END

    IF @LISTA_VALOR = 'POSCARGO' BEGIN
		SELECT ID_POSCARGO VALOR, POSICION_CARGO ELEMENTO FROM dbo.Adm_System_Posicion_Cargos
		WHERE ID_ORG = @ID_ORG
		ORDER BY POSICION_CARGO ASC
    END

    IF @LISTA_VALOR = 'TIPODOC' BEGIN
		SELECT ID_DOCU VALOR, NOMBRE_DOCU ELEMENTO FROM dbo.Inventario_Tipo_Documentos
		ORDER BY NOMBRE_DOCU ASC
    END
    
    IF @LISTA_VALOR = 'DOCAPRO' BEGIN
		SELECT ID_TIPO_DOCUMENTO VALOR, TIPO_DOCUMENTO ELEMENTO FROM dbo.Adm_System_Tipo_Doc_Aprobacion
		WHERE ID_ORG = @ID_ORG
		ORDER BY TIPO_DOCUMENTO ASC
    END    
    
    IF @LISTA_VALOR = 'COMUNA' BEGIN
		SELECT ID_COMUNA VALOR, NOMBRE ELEMENTO FROM dbo.Adm_System_Comunas
		ORDER BY NOMBRE ASC
    END    

    IF @LISTA_VALOR = 'PAIS' BEGIN
		SELECT ID_PAIS VALOR, NOMBRE ELEMENTO FROM dbo.Adm_System_Paises
		ORDER BY NOMBRE ASC
    END 
    
    IF @LISTA_VALOR = 'CARGO' BEGIN
		SELECT ID_CARGO VALOR, DESCRIPCION ELEMENTO FROM dbo.Adm_System_Cargos_Dueños
		WHERE ID_ORG = @ID_ORG
		ORDER BY DESCRIPCION ASC
    END     
    
    IF @LISTA_VALOR = 'DIR' BEGIN
		SELECT D.ID_DIRECCION VALOR, D.CALLE + ' ' + '#' + D.NUMERO + ' ' + C.NOMBRE ELEMENTO 
		FROM dbo.Adm_System_Direcciones D
			INNER JOIN Adm_System_Comunas C
				ON D.ID_COMUNA = C.ID_COMUNA
		WHERE ID_ORG = @ID_ORG
		ORDER BY ELEMENTO ASC
    END     
    
    IF @LISTA_VALOR = 'RUBRO' BEGIN
		SELECT ID_RUBRO VALOR, DESCRIPCION ELEMENTO FROM dbo.Adm_System_Rubros
		WHERE ID_ORG = @ID_ORG
		ORDER BY DESCRIPCION ASC
    END    
    
    IF @LISTA_VALOR = 'TIPOUSU' BEGIN
		SELECT ID_TIPOUSRO VALOR, TIPO ELEMENTO FROM dbo.Adm_System_Tipo_Usuarios
		WHERE ID_ORG = @ID_ORG
		ORDER BY TIPO ASC
    END       
    
    IF @LISTA_VALOR = 'PROCEDE' BEGIN
		SELECT ID_PROCEDENCIA VALOR, DESCRIPCION ELEMENTO FROM dbo.Adm_System_Procedencias
		ORDER BY DESCRIPCION DESC
    END      
     
    IF @LISTA_VALOR = 'MEDIDA' BEGIN
		SELECT ID_UM VALOR, Unidad_Medida_Abreviada ELEMENTO
		FROM [dbo].[Inventario_Unidad_Medida_Primaria]
		ORDER BY Unidad_Medida_Abreviada ASC    
    END 
    
  --  IF @LISTA_VALOR = 'MEDIDA' BEGIN
		--SELECT ID_UM VALOR, Unidad_Medida_Abreviada ELEMENTO
		--FROM [dbo].[Inventario_Unidad_Medida_Primaria]
		--ORDER BY Unidad_Medida_Abreviada ASC    
  --  END 

    IF @LISTA_VALOR = 'REF' BEGIN
		SELECT ID_Ref_Pred VALOR, Ref_Pred ELEMENTO
		FROM [dbo].[Inventario_Referencias_Todas]
		ORDER BY Ref_Pred ASC    
    END 

    IF @LISTA_VALOR = 'PRODUCTO' BEGIN
		SELECT PROD.COD_ITEM VALOR, PROD.DESCRIPTOR_CORTA ELEMENTO, PROD.PRECIO_COMPRA
		FROM [dbo].[Inventario_Items] PROD
			INNER JOIN Inventario_Items_Prop_Dueños DUENO_PROD
				ON PROD.COD_ITEM = DUENO_PROD.COD_ITEM AND PROD.ID_ORG = DUENO_PROD.ID_ORG
		WHERE PROD.ID_ORG = @ID_ORG
			AND PROD.VIGENCIA = 'S'
			AND DUENO_PROD.ID_DUEÑO = @ID_DUENO_EXTERNO
		ORDER BY PROD.DESCRIPTOR_CORTA ASC    
		
		--select * from Inventario_Items
		
		--select * from Inventario_Items_Prop_Dueños
		
    END   
    
    IF @LISTA_VALOR = 'PRODPRECIO' BEGIN
		SELECT PROD.COD_ITEM VALOR, PROD.DESCRIPTOR_CORTA + '~' + CAST(PRECIO_COMPRA AS VARCHAR(15)) ELEMENTO
		FROM [dbo].[Inventario_Items] PROD
			INNER JOIN Inventario_Items_Prop_Dueños DUENO_PROD
				ON PROD.COD_ITEM = DUENO_PROD.COD_ITEM AND PROD.ID_ORG = DUENO_PROD.ID_ORG
		WHERE PROD.ID_ORG = @ID_ORG
			AND PROD.VIGENCIA = 'S'
			AND DUENO_PROD.ID_DUEÑO = @ID_DUENO_EXTERNO
		ORDER BY PROD.DESCRIPTOR_CORTA ASC    
		
		--select * from Inventario_Items
		
		--select * from Inventario_Items_Prop_Dueños
		
    END   
    
    
    
    IF @LISTA_VALOR = 'SUBINV' BEGIN
		SELECT ID_Subinv VALOR, DESCRIPCION ELEMENTO
		FROM [dbo].Inventario_SubInventarios
		ORDER BY DESCRIPCION ASC    
    END     
    
    IF @LISTA_VALOR = 'TIPOSUBINV' BEGIN
		SELECT COD_TIPO_Subinv VALOR, NOMBRE ELEMENTO
		FROM [dbo].Inventario_Tipo_SubInventario
		ORDER BY NOMBRE ASC    
    END     
    
    IF @LISTA_VALOR = 'ESTADOLOC' BEGIN
		SELECT COD_ESTADO VALOR, NOMBRE ELEMENTO
		FROM [dbo].Inventario_Estado_Localizadores
		ORDER BY NOMBRE ASC    
    END          
	
    IF @LISTA_VALOR = 'PROVEEDOR' BEGIN
		SELECT ID_HOLDING VALOR, NOMBRE ELEMENTO FROM dbo.Adm_System_Holding WHERE ESPROPIETARIO = 0 AND ID_TIPO_CONTACTO = 4
		AND ID_ORG = @ID_ORG
		ORDER BY NOMBRE ASC		
    END    	
	
	IF @LISTA_VALOR = 'CAMPANIA' BEGIN
		
		SELECT Cod_Campaña VALOR, Nombre_Campaña ELEMENTO
		FROM INVENTARIO_ITEMS PROD
			INNER JOIN Inventario_Items_Prop_Dueños PROP_DUENO
				ON PROD.COD_ITEM = PROP_DUENO.COD_ITEM AND PROD.ID_ORG = PROP_DUENO.ID_ORG
			INNER JOIN Inventario_Campaña_Propietarios_Dueños CAMPANIA
				ON PROD.COD_ITEM = CAMPANIA.COD_ITEM AND PROD.ID_ORG = CAMPANIA.ID_ORG
		WHERE --PROD.COD_ITEM = 52196		
			PROP_DUENO.ID_DUEÑO = 12 --@ID_DUENO_EXTERNO
			AND PROP_DUENO.ID_ORG = 17 --@ID_ORG
		--SELECT * FROM Inventario_Items_Prop_Dueños
		
	END
	
	
END
GO
