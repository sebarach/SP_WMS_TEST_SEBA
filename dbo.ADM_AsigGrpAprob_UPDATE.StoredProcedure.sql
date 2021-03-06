USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[ADM_AsigGrpAprob_UPDATE]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Autor : Patricio Cabezas.
Objetivo : Modifica un  Registro
Parametros
@Fech_Creacion  : 
@Fech_Actualiza  : 
@ID_Grupo  : 
@ID_Holding_Propietario  : 
@ID_Dueño  : 
@ID_Org  : 
@ID_Usro_Crea  : 
@ID_Usro_Act  : 
@Vigencia  : 
Creado : 15/04/2017.
Modifado : 1.
***********************************************
--Forma de Invocar.
***********************************************
***********************************************
*/
CREATE PROCEDURE [dbo].[ADM_AsigGrpAprob_UPDATE]
@ID_Grupo  numeric,
@ID_Holding_Propietario  numeric,
@ID_Dueno  numeric,
@ID_Org  numeric,
@ID_Usro_Act  numeric,
@Vigencia  varchar(1)
AS
SET NOCOUNT ON;
BEGIN
---  MODIFICA REGISTRO EXISTENTE ---
UPDATE Adm_System_Asignacion_Grupo_Aprobacion
SET 
ID_Grupo =  @ID_Grupo,
ID_Holding_Propietario  =@ID_Holding_Propietario,
ID_Dueño  =@ID_Dueno,
ID_Org  =@ID_Org,
ID_Usro_Act  =@ID_Usro_Act,
Vigencia  =@Vigencia,
Fech_Actualiza = GETDATE()
WHERE

ID_Grupo =  @ID_Grupo
AND ID_Holding_Propietario = @ID_Holding_Propietario 
AND ID_Dueño = @ID_Dueno  
AND ID_Org = @ID_Org  

--- RETORNO FILAS AFECTADAS ---
SELECT @@ROWCOUNT FILAS_AFECTADAS

END


GO
