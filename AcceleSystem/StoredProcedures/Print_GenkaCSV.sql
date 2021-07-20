 BEGIN TRY 
 Drop Procedure dbo.[Print_GenkaCSV]
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
CREATE PROCEDURE [dbo].[Print_GenkaCSV]
	-- Add the parameters for the stored procedure here
	@targetyear		varchar(4),
	@BrandCD		varchar(10) = NULL,
	@BrandName		varchar(40) = NULL,
	@Season			varchar(5),
	@ProjectCD		varchar(15) = NULL,
	@ProjectName	nvarchar(60) = NULL,
	--@FiscalYYYYMM	int,
	@DeliveryStatus varchar(1),
	@LoginID		varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	
	SET ANSI_WARNINGS OFF;
	Declare @SQL nvarchar(max);
	DECLARE @loopcount INT, @count as int, @rowcount INT, @a_count INT, @s20_count INT, @o_count INT, @b_count INT, @t_count INT, @minid INT, @maxid INT, @prjCD VARCHAR(15), @hinbanCD VARCHAR(10);

    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WK_原価集計表_' + @LoginID AND TABLE_SCHEMA = 'dbo')
	begin
		set @SQL = 'DROP TABLE WK_原価集計表_' + @LoginID;
		EXEC (@SQL);
	end

	IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WK_原価集計表_' + @LoginID AND TABLE_SCHEMA = 'dbo')
	begin		--Error_Task177 Modify PeriodStart/End datatype
    set @SQL = 'CREATE TABLE WK_原価集計表_' + @LoginID + '(
		BrandCD	varchar(6),
		BrandName varchar(40),
		Season tinyint,
		Year int,	
		ProjectCD varchar(15),
		ProjectName varchar(60),
		PeriodStart varchar(7),	
		PeriodEnd varchar(7),	
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
		ProfitPercentage decimal(6,2),
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
		CostHimoku int,
		CostShikakari int,	
		SortKey	int
		)';
		EXEC (@SQL); 
    end
	
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
	SET @SQL = 'select ROW_NUMBER() OVER(ORDER BY ProjectCD) AS ID, ProjectCD, COUNT(*) as Row_Count INTO [tempdb].[dbo].[tempC' + @LoginID + '] 
	FROM WK_原価集計表_' + @LoginID + ' GROUP BY ProjectCD, SortKey HAVING COUNT(*) < 4 AND SortKey = 30'
	EXECUTE sp_executesql @SQL
	SET @SQL = 'select @minid = min(ID), @maxid = max(ID) FROM [tempdb].[dbo].[tempC' + @LoginID + ']'
	EXECUTE sp_executesql @SQL, N'@minid int OUTPUT, @maxid int OUTPUT', @minid = @minid OUTPUT, @maxid = @maxid OUTPUT
	WHILE (@minid IS NOT NULL AND @maxid IS NOT NULL AND @minid <= @maxid)
	BEGIN		
		SET @count = 1
		SET @SQL = 'SELECT @cnt= CASE WHEN 3 - Row_Count < 0 THEN 0 ELSE 3 - Row_Count END FROM [tempdb].[dbo].[tempC' + @LoginID + '] WHERE ID = @minid'
		EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT, @minid int', @cnt=@loopcount OUTPUT, @minid = @minid
		WHILE (@count <= @loopcount) 
		BEGIN
			SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + '(SortKey) VALUES (31)'
			EXEC (@SQL);
			SET @count = @count + 1
		END
		SET @minid = @minid + 1;
	END
	SET @SQL = 'DROP TABLE [tempdb].[dbo].[tempC' + @LoginID + ']';
	EXEC (@SQL)
	--SET @count = 1
	--SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 30 Group by ProjectCD'
	--EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@rowcount OUTPUT
	--IF isnull(@rowcount, 0) < 4
	--BEGIN
	--	set @loopcount = 4 - isnull(@rowcount, 0)
	--	WHILE (@count <= @loopcount) 
	--	BEGIN
	--		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + '(SortKey) VALUES (31)'
	--		EXEC (@SQL);
	--		SET @count = @count + 1
	--	END
	--END

	--テーブル転送仕様C32--
	SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 30'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@rowcount OUTPUT
	IF @rowcount > 0
		EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'C32'

	--テーブル転送仕様D40--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D40'
	
	--テーブル転送仕様D4100--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D4100'
	
	--テーブル転送仕様D4101--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D4101'
	
	--テーブル転送仕様D4102--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D4102'
	
	--テーブル転送仕様D4103--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D4103'
	
	--テーブル転送仕様D4104--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D4104'
	
	--テーブル転送仕様D4105--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D4105'
	
	--テーブル転送仕様D4106--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D4106'
	
	--テーブル転送仕様D4107--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D4107'
	
	--テーブル転送仕様D4108--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D4108'
	
	--テーブル転送仕様D4109--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D4109'
	
	--テーブル転送仕様D4110--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D4110'
	
	--テーブル転送仕様D4111--
	EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D4111'

	--テーブル転送仕様D41--
	--EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D41'
	
	--テーブル転送仕様D42--	
	SET @SQL = 'select ROW_NUMBER() OVER(ORDER BY ProjectCD, HinbanCD) AS ID, ProjectCD, HinbanCD, COUNT(*) as Row_Count INTO [tempdb].[dbo].[tempD' + @LoginID + '] 
	FROM WK_原価集計表_' + @LoginID + ' GROUP BY ProjectCD, HinbanCD, SortKey HAVING COUNT(*) < 9 AND (SortKey = 40 OR SortKey=4100 OR SortKey=4101 OR SortKey=4102 OR SortKey=4103 OR 
	SortKey=4104 OR SortKey=4105 OR SortKey=4106 OR SortKey=4107 OR SortKey=4108 OR SortKey=4109 OR SortKey=4110 OR SortKey=4111)'
	EXECUTE sp_executesql @SQL
	SET @SQL = 'select @minid = min(ID), @maxid = max(ID) FROM [tempdb].[dbo].[tempD' + @LoginID + ']'
	EXECUTE sp_executesql @SQL, N'@minid int OUTPUT, @maxid int OUTPUT', @minid = @minid OUTPUT, @maxid = @maxid OUTPUT
	WHILE (@minid IS NOT NULL AND @maxid IS NOT NULL AND @minid <= @maxid)
	BEGIN		
		SET @count = 1
		SET @SQL = 'SELECT @cnt= CASE WHEN 9 - Row_Count < 0 THEN 0 ELSE 9 - Row_Count END, @prjCD = ProjectCD, @hinbanCD = HinbanCD FROM [tempdb].[dbo].[tempD' + @LoginID + '] WHERE ID = @minid'
		EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT, @prjCD varchar(15) OUTPUT, @hinbanCD varchar(10) OUTPUT, @minid int', @cnt=@loopcount OUTPUT, @prjCD = @prjCD OUTPUT, @hinbanCD = @hinbanCD OUTPUT, @minid = @minid
		WHILE (@count <= @loopcount) 
		BEGIN
			SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + '(SortKey) VALUES (42)'
			EXEC (@SQL);
			SET @count = @count + 1
		END
		SET @minid = @minid + 1;
	END
	SET @SQL = 'DROP TABLE [tempdb].[dbo].[tempD' + @LoginID + ']';
	EXEC (@SQL)
	--SET @count = 1
	--SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 40 OR SortKey = 41 Group by ProjectCD, HinbanCD'
	--EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@rowcount OUTPUT
	--IF isnull(@rowcount, 0) < 9
	--BEGIN
	--	set @loopcount = 9 - isnull(@rowcount, 0)
	--	WHILE (@count <= @loopcount) 
	--	BEGIN
	--		SET @SQL = 'INSERT INTO WK_原価集計表_' + @LoginID + '(SortKey) VALUES (42)'
	--		EXEC (@SQL);
	--		SET @count = @count + 1
	--	END
	--END

	--テーブル転送仕様D43--
	SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 40 OR SortKey=4100 OR SortKey=4101 OR SortKey=4102 OR SortKey=4103 OR SortKey=4104 OR SortKey=4105 OR 
			SortKey=4106 OR SortKey=4107 OR SortKey=4108 OR SortKey=4109 OR SortKey=4110 OR SortKey=4111'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@rowcount OUTPUT
	IF @rowcount > 0
		EXEC Print_Genka_ABCD @targetyear = @targetyear, @BrandCD = @BrandCD, @BrandName = @BrandName, @Season = @Season, @ProjectCD = @ProjectCD, @ProjectName = @ProjectName, @DeliveryStatus = @DeliveryStatus, @LoginID = @LoginID, @type = 'D43'
	
	--テーブル転送仕様D44--     Convert ProfitPercentage  datatype to float ErrorTask179 by syk
	SET @SQL = 'UPDATE WK_原価集計表_' + @LoginID +
				' SET Profit = ISNULL(TotalValue, 0) - (CostPre + Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12) ,
					ProfitPercentage = Round((CONVERT(DECIMAL,(TotalValue - (CostPre + Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12))) / CONVERT(DECIMAL,(CONVERT(BIGINT, TotalValue)))) * 100, 3, 0)  
				WHERE SortKey=40 OR SortKey=4100 OR SortKey=4101 OR SortKey=4102 OR SortKey=4103 OR SortKey=4104 OR SortKey=4105 OR SortKey=4106 OR SortKey=4107 OR SortKey=4108 OR SortKey=4109
				OR SortKey=4110 OR SortKey=4111'
	EXEC (@SQL);

	
	SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 10'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@a_count OUTPUT
	
	--SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey <> 10 AND SortKey <> 11 AND ((SortKey = 20 OR SortKey = 21) OR ((SortKey = 30 OR SortKey = 31 OR SortKey = 32) OR (EXISTS (SELECT * FROM WK_原価集計表_admin WHERE SortKey = 30 OR SortKey = 31 OR SortKey = 32) AND 
	--			((SortKey = 40 OR SortKey = 4100 OR SortKey = 4101 OR SortKey = 4102 OR SortKey = 4103 OR SortKey = 4104 OR SortKey = 4105 OR SortKey = 4106 OR SortKey = 4107 OR SortKey = 4108
	--			OR SortKey = 4109 OR SortKey = 4110 OR SortKey = 4111) OR SortKey = 42))))'
	SET @SQL = 'SELECT @cnt=COUNT(*) FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey <> 10 AND SortKey <> 11 AND SortKey <> 20'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@o_count OUTPUT
	
	SET @SQL = 'SELECT @cnt=COUNT(*) FROM (SELECT CostName FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 20 GROUP BY CostName, SortKey) T'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@s20_count OUTPUT
	
	SET @SQL = 'SELECT @cnt=CASE WHEN COUNT(*) - 1 > 0 THEN COUNT(*) - 1 ELSE 0 END FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 21'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@b_count OUTPUT
	
	SET @SQL = 'SELECT @cnt=CASE WHEN (SELECT COUNT(HinbanCD) FROM WK_原価集計表_' + @LoginID + ') > 0 THEN COUNT(*) + 1 ELSE 0 END FROM (SELECT DISTINCT ProjectCD FROM WK_原価集計表_' + @LoginID + ' WHERE SortKey = 30) T'
	EXECUTE sp_executesql @SQL, N'@cnt int OUTPUT', @cnt=@t_count OUTPUT

	--SET @SQL = 'SELECT wk.*,CostPre + Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12 + CostHaihu as Total, RIGHT(mc.FiscalYYYYMM, 2) as FiscalMM, 
	--		case when SortKey = 10 or Sortkey = 11 then ' + cast(@a_count as varchar) + ' else ' + cast(@o_count as varchar) + ' end as Row_Count
	--		FROM WK_原価集計表_' + @LoginID + ' wk, M_Control mc
	--		WHERE SortKey = 10 OR SortKey = 11 OR SortKey = 20 OR SortKey = 21
	--		UNION ALL
	--		SELECT DISTINCT null, null, null, null, ProjectCD, null, null, null,  null, null, null,  null, null, null,  null, null, null,  null, null, null, null, null, null, null, null, null, null,
	--			null, null, null,  null, null, null,  null, null, null,  null, null, SortKey, 0 as Total, '''' as FiscalMM, ' + cast(@o_count as varchar) + ' as Row_Count
	--		FROM WK_原価集計表_' + @LoginID +
	--		' WHERE SortKey = 30
	--		GROUP BY ProjectCD, SortKey
	--		ORDER BY SortKey, ProjectCD, HinbanCD, CostCD';
	--EXEC (@SQL);

	--SELECT DATA FOR EXCEL--
	SET @SQL= 'SELECT wk.*, RIGHT(mc.FiscalYYYYMM, 2) as FiscalMM,' + cast(@a_count + 1 as varchar) + ' as Row_Count
	FROM WK_原価集計表_' + @LoginID + ' wk, M_Control mc
	WHERE SortKey = 10
	UNION ALL
	SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CostName, SUM(CostPre), SUM(Cost1), SUM(Cost2), 
	SUM(Cost3), SUM(Cost4), SUM(Cost5), SUM(Cost6), SUM(Cost7), SUM(Cost8), SUM(Cost9), SUM(Cost10), SUM(Cost11), SUM(Cost12), SUM(CostHaihu),SUM(CostHimoku), SUM(CostShikakari), SortKey, NULL,' + cast(@a_count + 1 as varchar) + ' as Row_Count
	FROM WK_原価集計表_' + @LoginID +' wk
	WHERE SortKey = 11 GROUP BY CostName, SortKey 
	UNION ALL
	SELECT DISTINCT BrandCD, null, Season, null, null, null, null, null,  null, null, null,  null, null, null,  null, null, null,  null, null, null, null, null, null, null, null, null, null,
	null, null, null,  null, null, null,  null, null, null,  null, 0 as CostHimoku,null, SortKey, RIGHT(mc.FiscalYYYYMM, 2) as FiscalMM, ' + cast(((@o_count + @s20_count + @t_count) - @b_count) as varchar) + ' as Row_Count
	FROM WK_原価集計表_' + @LoginID + ' wk, M_Control mc 
	WHERE SortKey = 20 AND (@BrandCD IS NULL OR wk.BrandCD = @BrandCD)
	UNION ALL
	SELECT DISTINCT BrandCD, null, Season, null, null, null, null, null,  null, null, null,  null, null, null,  null, null, null,  null, null, null, null, null, null, null, null, null, null,
	null, null, null,  null, null, null,  null, null, null,  null, 0 as CostHimoku,null, 30 AS SortKey, RIGHT(mc.FiscalYYYYMM, 2) as FiscalMM, ' + cast(((@o_count + @s20_count + @t_count) - @b_count) as varchar) + ' as Row_Count
	FROM WK_原価集計表_' + @LoginID +' wk, M_Control mc 
	WHERE (SortKey = 30 OR SortKey = 40) AND
	NOT EXISTS (SELECT DISTINCT wk1.BrandCD, wk1.Season FROM WK_原価集計表_' + @LoginID +' wk1 WHERE wk1.SortKey = 20 AND wk1.BrandCD = wk.BrandCD AND wk1.Season = wk.Season)
	ORDER BY SortKey, ProjectCD, HinbanCD, CostCD';
	EXECUTE sp_executesql @SQL, N'@BrandCD varchar(10)', @BrandCD = @BrandCD

	--CLOSED BY TZA	04/06/2021
	--SET @SQL= 'SELECT wk.*, RIGHT(mc.FiscalYYYYMM, 2) as FiscalMM,' + cast(@a_count + 1 as varchar) + ' as Row_Count
	--FROM WK_原価集計表_' + @LoginID + ' wk, M_Control mc
	--WHERE SortKey = 10
	--UNION ALL
	--SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CostName, SUM(CostPre), SUM(Cost1), SUM(Cost2), 
	--SUM(Cost3), SUM(Cost4), SUM(Cost5), SUM(Cost6), SUM(Cost7), SUM(Cost8), SUM(Cost9), SUM(Cost10), SUM(Cost11), SUM(Cost12), SUM(CostHaihu),SUM(CostHimoku), SUM(CostShikakari), SortKey, NULL,' + cast(@a_count + 1 as varchar) + ' as Row_Count
	--FROM WK_原価集計表_' + @LoginID +' wk
	--WHERE SortKey = 11 GROUP BY CostName, SortKey 
	--UNION ALL
	--SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CostName, SUM(CostPre), SUM(Cost1), SUM(Cost2), 
	--SUM(Cost3), SUM(Cost4), SUM(Cost5), SUM(Cost6), SUM(Cost7), SUM(Cost8), SUM(Cost9), SUM(Cost10), SUM(Cost11), SUM(Cost12), SUM(CostHaihu),SUM(CostHimoku), SUM(CostShikakari), SortKey, RIGHT(mc.FiscalYYYYMM, 2) as FiscalMM,' + cast(((@o_count + @s20_count + @t_count) - @b_count) as varchar) + ' as Row_Count
	--FROM WK_原価集計表_' + @LoginID + ' wk, M_Control mc 
	-- WHERE SortKey = 20 GROUP BY CostName, SortKey, mc.FiscalYYYYMM
	--UNION ALL
	--SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CostName, SUM(CostPre), SUM(Cost1), SUM(Cost2), 
	--SUM(Cost3), SUM(Cost4), SUM(Cost5), SUM(Cost6), SUM(Cost7), SUM(Cost8), SUM(Cost9), SUM(Cost10), SUM(Cost11), SUM(Cost12), SUM(CostHaihu),SUM(CostHimoku), SUM(CostShikakari), SortKey, NULL,' + cast(((@o_count + @s20_count + @t_count) - @b_count) as varchar) + ' as Row_Count
	--FROM WK_原価集計表_' + @LoginID + ' wk WHERE SortKey = 21 GROUP BY CostName, SortKey
	--UNION ALL
	--SELECT DISTINCT null, null, null, null, ProjectCD, null, null, null,  null, null, null,  null, null, null,  null, null, null,  null, null, null, null, null, null, null, null, null, null,
	--null, null, null,  null, null, null,  null, null, null,  null, 0 as CostHimoku,null, SortKey, RIGHT(mc.FiscalYYYYMM, 2) as FiscalMM, ' + cast(((@o_count + @s20_count + @t_count) - @b_count) as varchar) + ' as Row_Count
	--FROM WK_原価集計表_' + @LoginID + ' wk, M_Control mc 
	-- WHERE SortKey = 30
	--ORDER BY SortKey, ProjectCD, HinbanCD, CostCD';
	--EXEC (@SQL);
	--CLOSED BY TZA 04/06/2021

	----old tz
	--SET @SQL = '
	--SELECT wk.*,CostPre + Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12 + CostHaihu as Total, RIGHT(mc.FiscalYYYYMM, 2) as FiscalMM,' + cast(@a_count + 1 as varchar) + ' as Row_Count
	--FROM WK_原価集計表_' + @LoginID + ' wk, M_Control mc
	--WHERE SortKey = 10
	--UNION ALL
	--SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CostName, SUM(CostPre), SUM(Cost1), SUM(Cost2), 
	--SUM(Cost3), SUM(Cost4), SUM(Cost5), SUM(Cost6), SUM(Cost7), SUM(Cost8), SUM(Cost9), SUM(Cost10), SUM(Cost11), SUM(Cost12), SUM(CostHaihu), SUM(CostShikakari), SortKey,
	--SUM(CostPre) + SUM(Cost1) + SUM(Cost2) + SUM(Cost3) + SUM(Cost4) + SUM(Cost5) + SUM(Cost6) + SUM(Cost7) + SUM(Cost8) + SUM(Cost9) + SUM(Cost10) + SUM(Cost11) + SUM(Cost12) + SUM(CostHaihu) as Total, NULL,' + cast(@a_count + 1 as varchar) + ' as Row_Count
	--FROM WK_原価集計表_' + @LoginID +
	--' WHERE SortKey = 11 GROUP BY CostName, SortKey 
	--UNION ALL
	--SELECT wk.*,CostPre + Cost1 + Cost2 + Cost3 + Cost4 + Cost5 + Cost6 + Cost7 + Cost8 + Cost9 + Cost10 + Cost11 + Cost12 + CostHaihu as Total, RIGHT(mc.FiscalYYYYMM, 2) as FiscalMM,' + cast(((@o_count + @t_count) - @b_count) as varchar) + ' as Row_Count
	--FROM WK_原価集計表_' + @LoginID + ' wk, M_Control mc 
	-- WHERE SortKey = 20
	--UNION ALL
	--SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, CostName, SUM(CostPre), SUM(Cost1), SUM(Cost2), 
	--SUM(Cost3), SUM(Cost4), SUM(Cost5), SUM(Cost6), SUM(Cost7), SUM(Cost8), SUM(Cost9), SUM(Cost10), SUM(Cost11), SUM(Cost12), SUM(CostHaihu), SUM(CostShikakari), SortKey,
	--SUM(CostPre) + SUM(Cost1) + SUM(Cost2) + SUM(Cost3) + SUM(Cost4) + SUM(Cost5) + SUM(Cost6) + SUM(Cost7) + SUM(Cost8) + SUM(Cost9) + SUM(Cost10) + SUM(Cost11) + SUM(Cost12) + SUM(CostHaihu) as Total, NULL,' + cast(((@o_count + @t_count) - @b_count) as varchar) + ' as Row_Count
	--FROM WK_原価集計表_' + @LoginID + 
	--' WHERE SortKey = 21 GROUP BY CostName, SortKey
	--UNION ALL
	--SELECT DISTINCT null, null, null, null, ProjectCD, null, null, null,  null, null, null,  null, null, null,  null, null, null,  null, null, null, null, null, null, null, null, null, null,
	--null, null, null,  null, null, null,  null, null, null,  null, null, SortKey, 0 as Total, RIGHT(mc.FiscalYYYYMM, 2) as FiscalMM, ' + cast(((@o_count + @t_count) - @b_count) as varchar) + ' as Row_Count
	--FROM WK_原価集計表_' + @LoginID + ' wk, M_Control mc 
	-- WHERE SortKey = 30
	--ORDER BY SortKey, ProjectCD, HinbanCD, CostCD';
	

END
