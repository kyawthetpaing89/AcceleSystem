 BEGIN TRY 
 Drop Procedure dbo.[M_Keihi_Select_List]
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
CREATE PROCEDURE [dbo].[M_Keihi_Select_List] 
	-- Add the parameters for the stored procedure here
		@CostCD as varchar(6) = null,
		@CostName as varchar(40) = null
		

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Insert statements for procedure here
	SELECT CostCD, CostName,
	Case 
	when Accounting = 1 then '品番直接費'
	when Accounting = 2 then 'ブランド+シーズン'
	when Accounting = 3 then 'プロジェクト'
	when Accounting = 4 then '金型配賦'
	Else '自由項目'
	End As Accounting,
	Case 
	when Allocation = 0 then '直接'
	when Allocation = 1 then '総金額比'
	when Allocation = 2 then '生産数比'
	else '固定値比'
	End As Allocation
	FROM M_Keihi

	
	where CostCD = case when @CostCD is null then CostCD else @CostCD end
	and (@CostName is null or(CostName LIKE '%' + @CostName + '%'))
	ORDER BY CostCD	
END

