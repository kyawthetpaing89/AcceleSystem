 BEGIN TRY 
 Drop Procedure dbo.[M_Project_CSV]
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
CREATE PROCEDURE [dbo].[M_Project_CSV]
	-- Add the parameters for the stored procedure here
	@BrandCD as varchar(6),
	@BrandName as varchar(40),
	@Season as varchar(5),
	@Year as int,
	@ProjectCD as varchar(15),
	@ProjectName as varchar(120),
	@PeriodStart as int,
	@PeriodEnd as int,
	@ProjectManager as varchar(20),
	@UserName as varchar(40)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		 Case When prj.ProjectCD IS NULL Then '' ELSE prj.ProjectCD End AS 'プロジェクトコード',
		 Case When prj.ProjectName IS NULL Then '' ELSE prj.ProjectName End AS 'プロジェクト名',
		 Case When prj.[Year] = 0 OR prj.[Year] IS NULL Then '' ELSE CAST (prj.[Year] As varchar(4)) End AS '年度',
		 Case When prj.BrandCD IS NULL Then '' ELSE prj.BrandCD End AS 'ブランドコード',
		 Case When br.BrandName IS NULL Then '' ELSE br.BrandName End AS 'ブランドコード',
		 Case 
			when prj.Season IS NULL Then ''
			when prj.Season = 1 then '通年'
			when prj.Season = 2 then 'SS'
			Else 'FW' End As  'シーズン'
		,CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodStart)) + '01', 101),'-','/')) AS '予定期間　開始'
		,CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodEnd)) + '01', 101),'-','/')) AS '予定期間　終了'
		,Case when hin1.Production IS NULL  Then '0' 
			Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin1.Production), 1), '.00', '')
			End AS '総生産数'
		,Case when hin1.SP IS NULL Then '0' 
			Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin1.SP), 1), '.00', '')
			End AS '総金額',
		Case When prj.ProjectManager IS NULL Then '' ELSE prj.ProjectManager End AS '責任者コード',
		Case When us.UserName IS NULL Then '' ELSE us.UserName End AS '責任者名',
		Case When prj.AllocationCount IS NULL  Then '' ELSE prj.AllocationCount End AS '配賦用固定値',
		Case When hin.HinbanCD IS NULL Then '' ELSE hin.HinbanCD End AS '品番コード',
		Case When hin.HinbanName IS NULL Then '' ELSE hin.HinbanName End AS '品番名',
		Case When hin.Color IS NULL Then '' ELSE hin.Color End AS '色数',
		Case When hin.Production IS NULL Then '' ELSE hin.Production End AS '生産数',
		Case When del.DeliveryAmount IS NULL Then '' ELSE del.DeliveryAmount End AS '累計納品数',
		Case When hin.SalesPrice IS NULL Then '' ELSE hin.SalesPrice End AS '予定単価',
		Case when hin1.SP IS NULL Then '0' 
			Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin1.SP), 1), '.00', '') 
			End AS '総金額',
		Case When hin.Casting IS NULL Then '' ELSE hin.Casting End AS '金型コード',
		Case When ca.CastingName IS NULL Then '' ELSE ca.CastingName End AS '金型名',
		Case When hin.FreeItem1 IS NULL Then '' ELSE hin.FreeItem1 End AS '自由配賦項目',
		Case When hin.FreeItem2 IS NULL Then '' ELSE hin.FreeItem2 End As '配賦用固定値'
	from M_Project prj
	left outer join M_Hinban hin on prj.ProjectCD = hin.ProjectCD
	left outer join M_Brand br on prj.BrandCD = br.BrandCD
	left outer join M_User us on prj.ProjectManager = us.ID
	left outer join (
		  SELECT 
			ProjectCD,
			HinbanCD,
			SUM(DeliveryAmount) AS DeliveryAmount
		  FROM  D_Delivery
		  Group By ProjectCD,HinbanCD) AS del on del.ProjectCD = prj.ProjectCD and del.HinbanCD = hin.HinbanCD 
	LEFT OUTER JOIN (
			SELECT 
			 ProjectCD,
			 HinbanCD,
			 SUM(Production) AS Production,
			 SUM(SalesPrice * Production) AS SP
			FROM M_Hinban
			GROUP BY ProjectCD,HinbanCD) AS hin1 on hin1.HinbanCD = hin.HinbanCD and hin1.ProjectCD = hin.ProjectCD
	left outer join M_Casting ca on hin.Casting = ca.CastingCD
	WHERE(@BrandCD is null or(prj.BrandCD = @BrandCD))
		and (@BrandName is null or(br.BrandName LIKE '%' + @BrandName + '%'))
		and (@Season is null or (prj.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1))))
		and (@Year is null or (prj.[Year] = @Year))
		and (@ProjectCD is null or (prj.ProjectCD = @ProjectCD))
		and (@ProjectName is null or(prj.ProjectName LIKE '%' + @ProjectName + '%'))
		and (@PeriodStart is null or(prj.PeriodStart >= @PeriodStart))
		and (@PeriodEnd is null or(prj.PeriodEnd <= @PeriodEnd))
		and (@ProjectManager is null or(prj.ProjectManager = @ProjectManager))
		and (@UserName is null or(us.UserName LIKE '%' + @UserName + '%'))
		ORDER BY prj.ProjectCD, hin.HinbanCD DESC
END
