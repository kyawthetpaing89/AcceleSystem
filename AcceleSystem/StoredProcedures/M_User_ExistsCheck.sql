 BEGIN TRY 
 Drop Procedure dbo.[M_User_ExistsCheck]
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
CREATE PROCEDURE [dbo].[M_User_ExistsCheck] 
	-- Add the parameters for the stored procedure here
	@ID as varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if exists(select 1 from M_User
				where ID = @ID)
		begin
			select mm.*,mu.* from M_Message mm ,M_User mu
			where MessageID = 'E107'
			and ID = @ID	
			
		end
	else
		begin
			select * from M_Message
			where MessageID = 'E101'	
		end
	
END
