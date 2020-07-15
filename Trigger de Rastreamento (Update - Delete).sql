CREATE TRIGGER Rastreio_TR_DEL
    ON NomeTabela
    FOR DELETE
AS

DECLARE @corpoEmail INT
SET @corpoEmail = (SELECT deleted.nomecampo FROM deleted  )

DECLARE @assunto  VARCHAR (6)
SET @assunto = (SELECT deleted.nomecampo FROM deleted  )

    EXEC msdb.dbo.sp_send_dbmail  
		@recipients='email@email.com',
		@subject= @assunto,
		@body= @corpoEmail,
		@from_address='email@email.com',
		@reply_to='email@email.com'
GO


CREATE TRIGGER Rastreio_TR_UPD
    ON NomeTabela
    FOR UPDATE
AS

DECLARE @corpoEmail INT
SET @corpoEmail = (SELECT Inserted.nomecampo FROM Inserted  )

DECLARE @assunto  VARCHAR (6)
SET @assunto = (SELECT Inserted.nomecampo FROM Inserted  )

    EXEC msdb.dbo.sp_send_dbmail  
		@recipients='email@email.com',
		@subject= @assunto,
		@body= @corpoEmail,
		@from_address='email@email.com',
		@reply_to='email@email.com'
GO