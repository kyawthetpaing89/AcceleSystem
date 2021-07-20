 BEGIN TRY 
 Drop Procedure dbo.[M_User_Insert]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[M_User_Insert] 
	-- Add the parameters for the stored procedure here
	@ID as varchar(20),
	@UserName as varchar(40),	
	@Password as varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if exists(select 1 from M_User
				where ID = @ID)
		begin
			select 'error' as [status],* from M_Message
			where MessageID = 'E107'
		end
	else
		begin
		    -- Insert statements for procedure here
			INSERT INTO [M_User](ID,UserName,Password)
			VALUES(@ID,@UserName,@Password)

			select 'success' as [status],* from M_Message
			where MessageID = 'I101'
		end
END
