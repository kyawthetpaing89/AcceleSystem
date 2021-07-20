 BEGIN TRY 
 Drop Procedure dbo.[Print_Genka_ABCD]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Print_Genka_ABCD]
	-- Add the parameters for the stored procedure here
	@targetyear		varchar(4),
	@BrandCD		varchar(10) = NULL,
	@BrandName		varchar(40) = NULL,
	@Season			varchar(5),
	@ProjectCD		varchar(15) = NULL,
	@ProjectName	varchar (60) = NULL,
	@DeliveryStatus varchar(1),
	--@type			nvarchar(3), s.akao
    @type           nvarchar(10),
	@LoginID		varchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	
	SET ANSI_WARNINGS OFF;
	
    DECLARE @ErrorMsg nvarchar(max) = 'Error Print_Genka_ABCD @type:' + @type

	declare @d_Amount int, @SQL nvarchar(max);

	if @type = 'A10'   --ErorTask_176/金型名(A10,D40,D4100,D4101,D4102,D4103,D4104,D4105,D4106,D4107,D4108,D4109,D4110,D4111) by syk 2021-02-18
	begin				
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey )
		SELECT ''金型費'', t1.CastingCD, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), isnull(t1.[04], ''''),				
			isnull(t1.[05], ''''), isnull(t1.[06], ''''), isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 0, 
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0), 0, 10
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				CastingCD,
				ISNULL(Cost, 0) as Cost
			FROM D_IndirectCost
			WHERE left(YYYYMM,4) = ' + @targetyear + ' AND Accounting = 4
			) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN
		(
			SELECT d1.YYYYMM,d1.CastingCD,d1.CostCD,sum(d1.Cost) as Cost FROM D_TotalIndirectCost d1
			INNER JOIN (
				SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD 
				FROM D_TotalIndirectCost
				WHERE Accounting = 4 and left(YYYYMM,4) < ' + @targetyear +
				' GROUP BY CostCD,CastingCD
				) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CastingCD = d2.CastingCD AND d1.CostCD = d2.CostCD
				WHERE Accounting = 4 AND left(d1.YYYYMM,4) < ' + @targetyear +
				' GROUP BY d1.YYYYMM, d1.CastingCD, d1.CostCD, d1.Accounting
		) t2 ON t1.CostCD = t2.CostCD AND t1.CastingCD = t2.CastingCD
		LEFT OUTER JOIN M_Keihi mk ON t1.CostCD = mk.CostCD
		LEFT OUTER JOIN M_Casting mc ON t1.CastingCD = mc.CastingCD
		ORDER BY CastingCD';     
		EXEC (@SQL);

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'A11'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( CostName, CostPre, Cost1,Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey)
					SELECT ''金型合計'', sum(CostPre), sum(Cost1), sum(Cost2), sum(Cost3), sum(Cost4), sum(Cost5), sum(Cost6), sum(Cost7), sum(Cost8), sum(Cost9), sum(Cost10), sum(Cost11), sum(Cost12), 0, 
					sum(CostPre) + isnull(sum(Cost1), 0) + isnull(sum(Cost2), 0) + isnull(sum(Cost3), 0) + isnull(sum(Cost4), 0) +	isnull(sum(Cost5), 0) + isnull(sum(Cost6), 0) + isnull(sum(Cost7), 0) + isnull(sum(Cost8), 0) + isnull(sum(Cost9), 0) + 
					isnull(sum(Cost10), 0) + isnull(sum(Cost11), 0) + isnull(sum(Cost12), 0), 0, 11
					FROM WK_原価集計表_' + @LoginID +
					' WHERE SortKey = 10 GROUP BY Casting';
		EXEC (@SQL);

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'B20'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey )
		SELECT t1.BrandCD, mb.BrandName, t1.Season, t1.Year, t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), isnull(t1.[04], ''''),
			isnull(t1.[05], ''''), isnull(t1.[06], ''''), isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 0, ISNULL(t2.Cost, 0) + 0, 0, 20
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				BrandCD,
				CostCD,
				Season,
				Year,
				ISNULL(Cost, 0) as Cost
			FROM D_IndirectCost
			WHERE LEFT(YYYYMM,4) = ' + @targetyear + ' AND Accounting = 2
			AND (@BrandCD is null OR (BrandCD = @BrandCD))
			AND ( ''' + @Season + ''' is null OR (Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
			) T1
			PIVOT (
				SUM(Cost) 
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.Season,sum(d1.Cost) Cost FROM D_TotalIndirectCost d1
			INNER JOIN (
				SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
				FROM D_TotalIndirectCost
				WHERE Accounting = 2 AND left(YYYYMM,4) < ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
				) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.BrandCD = d2.BrandCD AND d1.Season = d2.Season
			WHERE d1.Accounting = 2 AND left(d1.YYYYMM,4) < ' + @targetyear + ' GROUP BY d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.Season
		) t2 ON t1.CostCD = t2.CostCD AND t1.BrandCD = t2.BrandCD AND t1.Season = t2.Season
		LEFT OUTER JOIN M_Brand mb on t1.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD
		WHERE (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName +''%''))
		ORDER BY t1.BrandCD, t1.Season, t1.CostCD';
		--EXEC (@SQL);
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40)', @BrandCD = @BrandCD, @BrandName = @BrandName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  	end

	else if @type = 'B21'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu,CostHimoku, CostShikakari, SortKey)		
					SELECT ''B/S合計(直接) '', sum(CostPre), sum(Cost1), sum(Cost2), sum(Cost3), sum(Cost4), sum(Cost5), sum(Cost6), sum(Cost7), sum(Cost8), sum(Cost9), sum(Cost10), sum(Cost11), sum(Cost12), 0, 
					sum(CostPre) +0, 0, 21
					FROM  WK_原価集計表_' + @LoginID +
					' WHERE SortKey = 20 GROUP BY BrandCD ORDER BY BrandCD';
		EXEC (@SQL);

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'C30'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, CostCD, CostName, CostPre, 
						Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu,CostHimoku, CostShikakari, SortKey )
		SELECT DISTINCT mp.BrandCD, mb.BrandName, mp.Season, mp.Year, ISNULL(t1.ProjectCD, mp.ProjectCD) AS ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum,
		t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''), 
		isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
		0 as CostHaihu,
		isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
		isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku,
		0 as CostShikakari, 
		30 as SortKey
		FROM M_Project mp
		LEFT OUTER JOIN
		(
			SELECT
				right(d1.YYYYMM,2) as MM,
				/*d1.YYYYMM,*/
				d1.CostCD,
				d1.ProjectCD,
				d1.HinbanCD,
				ISNULL(d1.Cost, 0) as Cost
			FROM D_DirectCost d1
			INNER JOIN
			(SELECT MAX(YYYYMM) AS YYYYMM, CostCD, ProjectCD, HinbanCD FROM D_DirectCost WHERE LEFT(YYYYMM,4) = ' + @targetyear + ' GROUP BY CostCD, ProjectCD, HinbanCD ) d2
			ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.ProjectCD = d2.ProjectCD AND d1.HinbanCD = d2.HinbanCD
			WHERE LEFT(d1.YYYYMM,4) = ' + @targetyear + '
			and d1.HinbanCD = ''@@@''
			) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1 on t1.ProjectCD = mp.ProjectCD
		LEFT OUTER JOIN
		(
			SELECT d1.YYYY,d1.CostCD,d1.ProjectCD, sum(d1.Cost) Cost from D_TotalDirectCost d1
			INNER JOIN (
						SELECT max(YYYY) as YYYY, CostCD, ProjectCD
						FROM D_TotalDirectCost
						GROUP BY CostCD, ProjectCD
					) d2 ON d1.YYYY = d2.YYYY AND d1.CostCD = d2.CostCD AND d1.ProjectCD = d2.ProjectCD 
			GROUP BY d1.YYYY, d1.CostCD, d1.ProjectCD
		) t2 ON t1.CostCD = t2.CostCD 
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD) mh ON mh.ProjectCD = mp.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Brand mb ON mp.BrandCD = mb.BrandCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD ))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY mp.BrandCD, mp.Season, ProjectCD, t1.CostCD';
		--EXEC (@SQL);
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'C32'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHimoku, SortKey)		
					SELECT ''プロジェクト経費計'', sum(isnull(CostPre, 0)), sum(isnull(Cost1, 0)), sum(isnull(Cost2, 0)), sum(isnull(Cost3, 0)), sum(isnull(Cost4, 0)), sum(isnull(Cost5, 0)), 
						sum(isnull(Cost6, 0)), sum(isnull(Cost7, 0)), sum(isnull(Cost8, 0)), sum(isnull(Cost9, 0)), sum(isnull(Cost10, 0)), sum(isnull(Cost11, 0)), sum(isnull(Cost12, 0)), sum(isnull(CostPre, 0)) + 0, 32
					FROM WK_原価集計表_' + @LoginID +
					' WHERE SortKey = 30 GROUP BY ProjectCD ORDER BY ProjectCD';
		EXEC (@SQL);

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D40'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey )
		SELECT mp.BrandCD, mb.BrandName, mp.Season, mp.Year, h.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, h.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), h.Casting, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			0 as CostHaihu, 
			isnull(t2.Cost, 0) +  isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku,
			0 as CostShikakari, 
			40 as SortKey
		FROM M_Hinban h
		INNER JOIN M_Project mp on h.ProjectCD = mp.ProjectCD
		LEFT OUTER JOIN (
			SELECT
				right(YYYYMM,2) as MM,
				LEFT(YYYYMM,4) as YYYY,
				CostCD,
				ProjectCD,
				HinbanCD,
				ISNULL(Cost, 0) as Cost
			FROM D_DirectCost
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' AND HinbanCD <> ''@@@''
			) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1 ON h.ProjectCD = t1.ProjectCD AND h.HinbanCD = t1.HinbanCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD
		LEFT OUTER JOIN M_Brand mb on mp.BrandCD = mb.BrandCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYY,d1.CostCD,d1.ProjectCD, sum(d1.Cost) Cost from D_TotalDirectCost d1
			INNER JOIN (
						SELECT max(YYYY) as YYYY, CostCD, ProjectCD
						FROM D_TotalDirectCost
						WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD)) AND YYYY < ' + @targetyear + ' GROUP BY CostCD, ProjectCD
					) d2 ON d1.YYYY = d2.YYYY AND d1.CostCD = d2.CostCD AND d1.ProjectCD = d2.ProjectCD 
			WHERE (@ProjectCD is null or (d1.ProjectCD = @ProjectCD)) AND d1.YYYY < ' + @targetyear + ' GROUP BY d1.YYYY, d1.CostCD, d1.ProjectCD, d1.HinbanCD
		) t2 ON t1.YYYY = t2.YYYY AND t1.CostCD = t2.CostCD 
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON h.HinbanCD = mh.HinbanCD AND h.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Casting mc ON h.Casting = mc.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD ))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName +''%''))
		AND ( ''' + @Season + ''' is null OR (Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY mp.BrandCD, mp.Season, h.ProjectCD, h.HinbanCD, t1.CostCD';
		--EXEC (@SQL);
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D4100'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey )
		SELECT t1.BrandCD, mb.BrandName, t1.Season, mp.Year, t1.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, t1.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), h.Casting, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu,
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku,
			0 as CostShikakari, 
			4100 as SortKey
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				ProjectCD,
				HinbanCD,
				BrandCD,
				Season,
				ISNULL(Cost, 0) as Cost
			FROM D_PV_BS
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' ) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD	
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD AND h.HinbanCD = mh.HinbanCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD	
		LEFT OUTER JOIN M_Brand mb on mp.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Casting mc ON h.Casting = mc.CastingCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.CastingCD,d1.Cost AS Cost from D_TotalIndirectCost d1
			INNER JOIN (
						SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
						FROM D_TotalIndirectCost
						WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
					) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD
			WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + '
		) t2 ON t1.CostCD = t2.CostCD AND t1.BrandCD = t2.BrandCD AND h.Casting = t2.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD ))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY t1.BrandCD, t1.Season, t1.ProjectCD, t1.HinbanCD, t1.CostCD';
		--exec (@SQL)
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D4101'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu,CostHimoku,  CostShikakari, SortKey )
		SELECT mp.BrandCD, mb.BrandName, mp.Season, mp.Year, t1.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, t1.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), h.Casting, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu, 
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku,
			0 as CostShikakari, 
			4101 as SortKey
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				ProjectCD,
				HinbanCD,
				ISNULL(Cost, 0) as Cost
			FROM D_PV_PJ
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' ) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD	
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD AND h.HinbanCD = mh.HinbanCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD	
		LEFT OUTER JOIN M_Brand mb on mp.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Casting mc ON h.Casting = mc.CastingCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.CastingCD,d1.Cost AS Cost from D_TotalIndirectCost d1
			INNER JOIN (
						SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
						FROM D_TotalIndirectCost
						WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
					) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD
			WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + '
		) t2 ON t1.CostCD = t2.CostCD AND mp.BrandCD = t2.BrandCD AND h.Casting = t2.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName +''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY mp.BrandCD, mp.Season, t1.ProjectCD, t1.HinbanCD, t1.CostCD';
		--exec (@SQL)
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D4102'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey )
		SELECT mp.BrandCD, mb.BrandName, mp.Season, mp.Year, t1.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, t1.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), t1.CastingCD, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu, 
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku,
			0 as CostShikakari, 
			4102 as SortKey
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				ProjectCD,
				HinbanCD,
				CastingCD,
				ISNULL(Cost, 0) as Cost
			FROM D_PV_Cast
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' ) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD	
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD AND h.HinbanCD = mh.HinbanCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD	
		LEFT OUTER JOIN M_Brand mb on mp.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Casting mc ON h.Casting = mc.CastingCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.CastingCD,d1.Cost AS Cost from D_TotalIndirectCost d1
			INNER JOIN (
						SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
						FROM D_TotalIndirectCost
						WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
					) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD
			WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + '
		) t2 ON t1.CostCD = t2.CostCD AND mp.BrandCD = t2.BrandCD AND h.Casting = t2.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY mp.BrandCD, mp.Season, t1.ProjectCD, t1.HinbanCD, t1.CostCD';
		--exec (@SQL)
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D4103'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey )
		SELECT mp.BrandCD, mb.BrandName, mp.Season, mp.Year, t1.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, t1.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), h.Casting, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu, 
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku,
			0 as CostShikakari, 
			4103 as SortKey
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				ProjectCD,
				HinbanCD,
				FreeItem1,
				ISNULL(Cost, 0) as Cost
			FROM D_PV_FreeItem1
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' ) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD	
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD AND h.HinbanCD = mh.HinbanCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD	
		LEFT OUTER JOIN M_Brand mb on mp.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Casting mc ON h.Casting = mc.CastingCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.CastingCD,d1.Cost AS Cost from D_TotalIndirectCost d1
			INNER JOIN (
						SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
						FROM D_TotalIndirectCost
						WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
					) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD
			WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + '
		) t2 ON t1.CostCD = t2.CostCD AND mp.BrandCD = t2.BrandCD AND h.Casting = t2.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD ))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY mp.BrandCD, mp.Season, t1.ProjectCD, t1.HinbanCD, t1.CostCD';
		--exec (@SQL)
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D4104'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey )
		SELECT t1.BrandCD, mb.BrandName, t1.Season, mp.Year, t1.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, t1.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), h.Casting, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu, 
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku, 
			0 as CostShikakari, 
			4104 as SortKey
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				ProjectCD,
				HinbanCD,
				BrandCD,
				Season,
				ISNULL(Cost, 0) as Cost
			FROM D_PP_BS
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' ) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD	
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD AND h.HinbanCD = mh.HinbanCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON mh.HinbanCD = dd.HinbanCD AND mh.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD	
		LEFT OUTER JOIN M_Brand mb on t1.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Casting mc ON h.Casting = mc.CastingCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.CastingCD,d1.Cost AS Cost from D_TotalIndirectCost d1
			INNER JOIN (
						SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
						FROM D_TotalIndirectCost
						WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
					) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD
			WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + '
		) t2 ON t1.CostCD = t2.CostCD AND t1.BrandCD = t2.BrandCD AND h.Casting = t2.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY t1.BrandCD, t1.Season, t1.ProjectCD, t1.HinbanCD, t1.CostCD';
		--exec (@SQL)
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D4105'
    begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey )
		SELECT mp.BrandCD, mb.BrandName, mp.Season, mp.Year, t1.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, t1.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), h.Casting, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu, 
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku,
			0 as CostShikakari, 
			4105 as SortKey
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				ProjectCD,
				HinbanCD,
				ISNULL(Cost, 0) as Cost
            FROM D_PP_PJ
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' ) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD	
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD AND h.HinbanCD = mh.HinbanCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD	
		LEFT OUTER JOIN M_Brand mb on mp.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Casting mc ON h.Casting = mc.CastingCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.CastingCD,d1.Cost AS Cost from D_TotalIndirectCost d1
			INNER JOIN (
						SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
						FROM D_TotalIndirectCost
						WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
					) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD
			WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + '
		) t2 ON t1.CostCD = t2.CostCD AND mp.BrandCD = t2.BrandCD AND h.Casting = t2.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY mp.BrandCD, mp.Season, t1.ProjectCD, t1.HinbanCD, t1.CostCD';
		--exec (@SQL)
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D4106'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey )
		SELECT mp.BrandCD, mb.BrandName, mp.Season, mp.Year, t1.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, t1.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), t1.CastingCD, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu, 
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku,
			0 as CostShikakari, 
			4106 as SortKey
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				ProjectCD,
				HinbanCD,
				CastingCD,
				ISNULL(Cost, 0) as Cost
			FROM D_PP_Cast
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' ) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD	
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD AND h.HinbanCD = mh.HinbanCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD	
		LEFT OUTER JOIN M_Brand mb on mp.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Casting mc ON h.Casting = mc.CastingCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.CastingCD,d1.Cost AS Cost from D_TotalIndirectCost d1
			INNER JOIN (
						SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
						FROM D_TotalIndirectCost
						WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
					) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD
			WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + '
		) t2 ON t1.CostCD = t2.CostCD AND mp.BrandCD = t2.BrandCD AND t1.CastingCD = t2.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD ))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY mp.BrandCD, mp.Season, t1.ProjectCD, t1.HinbanCD, t1.CostCD';
		--exec (@SQL)
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D4107'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey )
		SELECT mp.BrandCD, mb.BrandName, mp.Season, mp.Year, t1.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, t1.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), h.Casting, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu, 
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku,
			0 as CostShikakari, 
			4107 as SortKey
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				ProjectCD,
				HinbanCD,
				FreeItem1,
				ISNULL(Cost, 0) as Cost
			FROM D_PP_FreeItem1
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' ) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD	
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD AND h.HinbanCD = mh.HinbanCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD	
		LEFT OUTER JOIN M_Brand mb on mp.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Casting mc ON h.Casting = mc.CastingCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.CastingCD,d1.Cost AS Cost from D_TotalIndirectCost d1
			INNER JOIN (
						SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
						FROM D_TotalIndirectCost
						WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
					) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD
			WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + '
		) t2 ON t1.CostCD = t2.CostCD AND mp.BrandCD = t2.BrandCD AND h.Casting = t2.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY mp.BrandCD, mp.Season, t1.ProjectCD, t1.HinbanCD, t1.CostCD';
		--exec (@SQL)
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D4108'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey )
		SELECT t1.BrandCD, mb.BrandName, t1.Season, mp.Year, t1.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, t1.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), h.Casting, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu, 
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku, 
			0 as CostShikakari, 
			4108 as SortKey
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				ProjectCD,
				HinbanCD,
				BrandCD,
				Season,
				ISNULL(Cost, 0) as Cost
			FROM D_PF_BS
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' ) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD	
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD AND h.HinbanCD = mh.HinbanCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD	
		LEFT OUTER JOIN M_Brand mb on t1.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Casting mc ON h.Casting = mc.CastingCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.CastingCD,d1.Cost AS Cost from D_TotalIndirectCost d1
			INNER JOIN (
						SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
						FROM D_TotalIndirectCost
						WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
					) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD
			WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + '
		) t2 ON t1.CostCD = t2.CostCD AND t1.BrandCD = t2.BrandCD AND h.Casting = t2.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD))
		AND ( @BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY t1.BrandCD, t1.Season, t1.ProjectCD, t1.HinbanCD, t1.CostCD';
		--exec (@SQL)
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D4109'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu,CostHimoku, CostShikakari, SortKey )
		SELECT mp.BrandCD, mb.BrandName, mp.Season, mp.Year, t1.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, t1.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), h.Casting, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu, 
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku,
			0 as CostShikakari, 
			4109 as SortKey
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				ProjectCD,
				HinbanCD,
				ISNULL(Cost, 0) as Cost
			FROM D_PF_PJ
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' ) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD	
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD AND h.HinbanCD = mh.HinbanCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD	
		LEFT OUTER JOIN M_Brand mb on mp.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Casting mc ON h.Casting = mc.CastingCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.CastingCD,d1.Cost AS Cost from D_TotalIndirectCost d1
			INNER JOIN (
						SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
						FROM D_TotalIndirectCost
						WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
					) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD
			WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + '
		) t2 ON t1.CostCD = t2.CostCD AND mp.BrandCD = t2.BrandCD AND h.Casting = t2.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY mp.BrandCD, mp.Season, t1.ProjectCD, t1.HinbanCD, t1.CostCD';
		--exec (@SQL)
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D4110'
	begin
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu,CostHimoku, CostShikakari, SortKey )
		SELECT mp.BrandCD, mb.BrandName, mp.Season, mp.Year, t1.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, t1.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), t1.CastingCD, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu, 
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku,
			0 as CostShikakari, 
			4110 as SortKey
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				ProjectCD,
				HinbanCD,
				CastingCD,
				ISNULL(Cost, 0) as Cost
			FROM D_PF_Cast
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' ) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD	
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD AND h.HinbanCD = mh.HinbanCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD	
		LEFT OUTER JOIN M_Brand mb on mp.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Casting mc ON t1.CastingCD = mc.CastingCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.CastingCD,d1.Cost AS Cost from D_TotalIndirectCost d1
			INNER JOIN (
						SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
						FROM D_TotalIndirectCost
						WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
					) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD
			WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + '
		) t2 ON t1.CostCD = t2.CostCD AND mp.BrandCD = t2.BrandCD AND t1.CastingCD = t2.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY mp.BrandCD, mp.Season, t1.ProjectCD, t1.HinbanCD, t1.CostCD';
		--exec (@SQL)
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	else if @type = 'D4111'
	begin		
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
			Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey )
		SELECT mp.BrandCD, mb.BrandName, mp.Season, mp.Year, t1.ProjectCD, mp.ProjectName, left(mp.PeriodStart,4) +''/''+ right(mp.PeriodStart,2) AS PeriodStart, left(mp.PeriodEnd,4) +''/''+ right(mp.PeriodEnd,2) AS PeriodEnd, mh.TotalValueSum, mh.ProductionSum, t1.HinbanCD, h.HinbanName, h.Color, 
			h.Production, h.Complete, ISNULL(h.SalesPrice, 0), ISNULL(h.SalesPrice, 0) * ISNULL(h.Production, 0), h.Casting, ISNULL(mc.CastingName,''''), t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
			isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
			isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu, 
			isnull(t2.Cost, 0) + isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
			isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHimoku,
			0 as CostShikakari, 
			4111 as SortKey
		FROM (
			SELECT
				right(YYYYMM,2) as MM,
				CostCD,
				ProjectCD,
				HinbanCD,
				FreeItem1,
				ISNULL(Cost, 0) as Cost
			FROM D_PF_FreeItem1
			WHERE LEFT(YYYYMM,4) = ' + @targetyear +
			' ) T1
			PIVOT (
				SUM(Cost)
				FOR [MM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
			) AS t1
		LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD	
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(ISNULL(Production, 0)) AS TotalValueSum, SUM(ISNULL(SalesPrice, 0) * ISNULL(Production, 0)) AS ProductionSum 
			 FROM M_Hinban
			 WHERE (@ProjectCD is null or (ProjectCD = @ProjectCD))
			 GROUP BY ProjectCD, HinbanCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
		LEFT OUTER JOIN M_Hinban h ON h.ProjectCD = mh.ProjectCD AND h.HinbanCD = mh.HinbanCD
		LEFT OUTER JOIN
			(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
			 FROM D_Delivery
			 GROUP BY ProjectCD, HinbanCD) dd ON h.HinbanCD = dd.HinbanCD AND h.ProjectCD = dd.ProjectCD
		LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD	
		LEFT OUTER JOIN M_Brand mb on mp.BrandCD = mb.BrandCD
		LEFT OUTER JOIN M_Casting mc ON h.Casting = mc.CastingCD
		LEFT OUTER JOIN	
		(
			SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.CastingCD,d1.Cost AS Cost from D_TotalIndirectCost d1
			INNER JOIN (
						SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
						FROM D_TotalIndirectCost
						WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
					) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD
			WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + '
		) t2 ON t1.CostCD = t2.CostCD AND mp.BrandCD = t2.BrandCD AND h.Casting = t2.CastingCD
		WHERE (@BrandCD is null OR (mp.BrandCD = @BrandCD))
		AND (@BrandName is null OR (mb.BrandName like ''%'' + @BrandName + ''%''))
		AND ( ''' + @Season + ''' is null OR (mp.Season IN (SUBSTRING( ''' + @Season + ''',1,1),SUBSTRING( ''' + @Season + ''',3,1),SUBSTRING( ''' + @Season + ''',5,1))))
		AND (@ProjectCD is null or (mp.ProjectCD = @ProjectCD))
		AND (@ProjectName is null or (mp.ProjectName like ''%'' + @ProjectName + ''%''))
		AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < ISNULL(h.Production, 0)) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = ISNULL(h.Production,0)))
		ORDER BY mp.BrandCD, mp.Season, t1.ProjectCD, t1.HinbanCD, t1.CostCD';
		--exec (@SQL)
		EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10), @BrandName varchar(40), @ProjectCD varchar(15), @ProjectName varchar(60)', 
		@BrandCD = @BrandCD, @BrandName = @BrandName, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName

        IF @@ERROR <> 0   
        BEGIN  
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

	--else if @type = 'D41'
	--begin
	--	SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( BrandCD, BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, HinbanName,
	--	Color, Production, Complete, SalesPrice, TotalValue, Casting, CastingName, CostCD, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostShikakari, SortKey )
	--	SELECT t1.BrandCD, mb.BrandName, t1.Season, t1.Year, t1.ProjectCD, mp.ProjectName, mp.PeriodStart, mp.PeriodEnd, mh.TotalValueSum, mh.ProductionSum, mh.HinbanCD, mh.HinbanName, mh.Color, mh.Production,
	--	mh.Complete, mh.SalesPrice, mh.TotalValue, mh.Casting, mc.CastingName, t1.CostCD, mk.CostName, isnull(t2.Cost, ''''), isnull(t1.[01], ''''), isnull(t1.[02], ''''), isnull(t1.[03], ''''), 
	--	isnull(t1.[04], ''''), isnull(t1.[05], ''''), isnull(t1.[06], ''''),  isnull(t1.[07], ''''), isnull(t1.[08], ''''), isnull(t1.[09], ''''), isnull(t1.[10], ''''), isnull(t1.[11], ''''), isnull(t1.[12], ''''), 
	--	isnull(t1.[01], 0) + isnull(t1.[02], 0) + isnull(t1.[03], 0) + isnull(t1.[04], 0) +	isnull(t1.[05], 0) + isnull(t1.[06], 0) + isnull(t1.[07], 0) + isnull(t1.[08], 0) + isnull(t1.[09], 0) + 
	--	isnull(t1.[10], 0) + isnull(t1.[11], 0) + isnull(t1.[12], 0) as CostHaihu, 0 as CostShikakari, 41 as SortKey
	--	FROM (
	--		SELECT
	--			right(YYYYMM,2) as YYYYMM,
	--			BrandCD,
	--			Season,
	--			Year,
	--			ProjectCD,
	--			HinbanCD,
	--			CostCD,
	--			CastingCD,
	--			SUM(ISNULL(Cost, 0)) as Cost
	--		FROM D_IndirectCost
	--		WHERE LEFT(YYYYMM,4) = ' + @targetyear + ' AND Accounting = 3
	--		AND ( ''' + @BrandCD + ''' is null OR (BrandCD = ''' + @BrandCD + '''))
	--		AND ( ''' + @Season + ''' is null OR (Season IN (SUBSTRING(''' + @Season + ''',1,1),SUBSTRING(''' + @Season + ''',3,1),SUBSTRING(''' + @Season + ''',5,1))))
	--		GROUP BY YYYYMM,BrandCD,Season,Year,ProjectCD,HinbanCD,CostCD,CastingCD
	--		) T1
	--		PIVOT (
	--			SUM(Cost)
	--			FOR [YYYYMM] IN ( [01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12] )
	--		) AS t1
	--	LEFT OUTER JOIN
	--	(
	--		SELECT d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.Season,sum(d1.Cost) Cost from D_TotalIndirectCost d1
	--		INNER JOIN (
	--					SELECT max(YYYYMM) as YYYYMM,CostCD,CastingCD,BrandCD,Season 
	--					FROM D_TotalIndirectCost
	--					WHERE Accounting = 3 AND left(YYYYMM,4) <  ' + @targetyear + ' GROUP BY CostCD,CastingCD,BrandCD,Season
	--				) d2 ON d1.YYYYMM = d2.YYYYMM AND d1.CostCD = d2.CostCD AND d1.CastingCD = d2.CastingCD AND d1.BrandCD = d2.BrandCD AND d1.Season = d2.Season
	--		WHERE d1.Accounting = 3 AND left(d1.YYYYMM,4) < ' + @targetyear + ' GROUP BY d1.YYYYMM,d1.CostCD,d1.BrandCD,d1.Season
	--	) t2 ON t1.CostCD = t2.CostCD AND t1.BrandCD = t2.BrandCD AND t1.Season = t2.Season
	--	LEFT OUTER JOIN M_Keihi mk on t1.CostCD = mk.CostCD
	--	LEFT OUTER JOIN M_Brand mb on t1.BrandCD = mb.BrandCD
	--	LEFT OUTER JOIN M_Project mp on t1.ProjectCD = mp.ProjectCD
	--	LEFT OUTER JOIN M_Casting mc ON t1.CastingCD = mc.CastingCD
	--	LEFT OUTER JOIN
	--		(SELECT HinbanCD, HinbanName, Color, Production, Complete, SalesPrice, (SalesPrice * Production) as TotalValue, Casting, ProjectCD, 
	--			sum(isnull(Production, 0)) as TotalValueSum, sum(isnull(SalesPrice, 0) * isnull(Production, 0)) as ProductionSum 
	--		 FROM M_Hinban
	--		 GROUP BY HinbanCD, HinbanName, Color, Production, Complete, SalesPrice, Casting, ProjectCD) mh ON t1.HinbanCD = mh.HinbanCD AND mp.ProjectCD = mh.ProjectCD
	--	LEFT OUTER JOIN
	--		(SELECT ProjectCD, HinbanCD, SUM(isnull(DeliveryAmount, 0)) as DeliveryAmount
	--		 FROM D_Delivery
	--		 GROUP BY ProjectCD, HinbanCD) dd ON mh.HinbanCD = dd.HinbanCD AND mh.ProjectCD = dd.ProjectCD
	--	WHERE ( ''' + @BrandName + ''' is null OR (mb.BrandName like ''%'' + ''' + @BrandName + ''' +''%''))
	--	AND ( ''' + @ProjectCD + ''' is null or (mp.ProjectCD = ''' + @ProjectCD + '''))
	--	AND ( ''' + @ProjectName + ''' is null or (mp.ProjectName like ''%'' + ''' + @ProjectName + ''' +''%''))
	--	AND (( ''' + @DeliveryStatus + ''' = ''1'' and ISNULL(dd.DeliveryAmount, 0) < mh.Production) OR ( ''' + @DeliveryStatus + ''' = ''2'' and ISNULL(dd.DeliveryAmount, 0) = mh.Production))
	--	ORDER BY t1.BrandCD, t1.Season, t1.ProjectCD, t1.CostCD';
	--	EXEC (@SQL);
	--end
	
	else if @type = 'D43'
	begin					
		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + ' ( CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, CostHimoku, CostShikakari, SortKey)		
					SELECT ''品番合計'', sum(isnull(CostPre, 0)), sum(isnull(Cost1, 0)), sum(isnull(Cost2, 0)), sum(isnull(Cost3, 0)), sum(isnull(Cost4, 0)), sum(isnull(Cost5, 0)), 
						sum(isnull(Cost6, 0)), sum(isnull(Cost7, 0)), sum(isnull(Cost8, 0)), sum(isnull(Cost9, 0)), sum(isnull(Cost10, 0)), sum(isnull(Cost11, 0)), sum(isnull(Cost12, 0)), 
						sum(isnull(CostHaihu, 0)), 
						sum(isnull(CostHaihu, 0)) + sum(isnull(CostPre, 0)),
						0, 
						43
					FROM WK_原価集計表_' + @LoginID +
					' WHERE (SortKey = 40 OR SortKey = 4100 OR SortKey = 4101 OR SortKey = 4102 OR SortKey = 4103 OR SortKey = 4104 OR SortKey = 4105 OR SortKey = 4106 OR SortKey = 4107 OR SortKey = 4108
					OR SortKey = 4109 OR SortKey = 4110 OR SortKey = 4111)
					GROUP BY ProjectCD, HinbanCD
					ORDER BY ProjectCD, HinbanCD';
		EXEC (@SQL);

        IF @@ERROR <> 0
        BEGIN 
            ;
            THROW 50000, @ErrorMsg, 1
        END  
	end

END
