 BEGIN TRY 
 Drop Procedure dbo.[Print_Genka_ProjectData_bak]
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
CREATE PROCEDURE [dbo].[Print_Genka_ProjectData_bak]
	-- Add the parameters for the stored procedure here
	@ProjectCD	varchar(15), 
	@BrandCD	varchar(10),
	@LoginID	varchar(20),
	@HinbanCD	varchar(10),
	@Season		varchar(5),
	@Type		varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @SQL NVARCHAR(MAX), @countC INT, @countD INT, @b_count INT, @p_count INT, @c_count INT, @d_count INT, @t_count INT;

	IF @Type = 'B'
	BEGIN
		SET @SQL = 'SELECT @cnt=COUNT(*) FROM (SELECT DISTINCT BrandCD, CostCD FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 20 AND BrandCD = @BrandCD AND Season = @Season GROUP BY BrandCD, CostCD, SortKey) B'
		EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT, @BrandCD varchar(10), @Season VARCHAR(5)', @cnt = @b_count OUTPUT, @BrandCD = @BrandCD, @Season = @Season
		IF @b_count > 0
			SET @b_count = @b_count + 1		-- add 1 for SortKey 21 Row
	
		SET @SQL = 'SELECT @cnt=CASE WHEN COUNT(ProjectCD) > 0 THEN COUNT(ProjectCD) ELSE 0 END, @c1nt = SUM(Prj_Count) FROM (SELECT ProjectCD, CASE WHEN COUNT(*) < 4 THEN 4 ELSE COUNT(*) + 1 END AS Prj_Count FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 30 AND BrandCD = @BrandCD AND Season = @Season GROUP BY ProjectCD) C'
		EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT, @c1nt int OUTPUT, @BrandCD varchar(10), @Season VARCHAR(5)', @cnt=@p_count OUTPUT, @c1nt=@c_count OUTPUT, @BrandCD = @BrandCD, @Season = @Season
		--SET @c_count = @p_count * 4

		SET @SQL = 'SELECT @cnt=CASE WHEN COUNT(*) > 0 THEN COUNT(*) * 10 ELSE 0 END FROM (SELECT DISTINCT BrandCD, ProjectCD, HinbanCD FROM WK_原価集計表_' + @LoginID + ' WHERE 
			(SortKey = 40 OR SortKey = 4100 OR SortKey = 4101 OR SortKey = 4102 OR SortKey = 4103 OR SortKey = 4104 OR SortKey = 4105 OR SortKey = 4106 OR SortKey = 4107 OR SortKey = 4108
			OR SortKey = 4109 OR SortKey = 4110 OR SortKey = 4111) AND BrandCD = @BrandCD AND Season = @Season) D'
		EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT, @BrandCD varchar(10), @Season VARCHAR(5)', @cnt=@d_count OUTPUT, @BrandCD = @BrandCD, @Season = @Season

		--ADD @p_count + 1 FOR TOTAL SUM ROWS
		IF @p_count > 0
			SET @d_count = @d_count + @p_count + 1

		SET @SQL = 'SELECT @cnt = CASE WHEN COUNT(*) > 0 THEN COUNT(*) ELSE 0 END FROM (SELECT DISTINCT BrandCD, Season, ProjectCD FROM WK_原価集計表_' + @LoginID + ' wk, M_Control mc 
		 WHERE SortKey = 30 AND BrandCD = @BrandCD AND Season = @Season) P';
		EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT, @BrandCD varchar(10), @Season VARCHAR(5)', @cnt=@p_count OUTPUT, @BrandCD = @BrandCD, @Season = @Season
		
		SET @SQL= '
		SELECT BrandCD, BrandName + ''  '' + CASE WHEN Season = 1 THEN ''通年'' WHEN Season = 2 THEN ''SS'' ELSE ''FW'' END AS BrandName, Season, NULL, NULL AS ProjectCD, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CostCD, CostName, SUM(CostPre) AS CostPre, SUM(Cost1) AS Cost1, SUM(Cost2) AS Cost2, SUM(Cost3) AS Cost3, SUM(Cost4) AS Cost4, SUM(Cost5) AS Cost5, 
		SUM(Cost6) AS Cost6, SUM(Cost7) AS Cost7, SUM(Cost8) AS Cost8, SUM(Cost9) AS Cost9, SUM(Cost10) AS Cost10, SUM(Cost11) AS Cost11, SUM(Cost12) AS Cost12, SUM(CostHaihu) AS CostHaihu, 
		sum(CostPre) + isnull(sum(Cost1), 0) + isnull(sum(Cost2), 0) + isnull(sum(Cost3), 0) + isnull(sum(Cost4), 0) +	isnull(sum(Cost5), 0) + isnull(sum(Cost6), 0) + isnull(sum(Cost7), 0) + isnull(sum(Cost8), 0) + isnull(sum(Cost9), 0) + 
		isnull(sum(Cost10), 0) + isnull(sum(Cost11), 0) + isnull(sum(Cost12), 0) AS CostHimoku, 
		SUM(CostShikakari) AS CostShikakari, SortKey, RIGHT(mc.FiscalYYYYMM, 2) as FiscalMM,' + cast((@b_count + @c_count + @d_count) as varchar) + ' as Row_Count, ' + cast(@p_count as varchar) + ' as Prj_Count
		FROM WK_原価集計表_' + @LoginID + ' wk, M_Control mc 
		 WHERE SortKey = 20 AND BrandCD = ''' + @BrandCD + ''' AND Season = ''' + @Season + ''' GROUP BY BrandCD, BrandName, Season, CostCD, CostName, SortKey, mc.FiscalYYYYMM
		UNION ALL
		SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''B/S合計(直接) '', SUM(CostPre), SUM(Cost1), SUM(Cost2), 
		SUM(Cost3), SUM(Cost4), SUM(Cost5), SUM(Cost6), SUM(Cost7), SUM(Cost8), SUM(Cost9), SUM(Cost10), SUM(Cost11), SUM(Cost12), SUM(CostHaihu),
		sum(CostPre) + isnull(sum(Cost1), 0) + isnull(sum(Cost2), 0) + isnull(sum(Cost3), 0) + isnull(sum(Cost4), 0) +	isnull(sum(Cost5), 0) + isnull(sum(Cost6), 0) + isnull(sum(Cost7), 0) + isnull(sum(Cost8), 0) + isnull(sum(Cost9), 0) + 
		isnull(sum(Cost10), 0) + isnull(sum(Cost11), 0) + isnull(sum(Cost12), 0), 
		SUM(CostShikakari), ''21'' AS SortKey, NULL,' + cast((@b_count + @c_count + @d_count) as varchar) + ' as Row_Count, ' + cast(@p_count as varchar) + ' as Prj_Count
		FROM WK_原価集計表_' + @LoginID + ' wk
		 WHERE SortKey = 20 AND BrandCD = ''' + @BrandCD + ''' AND Season = ''' + @Season + ''' GROUP BY SortKey
		UNION ALL
		SELECT DISTINCT BrandCD, null, Season, null, ProjectCD, null, null, null,  null, null, null,  null, null, null,  null, null, null,  null, null, null, null, null, null, null, null, null, null,
		null, null, null,  null, null, null,  null, null, null,  null, 0 as CostHimoku,null, SortKey, RIGHT(mc.FiscalYYYYMM, 2) as FiscalMM, ' + cast((@b_count + @c_count + @d_count) as varchar) + ' as Row_Count, ' + cast(@p_count as varchar) + ' as Prj_Count
		FROM WK_原価集計表_' + @LoginID + ' wk, M_Control mc 
		 WHERE SortKey = 30 AND BrandCD = ''' + @BrandCD + ''' AND Season = ''' + @Season + ''' 
		ORDER BY SortKey, BrandCD, Season, ProjectCD, CostCD';
		--EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10)', @BrandCD = @BrandCD
		EXEC (@SQL);
	END

	IF @Type = 'C'
	BEGIN	
		SET @SQL = 'select @countC = CASE WHEN 3 - COUNT(*) < 0 THEN 0 ELSE 3 - COUNT(*) END FROM WK_原価集計表_' + @LoginID + ' WHERE ProjectCD = ''' + @ProjectCD + ''' AND BrandCD = ''' + @BrandCD + ''' AND Season = ''' + @Season + ''' AND SortKey = 30'
		EXECUTE sp_executesql @SQL, N'@countC INT OUTPUT', @countC = @countC OUTPUT

		SET @SQL = '
			SELECT BrandCD,  BrandName + ''  '' + CASE WHEN Season = 1 THEN ''通年'' WHEN Season = 2 THEN ''SS'' ELSE ''FW'' END AS BrandName, Season, Year, ProjectCD, ProjectName, PeriodStart, PeriodEnd, TotalValueSum, ProductionSum, HinbanCD, ISNULL(HinbanName, '''') AS HinbanName,
			Color, Production, Complete, SalesPrice, SalesPrice, Casting, ISNULL(CastingName, '''') AS CastingName, Profit, ProfitPercentage, CostCD, ISNULL(CostName, '''') AS CostName, 
			CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu,CostHimoku, CostShikakari, SortKey,
			CostPre + Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12 + CostHaihu as Total 
			FROM WK_原価集計表_' + @LoginID + 
			' WHERE ProjectCD = ''' + @ProjectCD + ''' AND BrandCD = ''' + @BrandCD + ''' AND Season = ''' + @Season + ''' AND SortKey = 30
			UNION ALL
			SELECT TOP ' + CAST(@countC AS VARCHAR(10)) + ' *, 0 as Total
			FROM WK_原価集計表_' + @LoginID + 
			' WHERE SortKey = 31
			UNION ALL
			SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''プロジェクト経費計'' AS CostName, SUM(CostPre), SUM(Cost1), SUM(Cost2), 
			SUM(Cost3), SUM(Cost4), SUM(Cost5), SUM(Cost6), SUM(Cost7), SUM(Cost8), SUM(Cost9), SUM(Cost10), SUM(Cost11), SUM(Cost12), SUM(CostHaihu), SUM(CostHimoku), SUM(CostShikakari),32 AS SortKey,
			SUM(CostPre) + SUM(Cost1) + SUM(Cost2) + SUM(Cost3) + SUM(Cost4) + SUM(Cost5) + SUM(Cost6) + SUM(Cost7) + SUM(Cost8) + SUM(Cost9) + SUM(Cost10) + SUM(Cost11) + SUM(Cost12) + SUM(CostHaihu) as Total
			FROM WK_原価集計表_' + @LoginID + 
			' WHERE ProjectCD = ''' + @ProjectCD + ''' AND BrandCD = ''' + @BrandCD + ''' AND Season = ''' + @Season + ''' AND SortKey = 30 GROUP BY SortKey
			UNION ALL
			SELECT DISTINCT BrandCD, null, Season, null, ProjectCD, null, null, null,  null, null, HinbanCD, null, null, null,  null, null, null,  null, null, null, null, null, null, null, null, null, null,
			null, null, null,  null, null, null,  null, null, null,  null, null, null, 40 AS SortKey, 0 AS Total
			FROM  WK_原価集計表_' + @LoginID + 
			' WHERE ProjectCD = ''' + @ProjectCD + ''' AND BrandCD = ''' + @BrandCD + ''' AND Season = ''' + @Season + ''' AND (SortKey = 40 OR SortKey = 4100 OR SortKey = 4101 OR SortKey = 4102 OR SortKey = 4103 OR SortKey = 4104 OR SortKey = 4105 OR SortKey = 4106 OR SortKey = 4107 OR SortKey = 4108
			OR SortKey = 4109 OR SortKey = 4110 OR SortKey = 4111 OR SortKey = 42)';
		EXEC (@SQL);
	END

	--ELSE IF @Type = 'CLite'
	--BEGIN
	--	SET @SQL = '
	--		SELECT DISTINCT null, null, null, null, ProjectCD, null, null, null,  null, null, HinbanCD, null, null, null,  null, null, null,  null, null, null, null, null, null, null, null, null, null,
	--		null, null, null,  null, null, null,  null, null, null,  null, null, null, 40 AS SortKey, 0 AS Total
	--		FROM  WK_原価集計表_' + @LoginID + 
	--		' WHERE SortKey = 40 OR SortKey = 4100 OR SortKey = 4101 OR SortKey = 4102 OR SortKey = 4103 OR SortKey = 4104 OR SortKey = 4105 OR SortKey = 4106 OR SortKey = 4107 OR SortKey = 4108
	--		OR SortKey = 4109 OR SortKey = 4110 OR SortKey = 4111 OR SortKey = 42 ORDER BY ProjectCD ASC';
	--	EXEC (@SQL);
	--END

	ELSE IF @Type = 'D'
	BEGIN
		SET @SQL = 'select @countD = CASE WHEN 9 - COUNT(*) < 0 THEN 0 ELSE 9 - COUNT(*) END FROM WK_原価集計表_' + @LoginID + ' WHERE BrandCD = ''' + @BrandCD + ''' AND Season = ''' + @Season + ''' AND ProjectCD = ''' + @ProjectCD + ''' AND HinbanCD = ''' + @HinbanCD + ''' AND 
		(SortKey = 40 OR SortKey = 4100 OR SortKey = 4101 OR SortKey = 4102 OR SortKey = 4103 OR SortKey = 4104 OR SortKey = 4105 OR SortKey = 4106 OR SortKey = 4107 OR SortKey = 4108
		OR SortKey = 4109 OR SortKey = 4110 OR SortKey = 4111)'
		EXECUTE sp_executesql @SQL, N'@countD INT OUTPUT', @countD = @countD OUTPUT

		SET @SQL = '	
		SELECT *,CostPre + Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12 + CostHaihu AS Total
			 FROM WK_原価集計表_' + @LoginID + 
			' WHERE ProjectCD = ''' + @ProjectCD + ''' AND BrandCD = ''' + @BrandCD + ''' AND Season = ''' + @Season + ''' AND HinbanCD = ''' + @HinbanCD + ''' AND (SortKey = 40 OR SortKey = 4100 OR SortKey = 4101 OR SortKey = 4102 OR SortKey = 4103 
			OR SortKey = 4104 OR SortKey = 4105 OR SortKey = 4106 OR SortKey = 4107 OR SortKey = 4108 OR SortKey = 4109 OR SortKey = 4110 OR SortKey = 4111)
			UNION ALL
			SELECT TOP ' + CAST(@countD AS VARCHAR(10)) + ' *, 0 as Total
			FROM WK_原価集計表_' + @LoginID + 
			' WHERE SortKey = 42
			UNION ALL
			SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''品番合計'', SUM(CostPre), SUM(Cost1), SUM(Cost2), 
			SUM(Cost3), SUM(Cost4), SUM(Cost5), SUM(Cost6), SUM(Cost7), SUM(Cost8), SUM(Cost9), SUM(Cost10), SUM(Cost11), SUM(Cost12), SUM(CostHaihu), SUM(CostHimoku), SUM(CostShikakari), 43 AS SortKey,
			SUM(CostPre) + SUM(Cost1) + SUM(Cost2) + SUM(Cost3) + SUM(Cost4) + SUM(Cost5) + SUM(Cost6) + SUM(Cost7) + SUM(Cost8) + SUM(Cost9) + SUM(Cost10) + SUM(Cost11) + SUM(Cost12) + SUM(CostHaihu) as Total
			FROM WK_原価集計表_' + @LoginID +
			' WHERE ProjectCD = ''' + @ProjectCD + ''' AND BrandCD = ''' + @BrandCD + ''' AND Season = ''' + @Season + ''' AND HinbanCD = ''' + @HinbanCD + ''' AND (SortKey = 40 OR SortKey = 4100 OR SortKey = 4101 OR SortKey = 4102 OR SortKey = 4103 
			OR SortKey = 4104 OR SortKey = 4105 OR SortKey = 4106 OR SortKey = 4107 OR SortKey = 4108 OR SortKey = 4109 OR SortKey = 4110 OR SortKey = 4111)
			GROUP BY ProjectCD, HinbanCD
		ORDER BY SortKey, ProjectCD, HinbanCD';
		EXEC (@SQL);
	END
	
	ELSE IF @Type = 'P_Total'
	BEGIN
		SET @SQL = '	
			SELECT ''プロジェクト合計'' AS CostName, SUM(CostPre) AS CostPre, SUM(Cost1) AS Cost1, SUM(Cost2) AS Cost2, SUM(Cost3) AS Cost3, 
			SUM(Cost4) AS Cost4, SUM(Cost5) AS Cost5, SUM(Cost6) AS Cost6, SUM(Cost7) AS Cost7, SUM(Cost8) AS Cost8, SUM(Cost9) AS Cost9, SUM(Cost10) AS Cost10, SUM(Cost11) AS Cost11, SUM(Cost12) AS Cost12, 
			SUM(CostHaihu) AS CostHaihu, SUM(CostShikakari) AS CostShikakari, 44 AS SortKey, SUM(CostPre) + SUM(Cost1) + SUM(Cost2) + SUM(Cost3) + SUM(Cost4) + SUM(Cost5) + SUM(Cost6) + SUM(Cost7) + 
			SUM(Cost8) + SUM(Cost9) + SUM(Cost10) + SUM(Cost11) + SUM(Cost12) + SUM(CostHaihu) as Total
			FROM WK_原価集計表_' + @LoginID + 
			' WHERE ProjectCD = ''' + @ProjectCD + ''' AND BrandCD = ''' + @BrandCD + ''' AND Season = ''' + @Season + ''' AND (SortKey = 40 OR SortKey = 4100 OR SortKey = 4101 OR SortKey = 4102 OR SortKey = 4103 
			OR SortKey = 4104 OR SortKey = 4105 OR SortKey = 4106 OR SortKey = 4107 OR SortKey = 4108 OR SortKey = 4109 OR SortKey = 4110 OR SortKey = 4111)
			GROUP BY ProjectCD, BrandCD, Season';
		EXEC (@SQL);
	END

	ELSE IF @Type = 'D_Total'
	BEGIN
		--SET @SQL = '	
		--	SELECT ''B/S　合計'' AS CostName, SUM(CostPre) AS CostPre, SUM(Cost1) AS Cost1, SUM(Cost2) AS Cost2, SUM(Cost3) AS Cost3, 
		--	SUM(Cost4) AS Cost4, SUM(Cost5) AS Cost5, SUM(Cost6) AS Cost6, SUM(Cost7) AS Cost7, SUM(Cost8) AS Cost8, SUM(Cost9) AS Cost9, SUM(Cost10) AS Cost10, SUM(Cost11) AS Cost11, SUM(Cost12) AS Cost12, 
		--	SUM(CostHaihu) AS CostHaihu, SUM(CostShikakari) AS CostShikakari, 44 AS SortKey, SUM(CostPre) + SUM(Cost1) + SUM(Cost2) + SUM(Cost3) + SUM(Cost4) + SUM(Cost5) + SUM(Cost6) + SUM(Cost7) + 
		--	SUM(Cost8) + SUM(Cost9) + SUM(Cost10) + SUM(Cost11) + SUM(Cost12) + SUM(CostHaihu) as Total
		--	FROM WK_原価集計表_' + @LoginID + 
		--	' WHERE SortKey = 43
		--	GROUP BY SortKey';

		SET @SQL = '	
			SELECT ''B/S　合計'' AS CostName, SUM(CostPre) AS CostPre, SUM(Cost1) AS Cost1, SUM(Cost2) AS Cost2, SUM(Cost3) AS Cost3, 
			SUM(Cost4) AS Cost4, SUM(Cost5) AS Cost5, SUM(Cost6) AS Cost6, SUM(Cost7) AS Cost7, SUM(Cost8) AS Cost8, SUM(Cost9) AS Cost9, SUM(Cost10) AS Cost10, SUM(Cost11) AS Cost11, SUM(Cost12) AS Cost12, 
			SUM(CostHaihu) AS CostHaihu, SUM(CostShikakari) AS CostShikakari, 44 AS SortKey, SUM(CostPre) + SUM(Cost1) + SUM(Cost2) + SUM(Cost3) + SUM(Cost4) + SUM(Cost5) + SUM(Cost6) + SUM(Cost7) + 
			SUM(Cost8) + SUM(Cost9) + SUM(Cost10) + SUM(Cost11) + SUM(Cost12) + SUM(CostHaihu) as Total
			FROM WK_原価集計表_' + @LoginID + 
			' WHERE BrandCD = ''' + @BrandCD + ''' AND Season = ''' + @Season + ''' AND (SortKey = 40 OR SortKey = 4100 OR SortKey = 4101 OR SortKey = 4102 OR SortKey = 4103 OR SortKey = 4104 OR SortKey = 4105 OR SortKey = 4106 OR SortKey = 4107 OR SortKey = 4108
					OR SortKey = 4109 OR SortKey = 4110 OR SortKey = 4111)
			GROUP BY BrandCD, Season';
		EXEC (@SQL);
	END
END
