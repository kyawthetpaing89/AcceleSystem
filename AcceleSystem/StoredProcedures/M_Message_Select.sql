 BEGIN TRY 
 Drop Procedure dbo.[M_Message_Select]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		kyaw thet paing
-- Create date: 2020/07/13
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[M_Message_Select]
	-- Add the parameters for the stored procedure here
	@MessageID as varchar(4)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from M_Message where MessageID = @MessageID
END
