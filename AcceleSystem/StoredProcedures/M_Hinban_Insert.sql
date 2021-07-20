 BEGIN TRY 
 Drop Procedure dbo.[M_Hinban_Insert]
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
CREATE PROCEDURE [dbo].[M_Hinban_Insert]
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
			INSERT INTO M_Hinban (HinbanCD , HinbanName , ProjectCD , Casting ,Color , Production ,SalesPrice , FreeItem1 ,FreeItem2 )
			VALUES(@HinbanCD ,@HinbanName , @ProjectCD ,@CastingCD ,@Color ,@Production ,@saleprice ,@freeitem1 ,@freeitem2 )

			select 'success' as [status],* from M_Message
			where MessageID = 'I101'
		END
