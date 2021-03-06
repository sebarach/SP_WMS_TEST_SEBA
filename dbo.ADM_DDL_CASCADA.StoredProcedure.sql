USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_DDL_CASCADA]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ADM_DDL_CASCADA]
	-- Add the parameters for the stored procedure here
	@LISTA_VALOR VARCHAR(12),
	@ID_PROP NUMERIC(18, 0),
	@ID_ORG NUMERIC(18, 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here 
    IF @LISTA_VALOR = 'CLASCARGO' BEGIN
		SELECT ID_CLASCargo VALOR, CLASIFICACION_CARGO ELEMENTO FROM Adm_System_Clas_Cargos
		WHERE ID_ORG = @ID_ORG
		ORDER BY CLASIFICACION_CARGO ASC
		--SELECT * FROM Adm_System_Clas_Cargos
    END

    IF @LISTA_VALOR = 'CLASCARGO_' BEGIN
		SELECT ID_CLASCargo VALOR, CLASIFICACION_CARGO ELEMENTO FROM Adm_System_Clas_Cargos
		WHERE ID_ORG = @ID_ORG
			AND ID_HOLDING_PROPIETARIO = @ID_PROP
		ORDER BY CLASIFICACION_CARGO ASC
		--SELECT * FROM Adm_System_Clas_Cargos
    END

    IF @LISTA_VALOR = 'POSCARGO' BEGIN
		SELECT ID_POSCARGO VALOR, POSICION_CARGO ELEMENTO FROM dbo.Adm_System_Posicion_Cargos
		WHERE ID_ORG = @ID_ORG
		ORDER BY POSICION_CARGO ASC
    END
    
    IF @LISTA_VALOR = 'POSCARGO_' BEGIN
		SELECT ID_POSCARGO VALOR, POSICION_CARGO ELEMENTO FROM dbo.Adm_System_Posicion_Cargos		
		WHERE ID_ORG = @ID_ORG
			AND ID_HOLDING_PROPIETARIO = @ID_PROP
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
		SELECT MIN(ID_HOLDING) VALOR, NOMBRE ELEMENTO FROM dbo.Adm_System_Holding WHERE ESPROPIETARIO = 0 AND ID_TIPO_CONTACTO = 4
		AND ID_ORG = @ID_ORG
		GROUP BY NOMBRE
		ORDER BY NOMBRE ASC		
    END    	
	
    IF @LISTA_VALOR = 'DUENO' BEGIN
		SELECT D.ID_DUEÑO VALOR, ISNULL(C.NOMBRES, '') + ' ' + ISNULL(C.APELLIDO_PATERNO, '') + ' ' + ISNULL(C.APELLIDO_MATERNO, '') ELEMENTO 
		FROM Adm_System_Dueños D
			INNER JOIN Adm_System_Contactos C
				ON D.ID_CONTACTO = C.ID_CONTACTO AND D.ID_ORG = C.ID_ORG
		WHERE D.ID_ORG = @ID_ORG AND D.ID_HOLDING_PROPIETARIO = @ID_PROP
		ORDER BY C.NOMBRES ASC
    END 	
	
    IF @LISTA_VALOR = 'CENTROCOSTO' BEGIN
		SELECT COD_CENTRO VALOR, NOMBRE_CC ELEMENTO FROM Ventas_Centros_Costos_Propietarios
		WHERE ID_HOLDING_PROPIETARIO = @ID_PROP
		ORDER BY NOMBRE_CC ASC
    END 	
	
	
    IF @LISTA_VALOR = 'LOGINS' BEGIN
		SELECT ID_USRO VALOR, USERNAME ELEMENTO FROM dbo.Adm_System_Usuarios
		WHERE ID_ORG = @ID_ORG
		ORDER BY USERNAME ASC
    END	
	
	
	
END
GO
