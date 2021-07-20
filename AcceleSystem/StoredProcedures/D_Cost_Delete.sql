 BEGIN TRY 
 Drop Procedure dbo.[D_Cost_Delete]
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
CREATE PROCEDURE [dbo].[D_Cost_Delete]
	-- Add the parameters for the stored procedure here
	@SEQ as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Delete 
	From D_Cost
	Where SEQ = @SEQ

	select 'success' as [status],* from M_Message
	where MessageID = 'I102'
END
