CREATE TRIGGER prc_vinculo_nao_fabrica_TR_D
    ON prc_vinculo_nao_fabrica
    FOR DELETE
AS

DECLARE @corpoEmail INT
SET @corpoEmail = (SELECT deleted.id_gama_acessorio_nao_fabrica FROM deleted  )

DECLARE @assunto  VARCHAR (6)
SET @assunto = (SELECT deleted.cd_acessorio FROM deleted  )

    EXEC msdb.dbo.sp_send_dbmail  
		@recipients='guido.jose@localiza.com',
		@subject= @assunto,
		@body= @corpoEmail,
		@from_address='NaoResponda_Precificacao_Delete_Vinculo@localiza.com',
		@reply_to='guido.jose@localiza.com'
GO


CREATE TRIGGER prc_vinculo_nao_fabrica_TR_U
    ON prc_vinculo_nao_fabrica
    FOR UPDATE
AS

DECLARE @corpoEmail INT
SET @corpoEmail = (SELECT Inserted.id_gama_acessorio_nao_fabrica FROM Inserted  )

DECLARE @assunto  VARCHAR (6)
SET @assunto = (SELECT Inserted.cd_acessorio FROM Inserted  )

    EXEC msdb.dbo.sp_send_dbmail  
		@recipients='guido.jose@localiza.com',
		@subject= @assunto,
		@body= @corpoEmail,
		@from_address='NaoResponda_Precificacao_Update_Vinculo@localiza.com',
		@reply_to='guido.jose@localiza.com'
GO