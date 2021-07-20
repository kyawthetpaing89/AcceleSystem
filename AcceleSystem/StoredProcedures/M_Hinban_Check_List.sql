 BEGIN TRY 
 Drop Procedure dbo.[M_Hinban_Check_List]
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
CREATE PROCEDURE [dbo].[M_Hinban_Check_List]
	-- Add the parameters for the stored procedure here
	@ProjectCD as  varchar(15) 
--@HinbanCD as varchar(20) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select prj.ProjectCD,
		prj.ProjectName,
		Case 
			when prj.Season = 1 then '通年'
			when prj.Season = 2 then 'SS'
		Else 'FW' End As [Season],
		prj.[Year],
		CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodStart)) + '01', 101),'-','/')) As [PeriodStart],
		CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), prj.PeriodEnd)) + '01', 101),'-','/')) As [PeriodEnd],
		prj.BrandCD,
		mb.BrandName,
		Case 
			When hin.TotalProduction IS NULL Then '0'
			ELSE REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin.TotalProduction), 1), '.00', '') 
		End as [TotalProduction],
		Case 
			when hin.TotalSP IS NULL Then '0'
			ELSE REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, hin.TotalSP), 1), '.00', '')  
		End as TotalSP,
		Case 
			When d.TotalDeliveryAmount IS NULL Then '0'
			ELSE REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, d.TotalDeliveryAmount), 1), '.00', '')  
		End as [TotalDeliveryAmount]
		
	FROM
	M_Project prj
	left outer join M_Brand mb on mb.BrandCD = prj.BrandCD
	left outer join 
	( select ProjectCD, SUM(Production) AS [TotalProduction], SUM(CONVERT(money,SalesPrice) * CONVERT(bigint,Production)) AS [TotalSP]
			from M_Hinban 
			GROUP BY ProjectCD
	) AS hin on prj.ProjectCD = hin.ProjectCD 
	left outer join 
	( select ProjectCD, SUM(DeliveryAmount) AS [TotalDeliveryAmount]
			from D_Delivery
			GROUP BY ProjectCD
	) AS d on prj.ProjectCD = d.ProjectCD 
	WHERE prj.ProjectCD = @ProjectCD


	--select p.ProjectCD,
	--	p.ProjectName,
	--	p.Season,
	--	p.Year,
	--	CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), p.PeriodStart)) + '01', 101),'-','/')) As [PeriodStart],
	--	CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), p.PeriodEnd)) + '01', 101),'-','/')) As [PeriodEnd],
	--	p.BrandCD,
	--	mb.BrandName,
	--	REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, h1.TotalProduction), 1), '.00', '')  as 'TotalProduction',
	--	REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, h1.TotalSalePrice), 1), '.00', '')  as 'TotalSalesPrice',
	--	REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, dd.DeliveryAmount), 1), '.00', '')  as 'DeliveryAmount'
	--from
	--M_Hinban H
	--Left outer join M_Project p on p.ProjectCD = h.ProjectCD
	--left outer join M_Brand mb on mb.BrandCD = p.BrandCD
	--left outer join (
	--	select ProjectCD,SUM(SalesPrice*Production) AS TotalSalePrice, SUM(Production) as TotalProduction
	--	from M_Hinban GROUP BY ProjectCD
	--) as h1 on h1.ProjectCD = h.ProjectCD
	
	--left outer join 
	--(
	--	select ProjectCD,SUM(DeliveryAmount) as DeliveryAmount from D_Delivery Group by ProjectCD
	--)as dd on dd.ProjectCD = h.ProjectCD
	--where p.ProjectCD = @ProjectCD
	--group by p.ProjectCD,p.ProjectName,p.Season,p.Year,p.PeriodStart,p.PeriodEnd, h1.TotalSalePrice,h1.TotalProduction,p.BrandCD,
	--mb.BrandName,dd.DeliveryAmount

	END

