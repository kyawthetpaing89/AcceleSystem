 BEGIN TRY 
 Drop Procedure dbo.[UserLogin_Select]
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
CREATE PROCEDURE [dbo].[UserLogin_Select] 
	-- Add the parameters for the stored procedure here
	@UserID as varchar(10),
	@Password as varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select ID,UserName,Password from [M_User]
	where ID = @UserID 
	and [Password] = @Password
END
