 BEGIN TRY 
 Drop Procedure dbo.[M_User_Delete]
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
CREATE PROCEDURE [dbo].[M_User_Delete] 
	-- Add the parameters for the stored procedure here
	@ID as varchar(20)
	--@UserName as varchar(40),	
	--@Password as varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete from M_User
	where ID=@ID

	select 'success' as [status],* from M_Message
	where MessageID = 'I102'
		  
END
