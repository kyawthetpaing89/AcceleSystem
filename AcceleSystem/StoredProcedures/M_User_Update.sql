 BEGIN TRY 
 Drop Procedure dbo.[M_User_Update]
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
CREATE PROCEDURE [dbo].[M_User_Update] 
	-- Add the parameters for the stored procedure here
	@ID as varchar(20),
	@UserName as varchar(40),	
	@Password as varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE M_User
	SET UserName=@UserName,
		Password=@Password
	WHERE ID=@ID;

	select 'success' as [status],* from M_Message
	where MessageID = 'I101'
END
