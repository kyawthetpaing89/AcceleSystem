 BEGIN TRY 
 Drop Procedure dbo.[M_Hinban_Delete]
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
CREATE PROCEDURE [dbo].[M_Hinban_Delete]
	-- Add the parameters for the stored procedure here
	@HinbanCD varchar(10),
	@ProjectCD varchar(15)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Delete from M_Hinban where HinbanCD = @HinbanCD and ProjectCD = @ProjectCD 

	select 'success' as [status],* from M_Message
	where MessageID = 'I102'
	END
