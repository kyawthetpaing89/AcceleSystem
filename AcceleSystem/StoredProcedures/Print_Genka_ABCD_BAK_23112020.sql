 BEGIN TRY 
 Drop Procedure dbo.[Print_Genka_ABCD_BAK_23112020]
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
CREATE PROCEDURE [dbo].[Print_Genka_ABCD_BAK_23112020]
	-- Add the parameters for the stored procedure here
	@targetyear		int,
	@BrandCD		varchar(10),
	@BrandName		varchar(40),
	@Season			varchar(5),
	@ProjectCD		varchar(10),
	@ProjectName	varchar (60),
	@DeliveryStatus int,
	@type			nvarchar(3),
	@LoginID		varchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	
	SET ANSI_WARNINGS OFF;
	
	declare @d_Amount int, @SQL nvarchar(max);

	if @type = 'A10'
	begin
		SELECT '金型費' as BrandCD, i.CastingCD, mcast.CastingName, i.CostCD, keihi.CostName,
		(SELECT isnull(Cost, 0) from D_TotalIndirectCost ti1 WHERE ti1.Accounting = 4 AND ti1.YYYYMM = (SELECT Max(ti2.YYYYMM) from D_TotalIndirectCost ti2 WHERE ti2.Accounting = 4 and LEFT(ti2.YYYYMM, 4) < @targetyear)) as CostPre,
			--case when ti.Accounting = 4 and LEFT(ti.YYYYMM, 4) - 1 < @targetyear then 
			--	(SELECT SUM(ti1.Cost) from D_TotalIndirectCost ti1 WHERE ti1.Accounting = 4 AND LEFT(ti1.YYYYMM, 4) = 2019) else 0 end CostPre,
			case when ti.Accounting = 4 and ti.YYYYMM = cast(@targetyear as varchar) + '01' then i.Cost else 0 end Cost1,
			case when ti.Accounting = 4 and ti.YYYYMM = cast(@targetyear as varchar) + '02' then i.Cost else 0 end Cost2,
			case when ti.Accounting = 4 and ti.YYYYMM = cast(@targetyear as varchar) + '03' then i.Cost else 0 end Cost3,
			case when ti.Accounting = 4 and ti.YYYYMM = cast(@targetyear as varchar) + '04' then i.Cost else 0 end Cost4,
			case when ti.Accounting = 4 and ti.YYYYMM = cast(@targetyear as varchar) + '05' then i.Cost else 0 end Cost5,
			case when ti.Accounting = 4 and ti.YYYYMM = cast(@targetyear as varchar) + '06' then i.Cost else 0 end Cost6,
			case when ti.Accounting = 4 and ti.YYYYMM = cast(@targetyear as varchar) + '07' then i.Cost else 0 end Cost7,
			case when ti.Accounting = 4 and ti.YYYYMM = cast(@targetyear as varchar) + '08' then i.Cost else 0 end Cost8,
			case when ti.Accounting = 4 and ti.YYYYMM = cast(@targetyear as varchar) + '09' then i.Cost else 0 end Cost9,
			case when ti.Accounting = 4 and ti.YYYYMM = cast(@targetyear as varchar) + '10' then i.Cost else 0 end Cost10,
			case when ti.Accounting = 4 and ti.YYYYMM = cast(@targetyear as varchar) + '11' then i.Cost else 0 end Cost11,
			case when ti.Accounting = 4 and ti.YYYYMM = cast(@targetyear as varchar) + '12' then i.Cost else 0 end Cost12,
			0 as CostHaihu, 0 as CostShikakari, 10 as SortKey
		INTO #tempA
		FROM D_IndirectCost i
		INNER JOIN M_Casting mcast ON mcast.CastingCD = i.CastingCD
		INNER JOIN M_Keihi keihi ON keihi.CostCD = i.CostCD
		INNER JOIN D_TotalIndirectCost ti ON ti.YYYYMM = i.YYYYMM AND ti.CostCD = i.CostCD AND ti.CastingCD = i.CastingCD
		WHERE i.Accounting = 4 AND LEFT(i.YYYYMM, 4) = @targetyear
		ORDER BY CastingCD
				
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostShikakari, SortKey )
		select distinct t.BrandCD, t.CastingCD, t.CastingName, t.CostCD, t.CostName,
			(select max(t1.CostPre) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as CostPre,
			(select max(t1.Cost1) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as Cost1,
			(select max(t1.Cost2) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as Cost2,
			(select max(t1.Cost3) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as Cost3,
			(select max(t1.Cost4) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as Cost4,
			(select max(t1.Cost5) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as Cost5,
			(select max(t1.Cost6) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as Cost6,
			(select max(t1.Cost7) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as Cost7,
			(select max(t1.Cost8) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as Cost8,
			(select max(t1.Cost9) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as Cost9,
			(select max(t1.Cost10) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as Cost10,
			(select max(t1.Cost11) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as Cost11,
			(select max(t1.Cost12) from #tempA t1 where t1.CastingCD = t.CastingCD and t1.CostCD = t.CostCD) as Cost12,
			CostHaihu, CostShikakari, SortKey
		from #tempA t';
		EXEC (@SQL);

		drop table #tempA
	end

	else if @type = 'A11'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( CostName, CostPre, Cost1,Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostShikakari, SortKey)
					SELECT ''金型合計'', sum(CostPre), sum(Cost1), sum(Cost2), sum(Cost3), sum(Cost4), sum(Cost5), sum(Cost6), sum(Cost7), sum(Cost8), sum(Cost9), sum(Cost10), sum(Cost11), sum(Cost12), 0, 0, 11
					FROM WK_原価集計表_' + @LoginID +
					' WHERE SortKey = 10';
		EXEC (@SQL);
	end

	else if @type = 'B20'
	begin		
		SELECT i.BrandCD, brand.BrandName, i.Season, i.Year, i.CostCD, keihi.CostName,
		(SELECT isnull(Cost, 0) from D_TotalIndirectCost ti1 WHERE ti1.Accounting = 2 AND ti1.YYYYMM = (SELECT Max(ti2.YYYYMM) from D_TotalIndirectCost ti2 WHERE ti2.Accounting = 2 and LEFT(ti2.YYYYMM, 4) < @targetyear)) as CostPre,
			--case when ti.Accounting = 2 and LEFT(ti.YYYYMM, 4) - 1 < @targetyear then 
			--	(SELECT SUM(ti1.Cost) from D_TotalIndirectCost ti1 WHERE ti1.Accounting = 2 AND LEFT(ti1.YYYYMM, 4) = @targetyear - 1) else 0 end CostPre,
			case when ti.Accounting = 2 and ti.YYYYMM = cast(@targetyear as varchar) + '01' then i.Cost else 0 end Cost1,
			case when ti.Accounting = 2 and ti.YYYYMM = cast(@targetyear as varchar) + '02' then i.Cost else 0 end Cost2,
			case when ti.Accounting = 2 and ti.YYYYMM = cast(@targetyear as varchar) + '03' then i.Cost else 0 end Cost3,
			case when ti.Accounting = 2 and ti.YYYYMM = cast(@targetyear as varchar) + '04' then i.Cost else 0 end Cost4,
			case when ti.Accounting = 2 and ti.YYYYMM = cast(@targetyear as varchar) + '05' then i.Cost else 0 end Cost5,
			case when ti.Accounting = 2 and ti.YYYYMM = cast(@targetyear as varchar) + '06' then i.Cost else 0 end Cost6,
			case when ti.Accounting = 2 and ti.YYYYMM = cast(@targetyear as varchar) + '07' then i.Cost else 0 end Cost7,
			case when ti.Accounting = 2 and ti.YYYYMM = cast(@targetyear as varchar) + '08' then i.Cost else 0 end Cost8,
			case when ti.Accounting = 2 and ti.YYYYMM = cast(@targetyear as varchar) + '09' then i.Cost else 0 end Cost9,
			case when ti.Accounting = 2 and ti.YYYYMM = cast(@targetyear as varchar) + '10' then i.Cost else 0 end Cost10,
			case when ti.Accounting = 2 and ti.YYYYMM = cast(@targetyear as varchar) + '11' then i.Cost else 0 end Cost11,
			case when ti.Accounting = 2 and ti.YYYYMM = cast(@targetyear as varchar) + '12' then i.Cost else 0 end Cost12,
			0 as CostHaihu, 0 as CostShikakari, 20 as SortKey
		INTO #tempB
		FROM D_IndirectCost i
		INNER JOIN M_Keihi keihi ON keihi.CostCD = i.CostCD
		INNER JOIN M_Brand brand ON brand.BrandCD = i.BrandCD
		INNER JOIN D_TotalIndirectCost ti ON ti.YYYYMM = i.YYYYMM AND ti.CostCD = i.CostCD AND ti.CastingCD = i.CastingCD
		WHERE i.Accounting = 2 AND LEFT(i.YYYYMM, 4) = @targetyear AND 
			(ti.Accounting = 2 AND LEFT(ti.YYYYMM, 4) - 1 < @targetyear) AND
			i.BrandCD = @BrandCD AND brand.BrandName LIKE '%' + @BrandName + '%' AND
			(@Season is null or (i.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1))))
		ORDER BY i.BrandCD, i.Season, i.CostCD

		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostShikakari, SortKey )
				select distinct t.BrandCD, t.BrandName, t.Season, t.Year, t.CostCD, t.CostName,
					(select max(t1.CostPre) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as CostPre,
					(select max(t1.Cost1) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as Cost1,
					(select max(t1.Cost2) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as Cost2,
					(select max(t1.Cost3) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as Cost3,
					(select max(t1.Cost4) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as Cost4,
					(select max(t1.Cost5) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as Cost5,
					(select max(t1.Cost6) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as Cost6,
					(select max(t1.Cost7) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as Cost7,
					(select max(t1.Cost8) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as Cost8,
					(select max(t1.Cost9) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as Cost9,
					(select max(t1.Cost10) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as Cost10,
					(select max(t1.Cost11) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as Cost11,
					(select max(t1.Cost12) from #tempB t1 where t1.BrandCD = t.BrandCD and t1.CostCD = t.CostCD and t1.Season = t.Season) as Cost12,
					CostHaihu, CostShikakari, SortKey
				from #tempB t';
		EXEC (@SQL);

		drop table #tempB
	end

	else if @type = 'B21'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostShikakari, SortKey)		
					SELECT ''B/S合計(直接) '', sum(CostPre), sum(Cost1), sum(Cost2), sum(Cost3), sum(Cost4), sum(Cost5), sum(Cost6), sum(Cost7), sum(Cost8), sum(Cost9), sum(Cost10), sum(Cost11), sum(Cost12), 0, 0, 21
					FROM  WK_原価集計表_' + @LoginID +
					' WHERE SortKey = 20';
		EXEC (@SQL);
	end

	else if @type = 'C30'
	begin
		select @d_Amount = sum(isnull(d.DeliveryAmount, 0)) 			
		FROM D_IndirectCost i
		INNER JOIN M_Keihi keihi ON keihi.CostCD = i.CostCD
		INNER JOIN M_Brand brand ON brand.BrandCD = i.BrandCD
		INNER JOIN D_TotalIndirectCost ti ON ti.YYYYMM = i.YYYYMM AND ti.CostCD = i.CostCD AND ti.CastingCD = i.CastingCD 
		INNER JOIN M_Project project ON i.ProjectCD = project.ProjectCD
		INNER JOIN M_Hinban h ON project.ProjectCD = h.ProjectCD AND i.HinbanCD = h.HinbanCD
		INNER JOIN D_Delivery d ON h.ProjectCD = d.ProjectCD AND h.HinbanCD = d.HinbanCD
		WHERE i.Accounting = 3 AND LEFT(i.YYYYMM, 4) = @targetyear AND 
			(ti.Accounting = 3 AND LEFT(ti.YYYYMM, 4) - 1 < @targetyear) AND
			i.BrandCD = @BrandCD AND brand.BrandName LIKE '%' + @BrandName + '%' AND
			(@Season is null or (i.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1)))) AND
			project.ProjectCD = @ProjectCD AND project.ProjectName LIKE '%' + @ProjectName + '%'
			
		SELECT i.BrandCD, brand.BrandName, i.Season, i.Year, i.ProjectCD, project.ProjectName, project.PeriodStart, project.PeriodEnd, 
			sum(h.Production) as TotalValueSum, sum(h.SalesPrice * h.Production) as ProductionSum, i.CostCD, keihi.CostName,
			(SELECT isnull(Cost, 0) from D_TotalIndirectCost ti1 WHERE ti1.Accounting = 3 AND ti1.YYYYMM = (SELECT Max(ti2.YYYYMM) from D_TotalIndirectCost ti2 WHERE ti2.Accounting = 3 and LEFT(ti2.YYYYMM, 4) < @targetyear)) as CostPre,
			--case when ti.Accounting = 3 and LEFT(ti.YYYYMM, 4) - 1 < @targetyear then 
			--	(SELECT SUM(ti1.Cost) from D_TotalIndirectCost ti1 WHERE ti1.Accounting = 3 AND LEFT(ti1.YYYYMM, 4) = @targetyear - 1) else 0 end CostPre,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '01' then i.Cost else 0 end Cost1,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '02' then i.Cost else 0 end Cost2,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '03' then i.Cost else 0 end Cost3,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '04' then i.Cost else 0 end Cost4,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '05' then i.Cost else 0 end Cost5,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '06' then i.Cost else 0 end Cost6,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '07' then i.Cost else 0 end Cost7,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '08' then i.Cost else 0 end Cost8,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '09' then i.Cost else 0 end Cost9,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '10' then i.Cost else 0 end Cost10,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '11' then i.Cost else 0 end Cost11,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '12' then i.Cost else 0 end Cost12,
			0 as CostHaihu, 0 as CostShikakari, 30 as SortKey
		INTO #tempC
		FROM D_IndirectCost i
		INNER JOIN M_Keihi keihi ON keihi.CostCD = i.CostCD
		INNER JOIN M_Brand brand ON brand.BrandCD = i.BrandCD
		INNER JOIN D_TotalIndirectCost ti ON ti.YYYYMM = i.YYYYMM AND ti.CostCD = i.CostCD AND ti.CastingCD = i.CastingCD 
		INNER JOIN M_Project project ON i.ProjectCD = project.ProjectCD
		INNER JOIN M_Hinban h ON project.ProjectCD = h.ProjectCD AND i.HinbanCD = h.HinbanCD
		INNER JOIN D_Delivery d ON h.ProjectCD = d.ProjectCD AND h.HinbanCD = d.HinbanCD
		WHERE i.Accounting = 3 AND LEFT(i.YYYYMM, 4) = @targetyear AND 
			(ti.Accounting = 3 AND LEFT(ti.YYYYMM, 4) - 1 < @targetyear) AND
			i.BrandCD = @BrandCD AND brand.BrandName LIKE '%' + @BrandName + '%' AND
			(@Season is null or (i.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1)))) AND
			project.ProjectCD = @ProjectCD AND project.ProjectName LIKE '%' + @ProjectName + '%' AND 
			((@DeliveryStatus = 1 AND @d_Amount < h.Production) OR (@DeliveryStatus = 2 AND @d_Amount = h.Production))
		GROUP BY i.BrandCD, brand.BrandName, i.Season, i.Year, i.ProjectCD, project.ProjectName, project.PeriodStart, project.PeriodEnd, i.CostCD, keihi.CostName, ti.Accounting, ti.YYYYMM, ti.Cost, i.Cost
		ORDER BY i.BrandCD, i.Season, i.ProjectCD, i.CostCD

		select distinct BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, CostCD, CostName,
			(select max(t1.CostPre) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as CostPre,
			(select max(t1.Cost1) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost1,
			(select max(t1.Cost2) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost2,
			(select max(t1.Cost3) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost3,
			(select max(t1.Cost4) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost4,
			(select max(t1.Cost5) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost5,
			(select max(t1.Cost6) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost6,
			(select max(t1.Cost7) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost7,
			(select max(t1.Cost8) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost8,
			(select max(t1.Cost9) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost9,
			(select max(t1.Cost10) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost10,
			(select max(t1.Cost11) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost11,
			(select max(t1.Cost12) from #tempC t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost12,
			CostHaihu, CostShikakari, SortKey
		into #tempC30
		from #tempC t
		
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, CostCD, CostName, CostPre, 
						Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostShikakari, SortKey )
					SELECT BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, CostCD, CostName, CostPre,
						Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, 
						Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12 AS CostHaihu, CostShikakari, SortKey
					FROM #tempC30';
		EXEC (@SQL);

		DROP TABLE #tempC
		DROP TABLE #tempC30
	end

	else if @type = 'C32'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, SortKey)		
					SELECT ''プロジェクト経費計'', sum(isnull(CostPre, 0)), sum(isnull(Cost1, 0)), sum(isnull(Cost2, 0)), sum(isnull(Cost3, 0)), sum(isnull(Cost4, 0)), sum(isnull(Cost5, 0)), 
						sum(isnull(Cost6, 0)), sum(isnull(Cost7, 0)), sum(isnull(Cost8, 0)), sum(isnull(Cost9, 0)), sum(isnull(Cost10, 0)), sum(isnull(Cost11, 0)), sum(isnull(Cost12, 0)), 32
					FROM WK_原価集計表_ログインID
					WHERE SortKey = 30';
		EXEC (@SQL);
	end

	else if @type = 'D40'
	begin
		select @d_Amount = sum(de.DeliveryAmount)		
		FROM D_DirectCost d
		INNER JOIN M_Keihi keihi ON keihi.CostCD = d.CostCD
		INNER JOIN M_Project p ON d.ProjectCD = p.ProjectCD
		INNER JOIN M_Hinban h ON d.ProjectCD = h.ProjectCD AND d.HinbanCD = h.HinbanCD
		INNER JOIN M_Brand brand ON brand.BrandCD = p.BrandCD
		INNER JOIN D_TotalDirectCost td ON td.YYYY = substring(cast(d.YYYYMM as varchar), 1, 4) AND td.CostCD = d.CostCD
		INNER JOIN D_Delivery de ON h.ProjectCD = de.ProjectCD AND h.HinbanCD = de.HinbanCD
		INNER JOIN M_Casting c ON c.CastingCD = h.Casting
		WHERE LEFT(d.YYYYMM, 4) = @targetyear AND td.YYYY -1 < @targetyear AND p.BrandCD = @BrandCD AND
			brand.BrandName like '%' + @BrandName + '%' AND
			(@Season is null or (p.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1)))) AND p.ProjectCD = @ProjectCD AND p.ProjectName like '%' + @ProjectName + '%' AND
			((@DeliveryStatus = 1 AND @d_Amount < h.Production) OR (@DeliveryStatus = 2 AND @d_Amount = h.Production))

		SELECT p.BrandCD, brand.BrandName, p.Season, p.Year, d.ProjectCD, p.ProjectName, p.PeriodStart, p.PeriodEnd, sum(h.Production) as TotalValueSum, sum(h.SalesPrice * h.Production) as ProductionSum, 
			d.HinbanCD, h.HinbanName, h.Color, h.Production, h.Complete, h.SalesPrice, h.SalesPrice * h.Production as TotalValue, h.Casting, c.CastingName, d.CostCD, keihi.CostName,
			(SELECT isnull(Cost, 0) from D_TotalDirectCost ti1 WHERE ti1.YYYY = (SELECT Max(ti2.YYYY) from D_TotalDirectCost ti2 WHERE ti2.YYYY < @targetyear)) as CostPre,
			--case when td.YYYY - 1 < @targetyear then 
			--	(SELECT SUM(isnull(td1.Cost, 0)) from D_TotalDirectCost td1 WHERE td1.YYYY = @targetyear - 1) else 0 end CostPre,
			case when d.YYYYMM = cast(@targetyear as varchar) + '01' then d.Cost else null end Cost1,
			case when d.YYYYMM = cast(@targetyear as varchar) + '02' then d.Cost else null end Cost2,
			case when d.YYYYMM = cast(@targetyear as varchar) + '03' then d.Cost else null end Cost3,
			case when d.YYYYMM = cast(@targetyear as varchar) + '04' then d.Cost else null end Cost4,
			case when d.YYYYMM = cast(@targetyear as varchar) + '05' then d.Cost else null end Cost5,
			case when d.YYYYMM = cast(@targetyear as varchar) + '06' then d.Cost else null end Cost6,
			case when d.YYYYMM = cast(@targetyear as varchar) + '07' then d.Cost else null end Cost7,
			case when d.YYYYMM = cast(@targetyear as varchar) + '08' then d.Cost else null end Cost8,
			case when d.YYYYMM = cast(@targetyear as varchar) + '09' then d.Cost else null end Cost9,
			case when d.YYYYMM = cast(@targetyear as varchar) + '10' then d.Cost else null end Cost10,
			case when d.YYYYMM = cast(@targetyear as varchar) + '11' then d.Cost else null end Cost11,
			case when d.YYYYMM = cast(@targetyear as varchar) + '12' then d.Cost else null end Cost12,
			0 as CostHaihu, 0 as CostShikakari, 40 as SortKey
		INTO #tempD
		FROM D_DirectCost d
		INNER JOIN M_Keihi keihi ON keihi.CostCD = d.CostCD
		INNER JOIN M_Project p ON d.ProjectCD = p.ProjectCD
		INNER JOIN M_Hinban h ON d.ProjectCD = h.ProjectCD AND d.HinbanCD = h.HinbanCD
		INNER JOIN M_Brand brand ON brand.BrandCD = p.BrandCD
		INNER JOIN D_TotalDirectCost td ON td.YYYY = substring(cast(d.YYYYMM as varchar), 1, 4) AND td.CostCD = d.CostCD
		INNER JOIN D_Delivery de ON h.ProjectCD = de.ProjectCD AND h.HinbanCD = de.HinbanCD
		INNER JOIN M_Casting c ON c.CastingCD = h.Casting
		WHERE LEFT(d.YYYYMM, 4) = @targetyear AND td.YYYY -1 < @targetyear AND p.BrandCD = @BrandCD AND
			brand.BrandName like '%' + @BrandName + '%' AND
			(@Season is null or (p.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1)))) AND p.ProjectCD = @ProjectCD AND p.ProjectName like '%' + @ProjectName + '%' AND
			((@DeliveryStatus = 1 AND @d_Amount < h.Production) OR (@DeliveryStatus = 2 AND @d_Amount = h.Production))
		GROUP BY p.BrandCD, brand.BrandName, p.Season, p.Year, d.ProjectCD, p.ProjectName, p.PeriodStart, p.PeriodEnd, h.Production, h.SalesPrice, td.Cost, d.Cost,
			d.HinbanCD, h.HinbanName, h.Color, h.Production, h.Complete, h.SalesPrice, h.Casting, c.CastingName, d.CostCD, keihi.CostName, td.YYYY, d.YYYYMM
		ORDER BY p.BrandCD, p.Season, d.ProjectCD, d.HinbanCD, d.CostCD

		select distinct BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, 
			HinbanCD, HinbanName, Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName,
			(select max(t1.CostPre) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as CostPre,
			(select max(t1.Cost1) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as Cost1,
			(select max(t1.Cost2) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as Cost2,
			(select max(t1.Cost3) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as Cost3,
			(select max(t1.Cost4) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as Cost4,
			(select max(t1.Cost5) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as Cost5,
			(select max(t1.Cost6) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as Cost6,
			(select max(t1.Cost7) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as Cost7,
			(select max(t1.Cost8) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as Cost8,
			(select max(t1.Cost9) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as Cost9,
			(select max(t1.Cost10) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as Cost10,
			(select max(t1.Cost11) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as Cost11,
			(select max(t1.Cost12) from #tempD t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.HinbanCD = t.HinbanCD and t1.CostCD = t.CostCD) as Cost12,
			CostHaihu, CostShikakari, SortKey
		into #tempD40
		from #tempD t
		ORDER BY BrandCD, Season, ProjectCD, HinbanCD, CostCD
				
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName, Color, Production, Complete, 
						SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostShikakari, SortKey  )
					SELECT BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName, Color, Production, Complete, SalesPrice, TotalValue, Casting, 
						CastingName, CostCD, CostName, CostPre,	Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, 
						Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12 AS CostHaihu, CostShikakari, SortKey
					FROM #tempD40';
		EXEC (@SQL);

		DROP TABLE #tempD
		DROP TABLE #tempD40
	end

	else if @type = 'D41'
	begin
		select @d_Amount = sum(d.DeliveryAmount) 
		FROM D_IndirectCost i
		LEFT OUTER JOIN M_Keihi keihi ON keihi.CostCD = i.CostCD
		LEFT OUTER JOIN M_Brand brand ON brand.BrandCD = i.BrandCD
		LEFT OUTER JOIN D_TotalIndirectCost ti ON ti.YYYYMM = i.YYYYMM AND ti.CostCD = i.CostCD AND ti.CastingCD = i.CastingCD
		LEFT OUTER JOIN M_Project p ON p.ProjectCD = i.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = p.ProjectCD AND h.HinbanCD = i.HinbanCD
		LEFT OUTER JOIN D_Delivery d ON d.ProjectCD = h.ProjectCD AND d.HinbanCD = h.HinbanCD
		LEFT OUTER JOIN M_Casting c ON c.CastingCD = i.CastingCD
		WHERE i.Accounting = 3 AND LEFT(i.YYYYMM, 4) = @targetyear AND
			(ti.Accounting = 3 and LEFT(ti.YYYYMM, 4) - 1 < @targetyear) AND
			i.BrandCD = @BrandCD AND brand.BrandName LIKE '%' + @BrandName + '%' AND 
			(@Season is null or (i.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1)))) AND 
			p.ProjectCD = @ProjectCD AND p.ProjectName LIKE '%' + @ProjectName + '%' AND 
			((@DeliveryStatus = 1 AND @d_Amount < h.Production) OR (@DeliveryStatus = 2 AND @d_Amount = h.Production))

		SELECT i.BrandCD, brand.BrandName, i.Season, i.Year, i.ProjectCD, p.ProjectName, p.PeriodStart, p.PeriodEnd, sum(h.Production) as TotalValueSum, sum(h.SalesPrice * h.Production) as ProductionSum, 
			d.HinbanCD, h.HinbanName, h.Color, h.Production, h.Complete, h.SalesPrice, h.SalesPrice * h.Production as TotalValue, h.Casting, c.CastingName, i.CostCD, keihi.CostName,
			(SELECT isnull(Cost, 0) from D_TotalIndirectCost ti1 WHERE ti1.Accounting = 3 AND ti1.YYYYMM = (SELECT Max(ti2.YYYYMM) from D_TotalIndirectCost ti2 WHERE ti2.Accounting = 3 and LEFT(ti2.YYYYMM, 4) < @targetyear)) as CostPre,
			--case when ti.Accounting = 3 and LEFT(ti.YYYYMM, 4) - 1 < @targetyear then 
			--	(SELECT SUM(ti1.Cost) from D_TotalIndirectCost ti1 WHERE ti1.Accounting = 3 AND LEFT(ti1.YYYYMM, 4) = @targetyear - 1) else 0 end CostPre,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '01' then i.Cost else null end Cost1,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '02' then i.Cost else null end Cost2,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '03' then i.Cost else null end Cost3,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '04' then i.Cost else null end Cost4,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '05' then i.Cost else null end Cost5,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '06' then i.Cost else null end Cost6,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '07' then i.Cost else null end Cost7,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '08' then i.Cost else null end Cost8,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '09' then i.Cost else null end Cost9,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '10' then i.Cost else null end Cost10,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '11' then i.Cost else null end Cost11,
			case when ti.Accounting = 3 and ti.YYYYMM = cast(@targetyear as varchar) + '12' then i.Cost else null end Cost12,
			0 as CostHaihu, 0 as CostShikakari, 41 as SortKey
		INTO #tempD1
		FROM D_IndirectCost i
		LEFT OUTER JOIN M_Keihi keihi ON keihi.CostCD = i.CostCD
		LEFT OUTER JOIN M_Brand brand ON brand.BrandCD = i.BrandCD
		LEFT OUTER JOIN D_TotalIndirectCost ti ON ti.YYYYMM = i.YYYYMM AND ti.CostCD = i.CostCD AND ti.CastingCD = i.CastingCD
		LEFT OUTER JOIN M_Project p ON p.ProjectCD = i.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = p.ProjectCD AND h.HinbanCD = i.HinbanCD
		LEFT OUTER JOIN D_Delivery d ON d.ProjectCD = h.ProjectCD AND d.HinbanCD = h.HinbanCD
		LEFT OUTER JOIN M_Casting c ON c.CastingCD = i.CastingCD
		WHERE i.Accounting = 3 AND LEFT(i.YYYYMM, 4) = @targetyear AND
			(ti.Accounting = 3 and LEFT(ti.YYYYMM, 4) - 1 < @targetyear) AND
			i.BrandCD = @BrandCD AND brand.BrandName LIKE '%' + @BrandName + '%' AND 
			(@Season is null or (i.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1)))) AND 
			p.ProjectCD = @ProjectCD AND p.ProjectName LIKE '%' + @ProjectName + '%' AND 
			((@DeliveryStatus = 1 AND @d_Amount < h.Production) OR (@DeliveryStatus = 2 AND @d_Amount = h.Production))
		GROUP BY i.BrandCD, brand.BrandName, i.Season, i.Year, i.ProjectCD, p.ProjectName, p.PeriodStart, p.PeriodEnd, h.Production, h.SalesPrice, d.HinbanCD, h.HinbanName, h.Color, h.Production, h.Complete, 
			h.Casting, c.CastingName, i.CostCD, keihi.CostName, ti.Accounting, ti.YYYYMM, ti.Cost, i.Cost, i.HinbanCD
		ORDER BY i.BrandCD, i.Season, i.ProjectCD, i.HinbanCD, i.CostCD

		
		select distinct BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName, Color, Production, Complete, SalesPrice, 
		TotalValue, Casting, CastingName, CostCD, CostName,
			(select max(t1.CostPre) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as CostPre,
			(select max(t1.Cost1) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost1,
			(select max(t1.Cost2) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost2,
			(select max(t1.Cost3) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost3,
			(select max(t1.Cost4) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost4,
			(select max(t1.Cost5) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost5,
			(select max(t1.Cost6) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost6,
			(select max(t1.Cost7) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost7,
			(select max(t1.Cost8) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost8,
			(select max(t1.Cost9) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost9,
			(select max(t1.Cost10) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost10,
			(select max(t1.Cost11) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost11,
			(select max(t1.Cost12) from #tempD1 t1 where t1.BrandCD = t.BrandCD and t1.Season = t.Season and t1.ProjectCD = t.ProjectCD and t1.CostCD = t.CostCD) as Cost12,
			CostHaihu, CostShikakari, SortKey
		into #tempD41
		from #tempD1 t
		ORDER BY BrandCD, Season, ProjectCD, HinbanCD, CostCD
				
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName, Color, Production, Complete, 
						SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostShikakari, SortKey )
					SELECT BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName, Color, Production, Complete, SalesPrice, 
						TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, 
						Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12 AS CostHaihu, CostShikakari, SortKey
					FROM #tempD41';
		EXEC (@SQL);

		DROP TABLE #tempD1
		DROP TABLE #tempD41
	end
	
	else if @type = 'D43'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostShikakari, SortKey)		
					SELECT ''品番合計'', sum(isnull(CostPre, 0)), sum(isnull(Cost1, 0)), sum(isnull(Cost2, 0)), sum(isnull(Cost3, 0)), sum(isnull(Cost4, 0)), sum(isnull(Cost5, 0)), 
						sum(isnull(Cost6, 0)), sum(isnull(Cost7, 0)), sum(isnull(Cost8, 0)), sum(isnull(Cost9, 0)), sum(isnull(Cost10, 0)), sum(isnull(Cost11, 0)), sum(isnull(Cost12, 0)), sum(isnull(CostHaihu, 0)), 0, 43
					FROM WK_原価集計表_ログインID
					WHERE SortKey = 40 OR SortKey = 41';
		EXEC (@SQL);
	end

END
