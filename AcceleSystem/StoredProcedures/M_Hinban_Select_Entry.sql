 BEGIN TRY 
 Drop Procedure dbo.[M_Hinban_Select_Entry]
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
CREATE PROCEDURE [dbo].[M_Hinban_Select_Entry]
	-- Add the parameters for the stored procedure here
	@ProjectCD as  varchar(15 ),
	@HinbanCD as varchar(6) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	select 
			prj.ProjectCD As [ProjectCD],
			prj.ProjectName As [ProjectName],
			Case 
			when prj.Season = 1 then '通年'
			when prj.Season = 2 then 'SS'
			Else 'FW' End As [Season],
			prj.[Year] As [Year],
			prj.BrandCD,
			br.BrandName As [BrandName],
			CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodStart)) + '01', 101),'-','/')) As [PeriodStart],
			CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodEnd)) + '01', 101),'-','/')) As [PeriodEnd],
			Case
				When hin1.TotalProduction IS NULL Then '0' 
				ELSE REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin1.TotalProduction), 1), '.00', '') 
			End as 'TotalProduction',
			hin.HinbanCD ,
			hin.HinbanName ,
			hin.Color,
			Case 
				When hin.Production IS NULL Then '0'
				ELSE REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin.Production), 1), '.00', '') 
			End as 'Production',
			Case	
				When hin.SalesPrice IS NULL Then '0'
				ELSE REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin.SalesPrice), 1), '.00', '') 
			End	as 'SalesPrice',
			Case	
				When CONVERT(bigint,hin.Production) * CONVERT(money,hin.SalesPrice) IS NULL THen '0'
				ELSE REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, CONVERT(bigint,hin.Production) * CONVERT(money,hin.SalesPrice)), 1), '.00', '') 
			End AS 'SP',
			Case 
				When hin1.TotalSP IS NULL Then '0'
				ELSE REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin1.TotalSP), 1), '.00', '')
			End as 'TotalSP',
			Case
				When d.TotalDeliveryAmount IS NULL Then '0'
				ELSE REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, d.TotalDeliveryAmount), 1), '.00', '') 
			End as 'TotalDeliveryAmount',
		    ca.CastingCD ,
			ca.CastingName ,
			hin.FreeItem1 ,
			hin.FreeItem2
	FROM M_Hinban hin
	LEFT OUTER JOIN M_Project prj on prj.ProjectCD = hin.ProjectCD
	LEFT OUTER JOIN M_Brand br on br.BrandCD = prj.BrandCD
	LEFT OUTER JOIN M_Casting ca on ca.CastingCD = hin.Casting
	left outer join 
		( select ProjectCD, SUM(Production) AS [TotalProduction], SUM(CONVERT(money,SalesPrice) * CONVERT(bigint,Production)) AS [TotalSP]
				from M_Hinban 
				GROUP BY ProjectCD
		) AS hin1 on hin.ProjectCD = hin1.ProjectCD 
	left outer join 
		( select ProjectCD,HinbanCD,SUM(DeliveryAmount) AS [TotalDeliveryAmount]
				from D_Delivery
				GROUP BY ProjectCD,HinbanCD
		) AS d on hin.ProjectCD = d.ProjectCD and hin.HinbanCD = d.HinbanCD
	WHERE hin.HinbanCD = @HinbanCD
	AND prj.ProjectCD = @ProjectCD
	--IF(@HinbanCD = '')
	--BEGIN
	--	SELECT 
	--		prj.ProjectCD As [ProjectCD],
	--		prj.ProjectName As [ProjectName],
	--		prj.Season As [Season],
	--		prj.[Year] As [Year],
	--		prj.BrandCD,
	--		brand.BrandName As [BrandName],
	--		--CONVERT(varchar,prj.PeriodStart) As [PeriodStart],
	--		--CONVERT(varchar,PeriodEnd) As [PeriodEnd],

	--		CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodStart)) + '01', 101),'-','/')) As [PeriodStart],
	--		CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodEnd)) + '01', 101),'-','/')) As [PeriodEnd],

	--		REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin.Production), 1), '.00', '')  as 'Production',
	--		REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin.SalesPrice), 1), '.00', '')  as 'SalesPrice',
	--		REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin.TotalProduction), 1), '.00', '')  as 'TotalProduction',
	--		REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin.TotalSalesPrice), 1), '.00', '')  as 'TotalSalesPrice',
	--		hin.HinbanCD ,
	--		hin.HinbanName ,
	--		REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, dd.DeliveryAmount), 1), '.00', '')  as 'DeliveryAmount',
	--	    mc.CastingCD ,
	--		mc.CastingName ,
	--		hin.Color,
	--		hin.FreeItem1 ,
	--		hin.FreeItem2
		
	--FROM  M_Project prj 
	--LEFT OUTER JOIN [M_Brand] [brand] on [brand].BrandCD = [prj].BrandCD
	--LEFT OUTER JOIN 
	--(
	--	select ProjectCD,HinbanCD, HinbanName ,sum(Production) as TotalProduction,sum(Production * SalesPrice) as TotalSalesPrice,Casting,FreeItem1 , FreeItem2,
	--	Color , Production, SalesPrice   from M_Hinban
	--	group by ProjectCD,HinbanCD,HinbanName,Casting,FreeItem1 , FreeItem2 , Color , Production, SalesPrice  
	--)[hin] on [hin].ProjectCD= [prj].ProjectCD
	--LEFT OUTER JOIN 
	--(
	--    select  SUM(DeliveryAmount) AS [DeliveryAmount], ProjectCD,HinbanCD   from D_Delivery 
	--	group by ProjectCD ,HinbanCD 
	--)dd on dd.ProjectCD = [prj].ProjectCD 
	--LEFT OUTER JOIN [M_Casting]  [mc] on [mc].CastingCD  = [hin].Casting 
	--where   [hin].HinbanCD = @HinbanCD and [hin].ProjectCD = @ProjectCD 
	--END
	--ELSE
	--BEGIN
	--	SELECT 
	--		prj.ProjectCD As [ProjectCD],
	--		prj.ProjectName As [ProjectName],
	--		prj.Season As [Season],
	--		prj.[Year] As [Year],
	--		prj.BrandCD,
	--		brand.BrandName As [BrandName],
	--		--CONVERT(varchar,prj.PeriodStart) As [PeriodStart],
	--		--CONVERT(varchar,PeriodEnd) As [PeriodEnd],
	--		CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodStart)) + '01', 101),'-','/')) As [PeriodStart],
	--		CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodEnd)) + '01', 101),'-','/')) As [PeriodEnd],
	--	    REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin.Production), 1), '.00', '')  as 'Production',
	--		REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin.SalesPrice), 1), '.00', '')  as 'SalesPrice',
	--		REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin.TotalProduction), 1), '.00', '')  as 'TotalProduction',
	--		REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin.TotalSalesPrice), 1), '.00', '')  as 'TotalSalesPrice',
	--		hin.HinbanCD ,
	--		hin.HinbanName ,
	--		REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, dd.DeliveryAmount), 1), '.00', '')  as 'DeliveryAmount',
	--	    mc.CastingCD ,
	--		mc.CastingName ,
	--		hin.Color,
	--		hin.FreeItem1 ,
	--		hin.FreeItem2
		
	--FROM  M_Project prj 
	--LEFT OUTER JOIN [M_Brand] [brand] on [brand].BrandCD = [prj].BrandCD
	--LEFT OUTER JOIN 
	--(
	--	select ProjectCD,HinbanCD, HinbanName ,sum(Production) as TotalProduction,sum(Production * SalesPrice) as TotalSalesPrice,Casting,FreeItem1 , FreeItem2,
	--	Color , Production, SalesPrice   from M_Hinban
	--	group by ProjectCD,HinbanCD,HinbanName,Casting,FreeItem1 , FreeItem2 , Color , Production, SalesPrice  
	--)[hin] on [hin].ProjectCD= [prj].ProjectCD
	--LEFT OUTER JOIN 
	--(
	--    select  SUM(DeliveryAmount) AS [DeliveryAmount], ProjectCD,HinbanCD   from D_Delivery 
	--	group by ProjectCD ,HinbanCD 
	--)dd on dd.ProjectCD = [prj].ProjectCD 
	--LEFT OUTER JOIN [M_Casting]  [mc] on [mc].CastingCD  = [hin].Casting 
	--where   [hin].HinbanCD = @HinbanCD and [hin].ProjectCD = @ProjectCD 
	--END

	
	END

