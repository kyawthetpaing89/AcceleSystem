 BEGIN TRY 
 Drop Procedure dbo.[M_Keihi_ExistsCheck]
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
CREATE PROCEDURE [dbo].[M_Keihi_ExistsCheck] 
	-- Add the parameters for the stored procedure here
	@CostCD as varchar(6)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(select 1 from M_Keihi
				where CostCD = @CostCD)
		begin
			select mm.*,mk.* from M_Message mm ,M_Keihi mk
			where MessageID = 'E107'
			and CostCD = @CostCD			
		end
	else
		begin
			select * from M_Message
			where MessageID = 'E101'	
		end
END
