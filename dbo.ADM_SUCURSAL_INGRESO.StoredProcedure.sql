USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_SUCURSAL_INGRESO]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Ingresar un nuevo Registro
Parametros
@ID_Holding  : 
@EsPropietario  : 
@Fech_Creacion  : 
@Fech_Actualiza  : 
@ID_Org  : 
@ID_Holding_Propietario  : 
@ID_Direccion  : 
@ID_Rubro  : 
@ID_Usro_Crea  : 
@ID_Usro_Act  : 
@RUT  : 
@Nombre  : 
@Tipo  : 
@Procedencia  : 
@Vigencia  : 
Creado : 10/04/2017.
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_SUCURSAL_INGRESO]
	@ID_Holding  int,
	@EsPropietario  int,
	@ID_Org  numeric,
	@ID_Holding_Propietario  numeric,
	@ID_Direccion  numeric,
	@ID_Rubro  numeric,
	@ID_Usro_Crea  numeric,
	@ID_Usro_Act  numeric,
	@RUT  varchar(max),
	@Nombre  varchar(max),
	@Tipo  NUMERIC(18, 0),
	@ProcedenciaId  numeric(18, 0),
	@Vigencia  varchar(1)
	AS
	SET NOCOUNT ON;
	DECLARE @NUEVO_ID NUMERIC(18, 0);
	
	IF @ID_Holding=0 BEGIN
		--- INGRESA NUEVO REGISTRO ---
		INSERT INTO Adm_System_Holding
		(
		EsPropietario  ,
		Fech_Creacion  ,
		ID_Org  ,
		ID_Holding_Propietario  ,
		ID_Direccion  ,
		ID_Rubro  ,
		ID_Usro_Crea  ,
		RUT  ,
		Nombre  ,
		ID_Tipo_CONTACTO  ,
		Id_Procedencia  ,
		Vigencia  
		)
		VALUES
		(
		--@ID_Holding  ,
		@EsPropietario  ,
		GETDATE()  ,
		@ID_Org  ,
		@ID_Holding_Propietario  ,
		@ID_Direccion  ,
		@ID_Rubro  ,
		@ID_Usro_Crea  ,
		@RUT  ,
		@Nombre  ,
		2  ,
		@ProcedenciaId  ,
		@Vigencia  
		)
		---RETORNO IDENTIFICADOR NUEVO USUARIO---
		SET @NUEVO_ID = @@IDENTITY
		
		SELECT @@IDENTITY AS ID
		
END
ELSE
BEGIN
---MODIFICA REGISTRO EXISTENTE---
DECLARE @ID_tabla  int
SET   @ID_tabla  =@ID_Holding
UPDATE Adm_System_Holding
SET 
--ID_Holding  =@ID_Holding,
EsPropietario  =@EsPropietario,
Fech_Actualiza  =Getdate(),
ID_Org  =@ID_Org,
ID_Holding_Propietario  =@ID_Holding_Propietario,
ID_Direccion  =@ID_Direccion,
ID_Rubro  =@ID_Rubro,
ID_Usro_Act  =@ID_Usro_Act,
RUT  =@RUT,
Nombre  =@Nombre,
ID_Tipo_CONTACTO  =2,
Id_Procedencia  =@ProcedenciaId,
Vigencia  =@Vigencia
WHERE
ID_Holding=@ID_tabla

--- RETORNO FILAS AFECTADAS ---
SELECT @@ROWCOUNT AS FILAS_AFECTADAS

END


GO
