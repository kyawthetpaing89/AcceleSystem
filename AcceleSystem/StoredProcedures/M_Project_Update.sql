 BEGIN TRY 
 Drop Procedure dbo.[M_Project_Update]
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
CREATE PROCEDURE [dbo].[M_Project_Update] 
	-- Add the parameters for the stored procedure here
	@ProjectCD as varchar(15),
	@ProjectName as varchar(60),
	@Year as int,
	@BrandCD as varchar(6),
	@Season as tinyint,
	@PeriodStart as int,
	@PeriodEnd as int,
	@ProjectManager as varchar(20),
	@AllocationCount as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
			UPDATE M_Project
			SET 
				ProjectName=@ProjectName,
				[Year]=@Year,
				BrandCD=@BrandCD,
				Season=@Season,
				PeriodStart=@PeriodStart,
				PeriodEnd=@PeriodEnd,
				ProjectManager=@ProjectManager,
				AllocationCount=@AllocationCount
			WHERE ProjectCD=@ProjectCD

			select 'success' as [status],* from M_Message
			where MessageID = 'I101'
	--end
END


