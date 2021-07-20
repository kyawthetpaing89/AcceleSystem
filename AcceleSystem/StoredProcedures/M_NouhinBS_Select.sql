 BEGIN TRY 
 Drop Procedure dbo.[M_NouhinBS_Select]
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
CREATE PROCEDURE [dbo].[M_NouhinBS_Select]
	-- Add the parameters for the stored procedure here
	@Year int,
	@BrandCD varchar(6),
	@Season tinyint,
	@PeriodStart int,
	@PeriodEnd int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		 'false' AS [checkval]
		,Case when prj.ProjectCD IS NULL Then '' Else prj.ProjectCD End AS [ProjectCD]
		,Case when prj.ProjectName IS NULL THen '' Else prj.ProjectName End AS [ProjectName]
		,Case When hin.HinbanCD IS NULL Then '' Else hin.HinbanCD End AS [HinbanCD]
		,Case When hin.HinbanName IS NULL Then '' Else hin.HinbanName End AS [HinbanName]
		,REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(hin.Production,0)), 1), '.00', '')  AS [Production]
		,REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(dd.DeliveryAmount,0)), 1), '.00', '')  AS [DeliveryAmount]
		,REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(hin.Production,0) - ISNULL(dd.DeliveryAmount,0)), 1), '.00', '')  AS [DeliverTimes]
		,REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(hin.Production,0) - ISNULL(dd.DeliveryAmount,0) -(ISNULL(hin.Production,0) - ISNULL(dd.DeliveryAmount,0))), 1), '.00', '')  AS [UNDeliverTimes]
	FROM M_Hinban hin
	left outer join M_Project prj on prj.ProjectCD = hin.ProjectCD
	left outer join (select ProjectCD,
							HinbanCD,
							SUM(DeliveryAmount) AS DeliveryAmount 
					from D_Delivery group by ProjectCD,HinbanCD) AS [dd] 
					on hin.ProjectCD = dd.ProjectCD and hin.HinbanCD = dd.HinbanCD
	left outer join M_Brand br on br.BrandCD = prj.BrandCD
	--FROM M_Project [prj]
	----left outer join D_Delivery [del] on del.ProjectCD = [prj].ProjectCD
	--left outer join  M_Hinban [hin] on hin.ProjectCD = [prj].ProjectCD --and [hin].HinbanCD = [del].HinbanCD
	--left outer join M_Brand br on br.BrandCD = prj.BrandCD
	--left outer join (select ProjectCD,
	--						HinbanCD,
	--						SUM(DeliveryAmount) AS DeliveryAmount 
	--				from D_Delivery group by ProjectCD,HinbanCD) AS [dd] 
	--				on [dd].ProjectCD = [prj].ProjectCD and [dd].HinbanCD = [hin].HinbanCD
	WHERE 
		(@Year IS NULL OR(prj.[Year] =  @Year))
		AND (@BrandCD IS NULL OR(prj.BrandCD = @BrandCD))
		AND (@Season IS NULL OR (prj.Season = @Season))
		AND ((@PeriodEnd is null or prj.PeriodStart <= @PeriodEnd) AND (@PeriodStart is null or prj.PeriodEnd >= @PeriodStart))
		--AND (@PeriodStart IS NULL OR (prj.PeriodStart >= @PeriodStart))
		--AND (@PeriodEnd IS NULL OR (prj.PeriodEnd <= @PeriodEnd))
		AND hin.Production > ISNULL(dd.DeliveryAmount,0)
	ORDER BY 
		prj.ProjectCD,
		hin.HinbanCD
END

