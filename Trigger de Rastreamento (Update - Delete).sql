CREATE TRIGGER Rastreio_TR_DEL
    ON NomeTabela
    FOR DELETE
AS

DECLARE @corpoEmail INT
SET @corpoEmail = (SELECT deleted.id_gama_acessorio_nao_fabrica FROM deleted  )

DECLARE @assunto  VARCHAR (6)
SET @assunto = (SELECT deleted.cd_acessorio FROM deleted  )

    EXEC msdb.dbo.sp_send_dbmail  
		@recipients='email@email.com',
		@subject= @assunto,
		@body= @corpoEmail,
		@from_address='email@email.com',
		@reply_to='email@email.com'
GO


CREATE TRIGGER Rastreio_TR_UPD
    ON prc_vinculo_nao_fabrica
    FOR UPDATE
AS

DECLARE @corpoEmail INT
SET @corpoEmail = (SELECT Inserted.id_gama_acessorio_nao_fabrica FROM Inserted  )

DECLARE @assunto  VARCHAR (6)
SET @assunto = (SELECT Inserted.cd_acessorio FROM Inserted  )

    EXEC msdb.dbo.sp_send_dbmail  
		@recipients='email@email.com',
		@subject= @assunto,
		@body= @corpoEmail,
		@from_address='email@email.com',
		@reply_to='email@email.com'
GO