USE [iwmscl_prodwms]
GO
/****** Object:  StoredProcedure [dbo].[INV_ENVIO_DISTRIBUIR]    Script Date: 19-08-2020 16:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- ================================================
---- Template generated from Template Explorer using:
---- Create Procedure (New Menu).SQL
----
---- Use the Specify Values for Template Parameters 
---- command (Ctrl-Shift-M) to fill in the parameter 
---- values below.
----
---- This block of comments will not be included in
---- the definition of the procedure.
---- ================================================
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
---- =============================================
---- Author:		<Author,,Name>
---- Create date: <Create Date,,>
---- Description:	<Description,,>
---- =============================================
/*
EXEC INV_ENVIO_CONFIRMAR 17, 4,
'<root>
  <f id="1" solicitudid="304" pedidoid="21" chkseleccion="True" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="12" dueno="PERCY ROSS STANLEY" direccionid="6030" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="4" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="1" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000033" loteproveedor="S/L" fechavencimiento="25/06/2017" cantidadpedida="80" cantidadpendiente="80" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="2" solicitudid="304" pedidoid="21" chkseleccion="True" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="12" dueno="PERCY ROSS STANLEY" direccionid="6030" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="4" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
</root>'

*/
CREATE PROCEDURE [dbo].[INV_ENVIO_DISTRIBUIR]
--DECLARE
	 @FOLIO_DOCUMENTO NUMERIC(18, 0)
	,@ID_Org numeric(18, 0)
	,@ID_USRO_ACT NUMERIC(18, 0)		
	,@XML varchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

/*


'<root>
  <f id="1" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="12" dueno="PERCY ROSS STANLEY A" direccionid="6030" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="1" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000033" loteproveedor="S/L" fechavencimiento="25/06/2017" cantidadpedida="80" cantidadpendiente="80" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="2" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="13" dueno="PERCY ROSS STANLEY B" direccionid="6030" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />  
  <f id="3" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="14" dueno="PERCY ROSS STANLEY C" direccionid="6040" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="4" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="15" dueno="PERCY ROSS STANLEY D" direccionid="6050" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="5" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="16" dueno="PERCY ROSS STANLEY E" direccionid="6060" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="1" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000033" loteproveedor="S/L" fechavencimiento="25/06/2017" cantidadpedida="80" cantidadpendiente="80" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="6" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="16" dueno="PERCY ROSS STANLEY E" direccionid="6060" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />  
  <f id="7" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="17" dueno="PERCY ROSS STANLEY F" direccionid="6060" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />
  <f id="8" solicitudid="304" pedidoid="21" chkseleccion="False" chkdistribucion="False" propietarioid="13" propietario="PROCTER &amp; GAMBLE CHILE LTDA." duenoid="17" dueno="PERCY ROSS STANLEY F" direccionid="6060" direccion="JOSE SANTOS LEIVA #, Arica" nombredestinatario="NOMBRE_DESTINATARIO" numeroentrega="0" estadolineaactualid="20" estadolineaactual="En Etapas/Con Seleccion Confirmada" estadolineasiguiente="Espera Confirmacion de Envio" nrolinea="1" nrosublinea="2" productoid="53150" descriptor="BIG BOY AMPOLLA PANTENE PRO-V" loteid="201705000032" loteproveedor="S/L" fechavencimiento="30/06/2017" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="40" cantidadenviar="0" precio="45000" subinventarioorigenid="60" subinventarioorigen="1-STAGE" localizadororigenid="99999" localizadororigen="" subinventariodestino="" operario="Luis" />  
</root>'

*/

--	SET @FOLIO_DOCUMENTO = 40899
--	SET @ID_Org = 17
--	SET @ID_USRO_ACT = 4
--	SET @XML = '<root>
--  <f id="1" solicitudid="77" pedidoid="40" chkseleccion="" chkdistribucion="" propietarioid="273" propietario="IANSAGRO S.A." duenoid="528" dueno="CATALINA VALENZUELA DEL VALLE" destinatarioid="19695" direccion="AV. LO ESPEJO #860 BODEGA 35, MAIPÚ, SANTIAGO" nombredestinatario="DISTRIBUIDORA DAS" numeroentrega="46" estadolineaactualid="0" estadolineaactual="" estadolineasiguiente="" nrolinea="0" nrosublinea="0" productoid="50535" descriptor="PORTA PRECIO SALSA CACHORRO" loteid="" loteproveedor="" fechavencimiento="" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="0" cantidadenviar="10" precio="116" subinventarioorigenid="0" subinventarioorigen="" localizadororigenid="0" localizadororigen="" subinventariodestino="" operario="" />
--  <f id="2" solicitudid="77" pedidoid="40" chkseleccion="" chkdistribucion="" propietarioid="273" propietario="IANSAGRO S.A." duenoid="528" dueno="CATALINA VALENZUELA DEL VALLE" destinatarioid="19695" direccion="AV. LO ESPEJO #860 BODEGA 35, MAIPÚ, SANTIAGO" nombredestinatario="DISTRIBUIDORA DAS" numeroentrega="46" estadolineaactualid="0" estadolineaactual="" estadolineasiguiente="" nrolinea="0" nrosublinea="0" productoid="50534" descriptor="PORTA PRECIO GALLETA ADULTO" loteid="" loteproveedor="" fechavencimiento="" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="0" cantidadenviar="10" precio="116" subinventarioorigenid="0" subinventarioorigen="" localizadororigenid="0" localizadororigen="" subinventariodestino="" operario="" />
--  <f id="3" solicitudid="77" pedidoid="40" chkseleccion="" chkdistribucion="" propietarioid="273" propietario="IANSAGRO S.A." duenoid="528" dueno="CATALINA VALENZUELA DEL VALLE" destinatarioid="19851" direccion="ROSARIO NORTE #615 PISO 23, LAS CONDES, SANTIAGO" nombredestinatario="IANSAGRO S.A." numeroentrega="47" estadolineaactualid="0" estadolineaactual="" estadolineasiguiente="" nrolinea="0" nrosublinea="0" productoid="50535" descriptor="PORTA PRECIO SALSA CACHORRO" loteid="" loteproveedor="" fechavencimiento="" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="0" cantidadenviar="10" precio="116" subinventarioorigenid="0" subinventarioorigen="" localizadororigenid="0" localizadororigen="" subinventariodestino="" operario="" />
--  <f id="4" solicitudid="77" pedidoid="40" chkseleccion="" chkdistribucion="" propietarioid="273" propietario="IANSAGRO S.A." duenoid="528" dueno="CATALINA VALENZUELA DEL VALLE" destinatarioid="19851" direccion="ROSARIO NORTE #615 PISO 23, LAS CONDES, SANTIAGO" nombredestinatario="IANSAGRO S.A." numeroentrega="47" estadolineaactualid="0" estadolineaactual="" estadolineasiguiente="" nrolinea="0" nrosublinea="0" productoid="50534" descriptor="PORTA PRECIO GALLETA ADULTO" loteid="" loteproveedor="" fechavencimiento="" cantidadpedida="0" cantidadpendiente="0" cantidadpickeada="0" cantidadenviar="10" precio="116" subinventarioorigenid="0" subinventarioorigen="" localizadororigenid="0" localizadororigen="" subinventariodestino="" operario="" />
--</root>'
	
	--DECLARE @ID_LOCALIZADOR_STAGE NUMERIC(18, 0) = (SELECT ID_LOCALIZADOR FROM Inventario_SubInv_Localizadores WHERE ID_SUBINV = 60)
	DECLARE @FECHA_TRANSACCION DATETIME = (SELECT GETDATE());	

	--OBTENCIÓN NOMBRE DE USUARIO QUE IMPRIME
	DECLARE @NOMBRE_DESPACHADOR VARCHAR(200);
	
	SELECT @NOMBRE_DESPACHADOR = U.NOMBRES + ' ' + U.APELLIDO_PATERNO -- + ' ' + U.APELLIDO_MATERNO
	FROM Adm_System_Usuarios U
	WHERE U.ID_USRO = @ID_USRO_ACT AND U.ID_ORG = @ID_ORG

	DECLARE @OXML XML;
	SET @OXML = N'''' + @XML + '''';
	
	--TABLA TEMPORAL DEL XML
	DECLARE @TABLAXML TABLE(
		id numeric(18, 0)	,
		solicitudid numeric(18, 0)	,
		pedidoid numeric(18, 0)	,
		--chkseleccion varchar(6)	,
		--chkdistribucion varchar(6)	,
		propietarioid numeric(18, 0)	,
		propietario varchar(250)	,
		duenoid numeric(18, 0)	,
		dueno varchar(250)	,
		destinatarioid numeric(18, 0)	,
		direccion varchar(300)	,
		nombredestinatario varchar(250)	,
		numeroentrega numeric(18, 0)	,
		--estadolineaactualid numeric(18, 0)	,
		--estadolineaactual varchar(250)	,
		--estadolineasiguiente varchar(250)	,
		nrolinea numeric(18, 0)	,
		nrosublinea numeric(18, 0)	,
		productoid numeric(18, 0)	,
		descriptor varchar(250)	,
		loteid varchar(50)	,
		--loteproveedor varchar(250)	,
		--fechavencimiento varchar(20)	,
		cantidadpedida numeric(18, 0)	,
		cantidadpendiente numeric(18, 0)	,
		cantidadpickeada numeric(18, 0)	,
		cantidadenviar numeric(18, 0)	,
		precio numeric(18, 0)	--,
		--subinventarioorigenid numeric(18, 0)	,
		--subinventarioorigen varchar(250)	,
		--localizadororigenid numeric(18, 0)	,
		--localizadororigen varchar(250)	,
		--subinventariodestino varchar(250)	,
		--operario varchar(250)	
	)
	
	
	INSERT INTO @TABLAXML
	SELECT
		 Tbl.Col.value('@id', 'numeric(18, 0)') id
		,Tbl.Col.value('@solicitudid', 'numeric(18, 0)') solicitudid
		,Tbl.Col.value('@pedidoid', 'numeric(18, 0)') pedidoid
		--,Tbl.Col.value('@chkseleccion', 'varchar(6)') chkseleccion
		--,Tbl.Col.value('@chkdistribucion', 'varchar(6)') chkdistribucion
		,Tbl.Col.value('@propietarioid', 'numeric(18, 0)') propietarioid
		,Tbl.Col.value('@propietario', 'varchar(250)') propietario
		,Tbl.Col.value('@duenoid', 'numeric(18, 0)') duenoid
		,Tbl.Col.value('@dueno', 'varchar(250)') dueno
		,Tbl.Col.value('@destinatarioid', 'numeric(18, 0)') destinatarioid
		,Tbl.Col.value('@direccion', 'varchar(300)') direccion
		,Tbl.Col.value('@nombredestinatario', 'varchar(250)') nombredestinatario
		,Tbl.Col.value('@numeroentrega', 'numeric(18, 0)') numeroentrega
		--,Tbl.Col.value('@estadolineaactualid', 'numeric(18, 0)') estadolineaactualid
		--,Tbl.Col.value('@estadolineaactual', 'varchar(250)') estadolineaactual
		--,Tbl.Col.value('@estadolineasiguiente', 'varchar(250)') estadolineasiguiente
		,Tbl.Col.value('@id', 'numeric(18, 0)') nrolinea
		,Tbl.Col.value('@nrosublinea', 'numeric(18, 0)') nrosublinea
		,Tbl.Col.value('@productoid', 'numeric(18, 0)') productoid
		,Tbl.Col.value('@descriptor', 'varchar(250)') descriptor
		,Tbl.Col.value('@loteid', 'varchar(50)') loteid
		--,Tbl.Col.value('@loteproveedor', 'varchar(250)') loteproveedor
		--,Tbl.Col.value('@fechavencimiento', 'varchar(20)') fechavencimiento
		,Tbl.Col.value('@cantidadpedida', 'numeric(18, 0)') cantidadpedida
		,Tbl.Col.value('@cantidadpendiente', 'numeric(18, 0)') cantidadpendiente
		,Tbl.Col.value('@cantidadpickeada', 'numeric(18, 0)') cantidadpickeada
		,Tbl.Col.value('@cantidadenviar', 'numeric(18, 0)') cantidadenviar
		,Tbl.Col.value('@precio', 'numeric(18, 0)') precio
		--,Tbl.Col.value('@subinventarioorigenid', 'numeric(18, 0)') subinventarioorigenid
		--,Tbl.Col.value('@subinventarioorigen', 'varchar(250)') subinventarioorigen
		--,Tbl.Col.value('@localizadororigenid', 'numeric(18, 0)') localizadororigenid
		--,Tbl.Col.value('@localizadororigen', 'varchar(250)') localizadororigen
		--,Tbl.Col.value('@subinventariodestino', 'varchar(250)') subinventariodestino
		--,Tbl.Col.value('@operario', 'varchar(250)') operario
	FROM @OXML.nodes('//root/f') Tbl(Col)	


	--SELECT
	--		--id
	--	 	solicitudid
	--	,	pedidoid
	--	,	propietarioid
	--	,	propietario
	--	,	duenoid
	--	,	dueno
	--	,	direccionid
	--	,	direccion
	--	,	nombredestinatario
	--	,	numeroentrega
	--	,	nrolinea
	--	--,	nrosublinea
	--	,	productoid
	--	,	descriptor
	--	--,	loteid
	--	--,	SUM(cantidadpedida) cantidadpedida
	--	--,	SUM(cantidadpendiente) cantidadpendiente
	--	--,	SUM(cantidadpickeada) cantidadpickeada
	--	,	SUM(cantidadenviar) cantidadenviar
	--	,	precio		
	--FROM @TABLAXML
	--GROUP BY 
	--	 	solicitudid
	--	,	pedidoid
	--	,	propietarioid
	--	,	propietario
	--	,	duenoid
	--	,	dueno
	--	,	direccionid
	--	,	direccion
	--	,	nombredestinatario
	--	,	numeroentrega
	--	,	nrolinea
	--	--,	nrosublinea
	--	,	productoid
	--	,	descriptor
	--	--,	loteid
	--	--,	cantidadpedida
	--	--,	cantidadpendiente
	--	--,	cantidadpickeada
	--	--,	cantidadenviar
	--	,	precio		
	--ORDER BY numeroentrega ASC
	----SELECT * FROM Inventario_Tipo_Documentos 
	----SELECT * FROM INVENTARIO_CABECERA_DOCUMENTOS
	----SELECT * FROM Inventario_Detalle_Documentos


BEGIN TRAN
BEGIN TRY
	
	
	DECLARE @FOLIO_GUIADESPACHO_ACTUAL NUMERIC(18, 0) = @FOLIO_DOCUMENTO - 1; --(SELECT Ultimo_Folio FROM Inventario_Tipo_Documentos WHERE Id_Docu = 40);
	
	--UPDATE Inventario_Tipo_Documentos
	--	SET Ultimo_Folio = Ultimo_Folio
	--WHERE Id_Docu = 40;
	
	--SET @FOLIO_GUIADESPACHO_ACTUAL = @FOLIO_GUIADESPACHO_ACTUAL - 1
	
	DECLARE 
		@ID NUMERIC(18, 0)	,
		@SOLICITUDID NUMERIC(18, 0)	,
		@PEDIDOID NUMERIC(18, 0)	,
		@PROPIETARIOID NUMERIC(18, 0)	,
		@PROPIETARIO VARCHAR(250)	,
		@DUENOID NUMERIC(18, 0)	,
		@DUENO VARCHAR(250)	,
		@DESTINATARIOID NUMERIC(18, 0)	,
		@DIRECCION VARCHAR(300)	,
		@NOMBREDESTINATARIO VARCHAR(250)	,
		@NUMEROENTREGA NUMERIC(18, 0)	,
		@NROLINEA NUMERIC(18, 0)	,
		@NROSUBLINEA NUMERIC(18, 0)	,
		@PRODUCTOID NUMERIC(18, 0)	,
		@DESCRIPTOR VARCHAR(250)	,
		@LOTEID VARCHAR(50)	,
		@CANTIDADPEDIDA NUMERIC(18, 0)	,
		@CANTIDADPENDIENTE NUMERIC(18, 0)	,
		@CANTIDADPICKEADA NUMERIC(18, 0)	,
		@CANTIDADENVIAR NUMERIC(18, 0)	,
		@PRECIO NUMERIC(18, 0)	
	
	
	DECLARE CXML CURSOR FOR
	SELECT
			--id
		 	solicitudid
		,	pedidoid
		,	propietarioid
		,	propietario
		,	duenoid
		,	dueno
		,	destinatarioid
		,	direccion
		,	nombredestinatario
		,	numeroentrega
		,	nrolinea
		--,	nrosublinea
		,	productoid
		,	descriptor
		--,	loteid
		--,	SUM(cantidadpedida) cantidadpedida
		--,	SUM(cantidadpendiente) cantidadpendiente
		--,	SUM(cantidadpickeada) cantidadpickeada
		,	SUM(cantidadenviar) cantidadenviar
		,	precio		
	FROM @TABLAXML
	GROUP BY 
		 	solicitudid
		,	pedidoid
		,	propietarioid
		,	propietario
		,	duenoid
		,	dueno
		,	destinatarioid
		,	direccion
		,	nombredestinatario
		,	numeroentrega
		,	nrolinea
		--,	nrosublinea
		,	productoid
		,	descriptor
		--,	loteid
		--,	cantidadpedida
		--,	cantidadpendiente
		--,	cantidadpickeada
		--,	cantidadenviar
		,	precio	
	ORDER BY numeroentrega ASC		
	--SELECT * 
	--FROM @TABLAXML	
	--ORDER BY ID ASC
	
	OPEN CXML
	
	FETCH CXML INTO
		--@ID	,
		@SOLICITUDID	,
		@PEDIDOID	,
		@PROPIETARIOID	,
		@PROPIETARIO	,
		@DUENOID	,
		@DUENO	,
		@DESTINATARIOID	,
		@DIRECCION	,
		@NOMBREDESTINATARIO	,
		@NUMEROENTREGA	,
		@NROLINEA	,
		--@NROSUBLINEA	,
		@PRODUCTOID	,
		@DESCRIPTOR	,
		--@LOTEID	,
		--@CANTIDADPEDIDA	,
		--@CANTIDADPENDIENTE	,
		--@CANTIDADPICKEADA	,
		@CANTIDADENVIAR	,
		@PRECIO			
	
	
	DECLARE @T_ID_DIRECCION NUMERIC(18, 0)
	DECLARE @T_RUT_DESTINATARIO VARCHAR(MAX)
	DECLARE @TEMP_NROENTREGA NUMERIC(18, 0) = 0
		
	DECLARE @LINEA_DETALLE NUMERIC(18, 0) = 0;
	--DECLARE @TEMP_NUMEROENTREGA NUMERIC(18, 0) = 0;
	
	WHILE (@@FETCH_STATUS = 0) BEGIN
		
		SELECT @T_ID_DIRECCION = ID_DIRECCION,
			   @T_RUT_DESTINATARIO = RUT
		FROM Adm_System_Holding 
		WHERE ID_HOLDING = @DESTINATARIOID
		
		IF @TEMP_NROENTREGA <> @NUMEROENTREGA BEGIN
			SET @FOLIO_GUIADESPACHO_ACTUAL = @FOLIO_GUIADESPACHO_ACTUAL + 1;
			PRINT 'DISTINTO'
			SET @LINEA_DETALLE = 1;
			SET @TEMP_NROENTREGA = @NUMEROENTREGA;
			
			--SELECT * FROM INVENTARIO_CABECERA_DOCUMENTOS
			INSERT INTO INVENTARIO_CABECERA_DOCUMENTOS
			   ([Folio_Documento]
			   ,[Id_Docu]
			   ,[Id_Org]
			   ,[Id_Propietario]
			   ,[Id_Dueño]
			   ,[Id_Direccion]
			   ,[Orden_Compra_Cte]
			   ,[Orden_Trabajo]
			   ,[Id_Proveedor]
			   ,[Fecha_Solicitud]
			   ,[Fecha_Entrega]
			   ,[Fecha_Vencimiento]
			   ,[Nro_Entrega]
			   ,[Solicitud_Maquila]
			   ,[Nota]
			   ,[Fech_Creacion]
			   ,[ID_Usro_Crea]
			   ,[Vigencia]
			   ,[ID_ESTADO]
			   ,[NOMBRE_DESTINATARIO]
			   ,[ID_TIPO_CONTACTO]
			   ,[RUT_DESTINATARIO]
			   ,[ID_CLISUC])
			VALUES
			   (@FOLIO_GUIADESPACHO_ACTUAL
			   ,40
			   ,@ID_Org
			   ,@PROPIETARIOID
			   ,@DUENOID
			   ,@T_ID_DIRECCION
			   ,NULL
			   ,NULL
			   ,NULL
			   ,@FECHA_TRANSACCION
			   ,NULL
			   ,NULL
			   ,@NUMEROENTREGA
			   ,NULL
			   ,NULL
			   ,@FECHA_TRANSACCION
			   ,@ID_USRO_ACT
			   ,'S'
			   ,NULL
			   ,@NOMBREDESTINATARIO
			   ,NULL
			   ,@T_RUT_DESTINATARIO
			   ,@DESTINATARIOID);
			   
			   
			   
			--SELECT * FROM Inventario_Tipo_Documentos 
			--SELECT * FROM INVENTARIO_CABECERA_DOCUMENTOS
			--SELECT * FROM Inventario_Detalle_Documentos			   
			INSERT INTO Inventario_Detalle_Documentos
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
				   (@FOLIO_GUIADESPACHO_ACTUAL
				   ,40
				   ,@LINEA_DETALLE --@NROLINEA
				   ,@DESCRIPTOR
				   ,@PRODUCTOID
				   ,@CANTIDADENVIAR
				   ,@CANTIDADENVIAR
				   ,@PRECIO
				   ,@ID_Org
				   ,NULL);
			
		END
		ELSE BEGIN
			
			PRINT 'IGUALES'
			SET @LINEA_DETALLE = @LINEA_DETALLE + 1; 
			--SELECT * FROM Inventario_Tipo_Documentos 
			--SELECT * FROM INVENTARIO_CABECERA_DOCUMENTOS
			--SELECT * FROM Inventario_Detalle_Documentos			   
			INSERT INTO Inventario_Detalle_Documentos
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
				   (@FOLIO_GUIADESPACHO_ACTUAL
				   ,40
				   ,@LINEA_DETALLE --@NROLINEA
				   ,@DESCRIPTOR
				   ,@PRODUCTOID
				   ,@CANTIDADENVIAR
				   ,@CANTIDADENVIAR
				   ,@PRECIO
				   ,@ID_Org
				   ,NULL);						
		
		END

		FETCH CXML INTO
		--@ID	,
		@SOLICITUDID	,
		@PEDIDOID	,
		@PROPIETARIOID	,
		@PROPIETARIO	,
		@DUENOID	,
		@DUENO	,
		@DESTINATARIOID	,
		@DIRECCION	,
		@NOMBREDESTINATARIO	,
		@NUMEROENTREGA	,
		@NROLINEA	,
		--@NROSUBLINEA	,
		@PRODUCTOID	,
		@DESCRIPTOR	,
		--@LOTEID	,
		--@CANTIDADPEDIDA	,
		--@CANTIDADPENDIENTE	,
		--@CANTIDADPICKEADA	,
		@CANTIDADENVIAR	,
		@PRECIO	
	
	END 
	
	
	CLOSE CXML
	
	DEALLOCATE CXML
	
	
	
	
	
	--OBTENCIÓN DE AUTORIZADORES (DUEÑOS)
	DECLARE 
		@DUENO_NOMBRE VARCHAR(300),
		@LISTA_DUENOS_NOMBRE VARCHAR(MAX),
		@CONT_CURSOR INT
	
	DECLARE CDUENOS CURSOR FOR
	SELECT C.NOMBRES + ' ' + C.APELLIDO_PATERNO DUENO
	FROM Inventario_Cabecera_Documentos DOC
		INNER JOIN Adm_System_Dueños D
			ON DOC.ID_DUEÑO = D.ID_DUEÑO AND DOC.ID_ORG = D.ID_ORG
			INNER JOIN Adm_System_Contactos C
				ON D.ID_CONTACTO = C.ID_CONTACTO AND D.ID_ORG = C.ID_ORG			
	WHERE DOC.NRO_ENTREGA = @NUMEROENTREGA
		AND DOC.ID_DOCU = 40
		AND DOC.FECHA_SOLICITUD >= @FECHA_TRANSACCION	
	
	OPEN CDUENOS
	
	FETCH CDUENOS INTO @DUENO_NOMBRE
	
	SET @CONT_CURSOR = 0	
	WHILE(@@FETCH_STATUS = 0) BEGIN
		SET @CONT_CURSOR = @CONT_CURSOR + 1
		
		IF @CONT_CURSOR = 1 BEGIN
			SET @LISTA_DUENOS_NOMBRE = @DUENO_NOMBRE 
		END 
		ELSE BEGIN
			SET @LISTA_DUENOS_NOMBRE = @LISTA_DUENOS_NOMBRE + '~' + @DUENO_NOMBRE
		END
		
		FETCH CDUENOS INTO @DUENO_NOMBRE
	END
	
	CLOSE CDUENOS
	
	DEALLOCATE CDUENOS
	
	
	COMMIT TRANSACTION
	--SELECT @LISTA_DUENOS_NOMBRE
	
	--/* REAL Y CORRECTO
	SELECT 	 
		 DOC.FOLIO_DOCUMENTO FolioDocumento
		,DOC.ID_PROPIETARIO PropietarioId
		,DOC.ID_DUEÑO DuenoId
		,DOC.ID_DIRECCION DireccionId
		,ISNULL(DIR.CALLE, '') + ' #' + ISNULL(DIR.NUMERO, '') + ', ' + ISNULL(COMUNA.NOMBRE, '') Direccion
		,DOC.Nro_Entrega NroEntrega
		,DOC.NOMBRE_DESTINATARIO NombreDestinatario
		--DETALLE
		,DET.NRO_LINEA Linea
		,DET.DESCRIPTOR Descriptor
		,DET.COD_ITEM Sku
		,CAST(DET.CANTIDAD AS NUMERIC(18, 0)) Cantidad
		,DET.PRECIO Precio
		,DOC.RUT_DESTINATARIO
		,PROVINCIA.NOMBRE PROVINCIA
		,@NOMBRE_DESPACHADOR ResponsableEnvio
		,@LISTA_DUENOS_NOMBRE Dueno		
	FROM Inventario_Cabecera_Documentos DOC
		INNER JOIN Adm_System_Holding DESTINO
			ON DOC.ID_CLISUC = DESTINO.ID_HOLDING AND DOC.ID_ORG = DESTINO.ID_ORG --AND DESTINO.ESPROPIETARIO = 0		
		INNER JOIN Adm_System_Direcciones DIR
			ON DESTINO.Id_Direccion = DIR.ID_DIRECCION
		INNER JOIN Adm_System_Comunas COMUNA
			ON DIR.ID_COMUNA = COMUNA.ID_COMUNA
		INNER JOIN Adm_System_Provincias PROVINCIA
			ON COMUNA.ID_PROVINCIA = PROVINCIA.ID_PROVINCIA	
		INNER JOIN Inventario_DETALLE_Documentos DET
			ON DOC.FOLIO_DOCUMENTO = DET.FOLIO_DOCUMENTO AND DOC.ID_ORG = DET.ID_ORG
	WHERE DOC.NRO_ENTREGA IN(SELECT distinct Tbl.Col.value('@numeroentrega', 'numeric(18, 0)') FROM @OXML.nodes('//root/f') Tbl(Col))
		AND DOC.ID_DOCU = 40
		AND DOC.FECHA_SOLICITUD >= @FECHA_TRANSACCION
	ORDER BY DOC.NRO_ENTREGA ASC, DOC.FOLIO_DOCUMENTO ASC, DET.NRO_LINEA ASC	
	
	
	
	
	
	--UPDATE Inventario_Tipo_Documentos
	--	SET Ultimo_Folio = (@FOLIO_GUIADESPACHO_ACTUAL + 1)
	--WHERE Id_Docu = 40;
	
	--SELECT @@TRANCOUNT--ROLLBACK


/*

SELECT * FROM Inventario_Cabecera_Documentos

SELECT * FROM Inventario_Detalle_Documentos

select * from Inventario_Cabecera_Documentos
where Id_Docu = 40
order by Folio_Documento desc



SELECT * FROM Inventario_Detalle_Transacciones ORDER BY FECHA_TRX ASC

SELECT * FROM dbo.Inventario_Stock_Lotes

SELECT * FROM dbo.Inventario_Detalle_Trx_Pedidos

SELECT * FROM dbo.Inventario_Detalle_Pedidos 


-------------------------------------
SELECT * FROM Inventario_Folios_Todos
SELECT * FROM Inventario_Cabecera_Documentos --LA ACTUALIZO AL ÚLTIMO CUANDO GUARDE LA GUIA DE DESPACHO
SELECT * FROM Inventario_Detalle_Trx_Pedidos

*/




/*
SELECT 'SELECT * FROM ' + O.name TABLA, C.name COLUMNA, * 
FROM SYS.all_columns C
	INNER JOIN SYS.all_objects O
		ON C.object_id = O.object_id
WHERE C.name IN('Folio_Num_Entrega', 'Nro_Entrega')


SELECT * FROM SYS.all_objects
*/

	
	
	--SELECT 1 id 
	
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
	
     RAISERROR (@ERRORMENSAJE, @SEVERIDADERROR, @ESTADOERROR)
				 
     --PRINT ERROR_SEVERITY()    
     --PRINT ERROR_STATE()  
     --PRINT ERROR_PROCEDURE()   
     --PRINT ERROR_LINE()   
     --PRINT ERROR_MESSAGE() 
	
END CATCH

	
END
GO
