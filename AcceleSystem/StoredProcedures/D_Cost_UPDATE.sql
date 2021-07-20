 BEGIN TRY 
 Drop Procedure dbo.[D_Cost_UPDATE]
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
CREATE PROCEDURE [dbo].[D_Cost_UPDATE]
	-- Add the parameters for the stored procedure here
	@SEQ as int,
	@CostCD as int,
	@Year as int,
	@Season as tinyint,
	@CostDate as date,
	@BrandCD as varchar(6),
	@ProjectCD as varchar(15),
	@HinbanCD as varchar(6),
	@CastingCD as varchar(10),
	@FreeItem1 as varchar(10),
	@ZeikomiKBN as tinyint,
	@CostAmount as int,
	@InputAmount as int,
	@Remarks as varchar(60)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update D_Cost
	Set CostCD=@CostCD,[Year]=ISNULL(@Year,0),Season=@Season,CostDate=@CostDate,BrandCD=@BrandCD,ProjectCD=@ProjectCD,HinbanCD=@HinbanCD,
	CastingCD=@CastingCD,FreeItem1=@FreeItem1,ZeikomiKBN=@ZeikomiKBN,CostAmount=@CostAmount,InputAmount=@InputAmount,Remarks=@Remarks
	Where SEQ = @SEQ


	select 'success' as [status],* from M_Message
	where MessageID = 'I101'

END
