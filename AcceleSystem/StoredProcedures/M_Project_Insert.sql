 BEGIN TRY 
 Drop Procedure dbo.[M_Project_Insert]
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
CREATE PROCEDURE [dbo].[M_Project_Insert]
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
			INSERT INTO [M_Project](ProjectCD,ProjectName,[Year],BrandCD,Season,PeriodStart,PeriodEnd,ProjectManager,AllocationCount)
			VALUES(@ProjectCD,@ProjectName,@Year,@BrandCD,@Season,@PeriodStart,@PeriodEnd,@ProjectManager,@AllocationCount)
			select 'success' as [status],* from M_Message
			where MessageID = 'I101'
		--end

	END
