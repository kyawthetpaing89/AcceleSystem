 BEGIN TRY 
 Drop Procedure dbo.[Print_GenkaCSV_bakNEW]
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
create PROCEDURE [dbo].[Print_GenkaCSV_bakNEW]
	-- Add the parameters for the stored procedure here
	@targetyear		int,
	@BrandCD		varchar(10),
	@BrandName		varchar(40),
	@Season			varchar(5),
	@ProjectCD		varchar(10),
	@ProjectName	nvarchar (60),
	--@FiscalYYYYMM	int,
	@DeliveryStatus int,
	@LoginID		varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	
	Declare @SQL varchar(max);
	DECLARE @loopcount INT, @count as int, @rowcount INT;

    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WK_原価集計表_' + @LoginID AND TABLE_SCHEMA = 'dbo')
	begin
		set @SQL = 'DROP TABLE WK_原価集計表_' + @LoginID;
		EXEC (@SQL);
	end

	IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WK_原価集計表_' + @LoginID AND TABLE_SCHEMA = 'dbo')
	begin
    set @SQL = 'CREATE TABLE WK_原価集計表_' + @LoginID + '(
		BrandCD	varchar(6),
		BrandName varchar(40),
		Season tinyint,
		Year int,	
		ProjectCD varchar(10),
		ProjectName varchar(60),
		PeriodStart int,	
		PeriodEnd int,	
		TotalValueSum int,	
		ProductionSum int,	
		HinbanCD varchar(6),
		HinbanName varchar(60),
		Color tinyint,
		Production int,	
		Complete int,	
		SalesPrice int,	
		TotalValue int,	
		Casting	varchar(10),
		CastingName	varchar(20),
		Profit int,
		ProfitPercentage decimal(3,3),
		CostCD int,	
		CostName varchar(40),
		CostPre	int,	
		Cost1 int,	
		Cost2 int,	
		Cost3 int,	
		Cost4 int,	
		Cost5 int,	
		Cost6 int,	
		Cost7 int,	
		Cost8 int,	
		Cost9 int,	
		Cost10 int,	
		Cost11 int,	
		Cost12 int,	
		CostHaihu int,	
		CostShikakari int,	
		SortKey	tinyint
		)';
		execute (@SQL); 
    end

	CREATE TABLE #t (
		BrandCD	varchar(6),
		Casting	varchar(10),
		CastingName	varchar(20),
		CostPre	int,	
		Cost1 int,	
		Cost2 int,	
		Cost3 int,	
		Cost4 int,	
		Cost5 int,	
		Cost6 int,	
		Cost7 int,	
		Cost8 int,	
		Cost9 int,	
		Cost10 int,	
		Cost11 int,	
		Cost12 int,	
		CostHaihu int,
		Total int,
		CostShikakari int
	)
	
	--step テーブル転送仕様Ａ10--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'A10'	
	
	--step テーブル転送仕様Ａ11--
	SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 10'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@rowcount OUTPUT
	IF @rowcount > 0
		EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'A11'	

	--テーブル転送仕様B20--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'B20'

	--テーブル転送仕様B21--
	SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 20'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@rowcount OUTPUT
	IF @rowcount > 0
		EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'B21'
	
	--テーブル転送仕様C30--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'C30'

	--テーブル転送仕様C31--
	SET @count = 1
	SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 30 Group by ProjectCD'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@rowcount OUTPUT
	IF @rowcount < 4
	BEGIN
		set @loopcount = 4 - @rowcount
		WHILE (@count <= @loopcount) 
		BEGIN
			SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + '(SortKey) VALUES (31)'
			EXEC (@SQL);
			SET @count = @count + 1
		END
	END

	--テーブル転送仕様C32--
	SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 30'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@rowcount OUTPUT
	IF @rowcount > 0
		EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'C32'

	--テーブル転送仕様D40--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D40'
	
	--テーブル転送仕様D41--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D41'
	
	--テーブル転送仕様D42--
	SET @count = 1
	SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 40 OR SortKey = 41 Group by ProjectCD, HinbanCD'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@rowcount OUTPUT
	IF @rowcount < 9
	BEGIN
		set @loopcount = 9 - @rowcount
		WHILE (@count <= @loopcount) 
		BEGIN
			SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + '(SortKey) VALUES (42)'
			EXEC (@SQL);
			SET @count = @count + 1
		END
	END

	--テーブル転送仕様D43--
	SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 40 OR SortKey = 41'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@rowcount OUTPUT
	IF @rowcount > 0
		EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D43'
	
	--テーブル転送仕様D44--
	SET @SQL = 'UPDATE WK_原価集計表_' + @LoginID +
				' SET Profit = TotalValue - (CostPre + CostHaihu) ,
					ProfitPercentage = ROUND(TotalValue - (CostPre + CostHaihu) / TotalValue * 100, 3, 0)
				WHERE (SortKey = 40 ) OR (SortKey = 41 )'
	EXEC (@SQL);

	--SELECT DATA FOR EXCEL--
	--INSERT INTO #t
	SELECT DISTINCT BrandCD, Casting, CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, 
	CostPre + Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12 + CostHaihu as total, CostShikakari
	FROM WK_原価集計表_ログインID
	WHERE SortKey = 10
	UNION ALL
	SELECT '', '', CostName, sum(CostPre), sum(Cost1), sum(Cost2), sum(Cost3), sum(Cost4), sum(Cost5), sum(Cost6), sum(Cost7), sum(Cost8), sum(Cost9), sum(Cost10), sum(Cost11), sum(Cost12), sum(CostHaihu), 
		   sum(CostPre)+ sum(Cost1)+ sum(Cost2)+ sum(Cost3)+ sum(Cost4)+ sum(Cost5)+ sum(Cost6)+ sum(Cost7)+ sum(Cost8)+ sum(Cost9)+ sum(Cost10)+ sum(Cost11)+ sum(Cost12) + sum(CostHaihu) as total, sum(CostShikakari)
	FROM WK_原価集計表_ログインID
	WHERE SortKey = 11
	GROUP BY CostName
	UNION ALL
	SELECT DISTINCT BrandName + isnull( ', ' + cast(Season as nvarchar(5)), '') + isnull( ', ' + cast(Year as nvarchar(4)),''), '', CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, 
	CostPre + Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12 + CostHaihu as total, CostShikakari
	FROM WK_原価集計表_ログインID
	WHERE SortKey = 20
	UNION ALL
	SELECT '', '', CostName, sum(CostPre), sum(Cost1), sum(Cost2), sum(Cost3), sum(Cost4), sum(Cost5), sum(Cost6), sum(Cost7), sum(Cost8), sum(Cost9), sum(Cost10), sum(Cost11), sum(Cost12), sum(CostHaihu), 
		   sum(CostPre)+ sum(Cost1)+ sum(Cost2)+ sum(Cost3)+ sum(Cost4)+ sum(Cost5)+ sum(Cost6)+ sum(Cost7)+ sum(Cost8)+ sum(Cost9)+ sum(Cost10)+ sum(Cost11)+ sum(Cost12) + sum(CostHaihu) as total, sum(CostShikakari)
	FROM WK_原価集計表_ログインID
	WHERE SortKey = 21
	GROUP BY CostName
	UNION ALL
	SELECT DISTINCT '', 'C30', CostName, CostPre, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8, Cost9, Cost10, Cost11, Cost12, CostHaihu, 
	CostPre + Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12 + CostHaihu as total, CostShikakari
	FROM WK_原価集計表_ログインID
	WHERE SortKey = 30
	UNION ALL
	SELECT '', 'C30', CostName, sum(CostPre), sum(Cost1), sum(Cost2), sum(Cost3), sum(Cost4), sum(Cost5), sum(Cost6), sum(Cost7), sum(Cost8), sum(Cost9), sum(Cost10), sum(Cost11), sum(Cost12), sum(CostHaihu), 
		   sum(CostPre)+ sum(Cost1)+ sum(Cost2)+ sum(Cost3)+ sum(Cost4)+ sum(Cost5)+ sum(Cost6)+ sum(Cost7)+ sum(Cost8)+ sum(Cost9)+ sum(Cost10)+ sum(Cost11)+ sum(Cost12) + sum(CostHaihu) as total, sum(CostShikakari)
	FROM WK_原価集計表_ログインID
	WHERE SortKey = 32
	GROUP BY CostName
	--UNION ALL



--SELECT 
--CASE WHEN t.SortKey = 10 THEN t.BrandCD
--	 WHEN t.SortKey = 11 THEN NULL
--	 WHEN t.SortKey = 20 THEN t.BrandName + isnull( ', ' + cast(t.Season as nvarchar(5)), '') + isnull( ', ' + cast(t.Year as nvarchar(4)),'')
--	 WHEN t.SortKey = 21 THEN NULL
--	 WHEN t.SortKey = 30 THEN NULL
--	 WHEN t.SortKey = 31 THEN NULL
--	 WHEN t.SortKey = 32 THEN NULL
--	 WHEN t.SortKey = 40 THEN NULL
--	 WHEN t.SortKey = 41 THEN NULL
--	 WHEN t.SortKey = 42 THEN NULL 
--	 WHEN t.SortKey = 43 THEN NULL  END AS '【金型費、B/S、年度】',
	 
--CASE WHEN t.SortKey = 10 THEN t.CostName
--	 WHEN t.SortKey = 11 THEN t.CostName
--	 WHEN t.SortKey = 20 THEN t.CostName
--	 WHEN t.SortKey = 21 THEN t.CostName
--	 WHEN t.SortKey = 30 THEN t.CostName
--	 WHEN NOT EXISTS(select 1 from WK_原価集計表_ログインID t1 where t1.SortKey = 30 and t1.SortKey = 41 ) THEN t.CostName 
--	 WHEN t.SortKey = 32 THEN t.CostName
--	 WHEN t.SortKey = 40 THEN t.CostName
--	 WHEN t.SortKey = 41 THEN t.CostName
--	 WHEN t.SortKey = 42 THEN t.CostName 
--	 WHEN t.SortKey = 43 THEN NULL  END AS '【費目名】' ,

--t.CostPre as '【前期発生金額】',
--t.Cost1 as  '【1月】',
--t.Cost2 as '【2月】',
--t.Cost3 as '【3月】' ,
--t.Cost4 as '【4月】',
--t.Cost5 as '【5月】',
--t.Cost6 as '【6月】',
--t.Cost7 as '【7月】',
--t.Cost8 as '【8月】',
--t.Cost9 as '【9月】',
--t.Cost10 as '【10月】',
--t.Cost11 as '【11月】',
--t.Cost12 as '【12月】',
--t.CostHaihu as '【当月配賦金額】',
--t.CostPre + t.Cost1 + t.Cost2 + t.Cost3 + t.Cost4 + t.Cost5 + t.Cost6 + t.Cost7 + t.Cost8 + t.Cost9 + t.Cost10 + t.Cost11 + t.Cost12 as '【費目合計】',
--0 as '【当期仕掛金額】',
-- '★　'+ cast(Month(Convert(date,(CONVERT(varchar,mc.FiscalYYYYMM)+'01'))) as nvarchar(2)) + '月　★' as '当月のセルの目印'

--FROM WK_原価集計表_ログインID t, M_Control mc
--Where mc.MainKey = 1
--ORDER BY t.SortKey, t.ProjectCD, t.HinbanCD, t.CostCD

DROP TABLE #t
END
