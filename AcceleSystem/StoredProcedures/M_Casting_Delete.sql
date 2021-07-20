 BEGIN TRY 
 Drop Procedure dbo.[M_Casting_Delete]
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
CREATE PROCEDURE [dbo].[M_Casting_Delete] 
	-- Add the parameters for the stored procedure here
	@CastingCD as varchar(10)
	--@CastingName as varchar(20),	
	--@BrandCD as varchar(20),
	--@BrandName as varchar(40),	
	--@UseLimit as date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	delete from M_Casting
	where CastingCD=@CastingCD

	select 'success' as [status],* from M_Message
	where MessageID = 'I102'
END
