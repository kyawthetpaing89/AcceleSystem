 BEGIN TRY 
 Drop Procedure dbo.[M_Hinban_Update]
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
CREATE PROCEDURE [dbo].[M_Hinban_Update]
	-- Add the parameters for the stored procedure here
	-- Add the parameters for the stored procedure here
	@CastingCD as varchar(10),
	@ProjectCD as varchar(15),
	@HinbanCD as varchar(6),
	@HinbanName as varchar(60),
	@Color as tinyint,
	@Production int,
	@freeitem1 varchar(10),
	@freeitem2 int,
	@saleprice int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

		    -- Insert statements for procedure here
		
			UPDATE M_Hinban 
			set 
			HinbanName = @HinbanName,
			Casting = @CastingCD,
			Color = @Color ,
			Production = @Production ,
			SalesPrice = @saleprice ,
			FreeItem1 = @freeitem1 ,
			FreeItem2 = @freeitem2 
			WHERE  ProjectCD = @ProjectCD and HinbanCD = @HinbanCD 
			select 'success' as [status],* from M_Message
			where MessageID = 'I101'
		END
