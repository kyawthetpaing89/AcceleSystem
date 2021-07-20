 BEGIN TRY 
 Drop Procedure dbo.[M_Project_Select_List]
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
CREATE PROCEDURE [dbo].[M_Project_Select_List] 
	-- Add the parameters for the stored procedure here
	@BrandCD as varchar(6),
	@BrandName as varchar(40),
	@Season as varchar(5),
	@Year as int,
	@ProjectCD as varchar(15),
	@ProjectName as varchar(60),
	@PeriodStart as int,
	@PeriodEnd as int,
	@ProjectManager as varchar(20),
	@ProjectManagerName as varchar(40)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	Case when prj.BrandCD IS NULL THen '' Else prj.BrandCD End As BrandCD,
	Case When brand.BrandName IS NULL Then '' Else brand.BrandName End As [BrandName],
	Case 
		when prj.Season = 1 then '通年'
		when prj.Season = 2 then 'SS'
		Else 'FW' End As [Season],
	Case when prj.[Year] = 0 OR prj.[Year] IS NULL Then '' Else CAST (prj.[Year] As varchar(4)) End As [Year],
	Case when prj.ProjectCD IS NULL THen '' Else prj.ProjectCD End As [ProjectCD],
	Case When prj.ProjectName  IS NULL Then '' Else prj.ProjectName End As [ProjectName],
	CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodStart)) + '01', 101),'-','/')) + '~' +
	CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodEnd)) + '01', 101),'-','/')) As [PeriodStart],
	Case when hin.Production IS NULL then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,hin.Production), 1), '.00', '') End As [Production],
	Case when hin.SalesPrice IS NULL then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,hin.SalesPrice), 1), '.00', '')  End As [SalesPrice]
	--'999,999,999'  As [Production],
	--'999,999,999'  As SalesPrice
	FROM M_Project prj 
	LEFT OUTER JOIN [M_Brand] [brand] on [brand].BrandCD = [prj].BrandCD
	LEFT OUTER JOIN [M_User] [u] on [u].ID= [prj].ProjectManager
	left outer JOIN 
	(
		select ProjectCD,sum(Production) as Production,sum(CONVERT(bigint,Production) * CONVERT(money,SalesPrice)) as SalesPrice from M_Hinban
		group by ProjectCD
	)[hin] on [hin].ProjectCD= [prj].ProjectCD
	WHERE(@BrandCD is null or(prj.BrandCD = @BrandCD))
	and (@BrandName is null or(brand.BrandName LIKE '%' + @BrandName + '%'))
	and (@Season is null or (prj.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1))))
	and (@Year is null or (prj.[Year] = @Year))
	and (@ProjectCD is null or (prj.ProjectCD = @ProjectCD))
	and (@ProjectName is null or(prj.ProjectName LIKE '%' + @ProjectName + '%'))
	and ((@PeriodStart is null or prj.PeriodStart <= @PeriodEnd) AND (@PeriodEnd is null or prj.PeriodEnd >= @PeriodStart))
	--and (@PeriodStart is null or(prj.PeriodStart >= @PeriodStart))
	--and (@PeriodEnd is null or(prj.PeriodEnd <= @PeriodEnd))
	and (@ProjectManager is null or(prj.ProjectManager = @ProjectManager))
	and (@ProjectManagerName is null or(u.UserName LIKE '%' + @ProjectManagerName + '%'))
	ORDER BY prj.BrandCD, prj.Season, prj.[Year], prj.ProjectCD DESC
	
END


