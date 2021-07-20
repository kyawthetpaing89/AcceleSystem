 BEGIN TRY 
 Drop Procedure dbo.[M_HinBan_Search_Search]
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
CREATE PROCEDURE [dbo].[M_HinBan_Search_Search]  
	-- Add the parameters for the stored procedure here
	@ProjectCD as varchar(15),
	@ProjectName as varchar(60),
	@Year as int,
	@Season as varchar(5),
	@BrandCD as varchar(6),
	@BrandName as varchar(40),
	@PeriodStart as int,
	@PeriodEnd as int,
	@HinbanCD as varchar(6),
	@HinbanName as varchar(40),
	@CastingCD as varchar(10),
	@CastingName as varchar(20),
	@StartPrice as int,
	@EndPrice as int,
	@CompleteYM as varchar(3)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 --    Insert statements for procedure here
 IF(@CompleteYM = '0') 
	begin
		select 
		Case when p.ProjectCD IS NULL Then '' Else p.ProjectCD End AS ProjectCD,
		Case when p.ProjectName IS NULL Then '' Else p.ProjectName End As ProjectName,
		Case when H.HinbanCD IS NULL Then '' Else H.HinbanCD End AS HinbanCD,
		Case when H.HinbanName IS NULL Then '' Else H.HinbanName End AS HinbanName,
		Case when H.Casting IS NULL Then '' Else H.Casting End AS Casting,
		Case when c.CastingName IS NULL Then '' Else c.CastingName End As CastingName,
		Case when H.Production IS NULL Then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, H.Production), 1), '.00', '') End as 'Production',
		Case When H.SalesPrice IS NULL Then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, H.SalesPrice), 1), '.00', '') End as 'SalesPrice',
		Case When h1.TotalSalePrice IS NULL Then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, h1.TotalSalePrice), 1), '.00', '')End as 'TotalSalesPrice',
		H.CompleteYM  AS CompleteYM
		from
		M_Project p
		Inner join M_Hinban h on p.ProjectCD = h.ProjectCD
		Left outer join M_Casting c on c.CastingCD = h.Casting
		left outer join M_Brand b on b.BrandCD = p.BrandCD
		left outer join (
		select ProjectCD,HinbanCD,SUM(CONVERT(money,SalesPrice)*CONVERT(bigint,Production)) AS TotalSalePrice, SUM(Production) as TotalProduction
		from M_Hinban GROUP BY ProjectCD,HinbanCD
		) as h1 on h1.ProjectCD = h.ProjectCD and h1.HinbanCD = h.HinbanCD
		where (@ProjectCD is null or(p.ProjectCD  = @ProjectCD ))
		and (@ProjectName is null or(p.ProjectName LIKE '%' + @ProjectName + '%'))
		and (@Year is null or(p.[Year] = @Year))
		and (@Season is null or (p.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1))))
		and (@BrandCD is null or (b.BrandCD = @BrandCD))
		and (@BrandName is null or (b.BrandName LIKE '%' + @BrandName + '%'))
		and (@PeriodStart is null or (p.PeriodStart = @PeriodStart))
		and (@PeriodEnd is null or (p.PeriodEnd = @PeriodEnd))
		and (@HinbanCD is null or(H.HinbanCD = @HinbanCD ))
		and (@HinbanName is null or(H.HinbanName  LIKE '%' + @HinbanName + '%'))
		and (@StartPrice is null or(H.SalesPrice >= @StartPrice))
		and (@EndPrice is null or(H.SalesPrice <= @EndPrice))
		and (@CastingCD is null or(H.Casting = @CastingCD))
		and (@CastingName is null or(c.CastingName  LIKE '%' + @CastingName + '%'))
		and H.CompleteYM = 0
		ORDER BY p.ProjectCD, H.HinbanCD
	End
	ELSE IF(@CompleteYM = '1')
	begin 
		select 
		Case when p.ProjectCD IS NULL Then '' Else p.ProjectCD End AS ProjectCD,
		Case when p.ProjectName IS NULL Then '' Else p.ProjectName End As ProjectName,
		Case when H.HinbanCD IS NULL Then '' Else H.HinbanCD End AS HinbanCD,
		Case when H.HinbanName IS NULL Then '' Else H.HinbanName End AS HinbanName,
		Case when H.Casting IS NULL Then '' Else H.Casting End AS Casting,
		Case when c.CastingName IS NULL Then '' Else c.CastingName End As CastingName,
		Case when H.Production IS NULL Then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, H.Production), 1), '.00', '') End as 'Production',
		Case When H.SalesPrice IS NULL Then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, H.SalesPrice), 1), '.00', '') End as 'SalesPrice',
		Case When h1.TotalSalePrice IS NULL Then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, h1.TotalSalePrice), 1), '.00', '')End as 'TotalSalesPrice',
		H.CompleteYM  AS CompleteYM
		from
		M_Project p
		Inner join M_Hinban h on p.ProjectCD = h.ProjectCD
		Left outer join M_Casting c on c.CastingCD = h.Casting
		left outer join M_Brand b on b.BrandCD = p.BrandCD
		left outer join (
		select ProjectCD,HinbanCD,SUM(SalesPrice*Production) AS TotalSalePrice, SUM(Production) as TotalProduction
		from M_Hinban GROUP BY ProjectCD,HinbanCD
		) as h1 on h1.ProjectCD = h.ProjectCD and h1.HinbanCD = h.HinbanCD
		where (@ProjectCD is null or(p.ProjectCD  = @ProjectCD ))
		and (@ProjectName is null or(p.ProjectName LIKE '%' + @ProjectName + '%'))
		and (@Year is null or(p.[Year] = @Year))
		and (@Season is null or (p.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1))))
		and (@BrandCD is null or (b.BrandCD = @BrandCD))
		and (@BrandName is null or (b.BrandName LIKE '%' + @BrandName + '%'))
		and (@PeriodStart is null or (p.PeriodStart = @PeriodStart))
		and (@PeriodEnd is null or (p.PeriodEnd = @PeriodEnd))
		and (@HinbanCD is null or(H.HinbanCD = @HinbanCD ))
		and (@HinbanName is null or(H.HinbanName  LIKE '%' + @HinbanName + '%'))
		and (@StartPrice is null or(H.SalesPrice >= @StartPrice))
		and (@EndPrice is null or(H.SalesPrice <= @EndPrice))
		and (@CastingCD is null or(H.Casting = @CastingCD))
		and (@CastingName is null or(c.CastingName  LIKE '%' + @CastingName + '%'))
		and H.CompleteYM <> 0
		ORDER BY p.ProjectCD, H.HinbanCD
	End
	ELSE 
	begin 
		select 
		Case when p.ProjectCD IS NULL Then '' Else p.ProjectCD End AS ProjectCD,
		Case when p.ProjectName IS NULL Then '' Else p.ProjectName End As ProjectName,
		Case when H.HinbanCD IS NULL Then '' Else H.HinbanCD End AS HinbanCD,
		Case when H.HinbanName IS NULL Then '' Else H.HinbanName End AS HinbanName,
		Case when H.Casting IS NULL Then '' Else H.Casting End AS Casting,
		Case when c.CastingName IS NULL Then '' Else c.CastingName End As CastingName,
		Case when H.Production IS NULL Then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, H.Production), 1), '.00', '') End as 'Production',
		Case When H.SalesPrice IS NULL Then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, H.SalesPrice), 1), '.00', '') End as 'SalesPrice',
		Case When h1.TotalSalePrice IS NULL Then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, h1.TotalSalePrice), 1), '.00', '')End as 'TotalSalesPrice',
		H.CompleteYM  AS CompleteYM
		from
		M_Project p
		Inner join M_Hinban h on p.ProjectCD = h.ProjectCD
		Left outer join M_Casting c on c.CastingCD = h.Casting
		left outer join M_Brand b on b.BrandCD = p.BrandCD
		left outer join (
		select ProjectCD,HinbanCD,SUM(CONVERT(money,SalesPrice)*CONVERT(bigint,Production)) AS TotalSalePrice, SUM(Production) as TotalProduction
		from M_Hinban GROUP BY ProjectCD,HinbanCD
		) as h1 on h1.ProjectCD = h.ProjectCD and h1.HinbanCD = h.HinbanCD
		where (@ProjectCD is null or(p.ProjectCD  = @ProjectCD ))
		and (@ProjectName is null or(p.ProjectName LIKE '%' + @ProjectName + '%'))
		and (@Year is null or(p.[Year] = @Year))
		and (@Season is null or (p.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1))))
		and (@BrandCD is null or (b.BrandCD = @BrandCD))
		and (@BrandName is null or (b.BrandName LIKE '%' + @BrandName + '%'))
		and (@PeriodStart is null or (p.PeriodStart = @PeriodStart))
		and (@PeriodEnd is null or (p.PeriodEnd = @PeriodEnd))
		and (@HinbanCD is null or(H.HinbanCD = @HinbanCD ))
		and (@HinbanName is null or(H.HinbanName  LIKE '%' + @HinbanName + '%'))
		and (@StartPrice is null or(H.SalesPrice >= @StartPrice))
		and (@EndPrice is null or(H.SalesPrice <= @EndPrice))
		and (@CastingCD is null or(H.Casting = @CastingCD))
		and (@CastingName is null or(c.CastingName  LIKE '%' + @CastingName + '%'))
			--and H.CompleteYM IS NOT NULL
			ORDER BY p.ProjectCD, H.HinbanCD
	End
END
