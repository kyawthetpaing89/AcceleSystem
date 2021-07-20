 BEGIN TRY 
 Drop Procedure dbo.[M_Project_Select_Entry]
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
CREATE PROCEDURE [dbo].[M_Project_Select_Entry] 
	-- Add the parameters for the stored procedure here
	@ProjectCD as varchar(15)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--declare @sdate as numeric,@edate as numeric;
	--	set @sdate = (select PeriodStart from M_Project where ProjectCD = @ProjectCD )
	--	set @edate = (select PeriodEnd from M_Project where ProjectCD = @ProjectCD )

	SELECT 
	prj.ProjectCD As [ProjectCD],
	prj.ProjectName As [ProjectName],
	Case when prj.[Year] = 0 OR prj.[Year] IS NULL Then '' Else CAST (prj.[Year] As varchar(4)) End As [Year],
	prj.BrandCD As [BrandCD],
	brand.BrandName As [BrandName],
	prj.Season As [Season],
	CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodStart)) + '01', 101),'-','/')) As [PeriodStart],
	CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodEnd)) + '01', 101),'-','/')) As [PeriodEnd],
	Case when hin.Production IS NULL then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,hin.Production), 1), '.00', '') End As [Production],
	Case when hin.SalesPrice IS NULL then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,hin.SalesPrice), 1), '.00', '') End As [SalesPrice],
	prj.ProjectManager As [ProjectManager],
	u.UserName As [ProjectManagerName],
	prj.AllocationCount As [AllocationCount]
	FROM M_Project prj 
	LEFT OUTER JOIN [M_Brand] [brand] on [brand].BrandCD = [prj].BrandCD
	LEFT OUTER JOIN [M_User] [u] on [u].ID= [prj].ProjectManager
	LEFT OUTER JOIN (
		select ProjectCD,sum(Production) as Production,sum(CONVERT(bigint,Production) * CONVERT(money,SalesPrice)) as SalesPrice from M_Hinban
		group by ProjectCD
	) [hin] on [hin].ProjectCD= [prj].ProjectCD
	WHERE (@ProjectCD is null or (prj.ProjectCD = @ProjectCD))
	ORDER BY ProjectCD DESC
	
		
END
