 BEGIN TRY 
 Drop Procedure dbo.[D_Delivery_Search]
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
CREATE PROCEDURE [dbo].[D_Delivery_Search]
	-- Add the parameters for the stored procedure here
	@Year as int,
	@BrandCD as varchar(6),
	@BrandName as varchar(40),
	@Season as varchar(5),
	@ProjectCD as varchar(15),
	@ProjectName as varchar(60),
	@HinbanCD as varchar(6),
	@HinbanName as varchar(60),
	@DeliveryStartDate as date,
	@DeliveryEndDate as date,
	@DeliveryStatus as varchar(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF(@DeliveryStatus = '1')
	BEGIN
		SELECT
		del.SEQ AS [SEQ],
		Case when del.DeliveryDate IS NULL Then '' Else CONVERT(varchar(10),del.DeliveryDate,111) End AS [DeliveryDate],
		Case when proj.BrandCD IS NULL Then '' Else proj.BrandCD End as [BrandCD],
		Case when brand.BrandName IS NULL Then '' Else brand.BrandName end as [BrandName],
		Case 
			when proj.Season = 1 then '通年'
			when proj.Season = 2 then 'SS'
			Else 'FW' End As [Season],
		Case when proj.[Year] IS NULL Then '' Else proj.[Year] End as [Year],
		Case when del.ProjectCD IS NULL Then '' Else del.ProjectCD End as [ProjectCD],
		Case when proj.ProjectName IS NULL Then '' Else proj.ProjectName End as [ProjectName],
		Case when del.HinbanCD IS NULL THen '' Else del.HinbanCD End as [HinbanCD],
		Case when hin.HinbanName IS NULL Then '' Else hin.HinbanName End as [HinbanName],
		REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(hin.Production,0)), 1), '.00', '')  as [Production],
		REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(del.DeliveryAmount,0)), 1), '.00', '')  as [DeliveryAmount]
		--'999,999,999' as [Production],
		--'999,999,999' as [DeliveryAmount]
		FROM D_Delivery del 
		left outer JOIN M_Project proj on del.ProjectCD = proj.ProjectCD
		left outer JOIN M_Brand brand on proj.BrandCD = brand.BrandCD
		left outer JOIN M_Hinban hin on del.ProjectCD = hin.ProjectCD AND del.HinbanCD = hin.HinbanCD
		INNER JOIN (
			SELECT ProjectCD,HinbanCD,SUM(DeliveryAmount) AS DeliveryAmount  
			from D_Delivery 
			GROUP BY ProjectCD,HinbanCD
		) As d on d.ProjectCD = del.ProjectCD and d.HinbanCD =  del.HinbanCD
		WHERE(@Year IS NULL OR (proj.[Year] =  @Year))
		AND (@BrandCD IS NULL OR (proj.BrandCD = @BrandCD))
		AND (@BrandName IS NULL OR (BrandName LIKE '%' + @BrandName + '%'))
		AND (@Season is null or (proj.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1))))
		AND (@ProjectCD IS NULL OR (del.ProjectCD =  @ProjectCD))
		AND (@ProjectName IS NULL OR (proj.ProjectName LIKE '%' + @ProjectName + '%'))
		AND (@HinbanCD IS NULL OR (del.HInbanCD =  @HinbanCD))
		AND (@HinbanName IS NULL OR (hin.HinbanName LIKE '%' + @HinbanName + '%'))
		AND (@DeliveryStartDate IS NULL OR (del.DeliveryDate >=  @DeliveryStartDate))
		AND (@DeliveryEndDate IS NULL OR (del.DeliveryDate <= @DeliveryEndDate))
		AND (d.DeliveryAmount < hin.Production)
	END
	ELSE IF(@DeliveryStatus = '2')
		BEGIN
			SELECT
			del.SEQ AS [SEQ],
			Case when del.DeliveryDate IS NULL Then '' Else CONVERT(varchar(10),del.DeliveryDate,111) End AS [DeliveryDate],
			Case when proj.BrandCD IS NULL Then '' Else proj.BrandCD End as [BrandCD],
			Case when brand.BrandName IS NULL Then '' Else brand.BrandName End as [BrandName],
			Case 
				when proj.Season = 1 then '通年'
				when proj.Season = 2 then 'SS'
				Else 'FW' End As [Season],
			Case when proj.[Year] IS NULL Then '' Else proj.[Year] End as [Year],
			Case when del.ProjectCD IS NULL Then '' Else del.ProjectCD End as [ProjectCD],
			Case when proj.ProjectName IS NULL Then '' Else proj.ProjectName End as [ProjectName],
			Case when del.HinbanCD IS NULL Then '' Else del.HinbanCD End as [HinbanCD],
			Case when hin.HinbanName IS NULL THen '' Else hin.HinbanName End as [HinbanName],
			REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(hin.Production,0)), 1), '.00', '')  as [Production],
			REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(del.DeliveryAmount,0)), 1), '.00', '')  as [DeliveryAmount]
			FROM D_Delivery del 
			left outer JOIN M_Project proj on del.ProjectCD = proj.ProjectCD
			left outer JOIN M_Brand brand on proj.BrandCD = brand.BrandCD
			left outer JOIN M_Hinban hin on del.ProjectCD = hin.ProjectCD AND del.HinbanCD = hin.HinbanCD
			INNER JOIN (
				SELECT ProjectCD,HinbanCD,SUM(DeliveryAmount) AS DeliveryAmount  
				from D_Delivery 
				GROUP BY ProjectCD,HinbanCD
			) As d on d.ProjectCD = del.ProjectCD and d.HinbanCD =  del.HinbanCD
			WHERE (@Year IS NULL OR (proj.[Year] =  @Year))
			AND (@BrandCD IS NULL OR (proj.BrandCD = @BrandCD))
			AND (@BrandName IS NULL OR (BrandName LIKE '%' + @BrandName + '%'))
			AND (@Season is null or (proj.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1))))
			AND (@ProjectCD IS NULL OR (del.ProjectCD =  @ProjectCD))
			AND (@ProjectName IS NULL OR (proj.ProjectName LIKE '%' + @ProjectName + '%'))
			AND (@HinbanCD IS NULL OR (del.HInbanCD =  @HinbanCD))
			AND (@HinbanName IS NULL OR (hin.HinbanName LIKE '%' + @HinbanName + '%'))
			AND (@DeliveryStartDate IS NULL OR (del.DeliveryDate >=  @DeliveryStartDate))
			AND (@DeliveryEndDate IS NULL OR (del.DeliveryDate <= @DeliveryEndDate))
			AND (d.DeliveryAmount = hin.Production)
		END
		ELSE
			BEGIN
				SELECT
				del.SEQ AS [SEQ],
				Case when del.DeliveryDate IS NULL Then '' Else CONVERT(varchar(10),del.DeliveryDate,111) End AS [DeliveryDate],
				Case when proj.BrandCD IS NULL Then '' Else proj.BrandCD End as [BrandCD],
				Case when brand.BrandName IS NULL Then '' Else brand.BrandName End as [BrandName],
				Case 
					when proj.Season = 1 then '通年'
					when proj.Season = 2 then 'SS'
					Else 'FW' End As [Season],
				Case when proj.[Year] IS NULL Then '' Else proj.[Year] End as [Year],
				Case when del.ProjectCD IS NULL Then '' Else del.ProjectCD End as [ProjectCD],
				Case when proj.ProjectName IS NULL Then '' Else proj.ProjectName End as [ProjectName],
				Case when del.HinbanCD IS NULL Then '' Else del.HinbanCD End as [HinbanCD],
				Case when hin.HinbanName IS NULL THen '' Else hin.HinbanName End as [HinbanName],
				REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(hin.Production,0)), 1), '.00', '')  as [Production],
				REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(del.DeliveryAmount,0)), 1), '.00', '')  as [DeliveryAmount]
				FROM D_Delivery del 
				left outer JOIN M_Project proj on del.ProjectCD = proj.ProjectCD
				left outer JOIN M_Brand brand on proj.BrandCD = brand.BrandCD
				left outer JOIN M_Hinban hin on del.ProjectCD = hin.ProjectCD AND del.HinbanCD = hin.HinbanCD
				INNER JOIN (
					SELECT ProjectCD,HinbanCD,SUM(DeliveryAmount) AS DeliveryAmount  
					from D_Delivery 
					GROUP BY ProjectCD,HinbanCD
				) As d on d.ProjectCD = del.ProjectCD and d.HinbanCD =  del.HinbanCD
				WHERE (@Year IS NULL OR (proj.[Year] =  @Year))
				AND (@BrandCD IS NULL OR (proj.BrandCD = @BrandCD))
				AND (@BrandName IS NULL OR (BrandName LIKE '%' + @BrandName + '%'))
				AND (@Season is null or (proj.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1))))
				AND (@ProjectCD IS NULL OR (del.ProjectCD =  @ProjectCD))
				AND (@ProjectName IS NULL OR (proj.ProjectName LIKE '%' + @ProjectName + '%'))
				AND (@HinbanCD IS NULL OR (del.HInbanCD =  @HinbanCD))
				AND (@HinbanName IS NULL OR (hin.HinbanName LIKE '%' + @HinbanName + '%'))
				AND (@DeliveryStartDate IS NULL OR (del.DeliveryDate >=  @DeliveryStartDate))
				AND (@DeliveryEndDate IS NULL OR (del.DeliveryDate <= @DeliveryEndDate))
			END
END
