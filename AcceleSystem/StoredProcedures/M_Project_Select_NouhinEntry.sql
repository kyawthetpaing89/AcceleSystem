 BEGIN TRY 
 Drop Procedure dbo.[M_Project_Select_NouhinEntry]
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
CREATE PROCEDURE [dbo].[M_Project_Select_NouhinEntry]
	-- Add the parameters for the stored procedure here
	@ProjectCD varchar(15),
	@Mode varchar(6)
	--@DeliveryDate varchar(10)
	--@DeliverAmount int --AmountfromList
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @Mode = 'New'
	BEGIN
		select 
			prj.ProjectCD AS 'ProjectCD',
			prj.ProjectName AS 'ProjectName',
			prj.[Year] AS 'Year',
			prj.BrandCD AS 'BrandCD',
			br.BrandName AS 'BrandName',
			prj.Season AS 'Season',
			null AS 'DeliveryDate',
			null AS 'Remarks',
			
			'false' AS 'checkval',
			Case when hin.HinbanCD IS NULL Then '' Else hin.HinbanCD End AS 'HinbanCD',
			Case when hin.HinbanName IS NULL Then '' Else hin.HinbanName End AS 'HinbanName',
			REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(hin.Production,0)), 1), '.00', '')  AS 'Production',
			REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(del1.DeliveryAmount,0)), 1), '.00', '')  AS 'SumDeliveryAmount',
			0 AS 'DeliverAmount',
			REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(hin.Production,0) - ISNULL(del1.DeliveryAmount,0)), 1), '.00', '')  AS 'UNDeliverItems'
		FROM M_Hinban hin
		left outer join M_Project prj on prj.ProjectCD = hin.ProjectCD
		left outer JOIN (SELECT ProjectCD,HinbanCD,SUM(DeliveryAmount) AS DeliveryAmount  
					from D_Delivery 
					GROUP BY ProjectCD,HinbanCD) AS del1 on del1.ProjectCD = hin.ProjectCD and del1.HinbanCD = hin.HinbanCD and prj.ProjectCD = del1.ProjectCD 
		left outer join M_Brand br on br.BrandCD = prj.BrandCD
		--left outer join D_Delivery del on prj.ProjectCD = del.ProjectCD 
		--left outer join M_Hinban hin on prj.ProjectCD = hin.ProjectCD --AND del.HinbanCD = hin.HinbanCD
		--left outer join M_Brand br on br.BrandCD = prj.BrandCD
		WHERE (@ProjectCD IS NULL OR (prj.ProjectCD = @ProjectCD))
		ORDER BY hin.HinbanCD
	END
	ELSE
	BEGIN
		select 
			del.SEQ,
			del.ProjectCD AS 'ProjectCD',
			prj.ProjectName AS 'ProjectName',
			prj.[Year] AS 'Year',
			prj.BrandCD AS 'BrandCD',
			br.BrandName AS 'BrandName',
			prj.Season AS 'Season',
			CONVERT(varchar(10),del.DeliveryDate,111) AS 'DeliveryDate',
			del.Remarks AS 'Remarks',
			
			'false' AS 'checkval',
			Case When hin.HinbanCD IS NULL Then '' Else hin.HinbanCD End AS 'HinbanCD',
			Case When hin.HinbanName IS NULL THen '' Else hin.HinbanName End AS 'HinbanName',
			REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(hin.Production,0)), 1), '.00', '')  AS 'Production',
			REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(del1.DeliveryAmount,0)), 1), '.00', '')  AS 'SumDeliveryAmount',
			REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(del.DeliveryAmount,0)), 1), '.00', '')  AS 'DeliverAmount',
			REPLACE(CONVERT(VARCHAR, CONVERT(MONEY,ISNULL(hin.Production,0) - ISNULL(del1.DeliveryAmount,0)), 1), '.00', '')  AS 'UNDeliverItems'
		FROM M_Hinban hin
		left outer join M_Project prj on prj.ProjectCD = hin.ProjectCD
		left outer join D_Delivery del on hin.ProjectCD = del.ProjectCD and hin.HinbanCD = del.HinbanCD and prj.ProjectCD = del.ProjectCD
		left outer JOIN (SELECT ProjectCD,HinbanCD,SUM(DeliveryAmount) AS DeliveryAmount  
					from D_Delivery 
					GROUP BY ProjectCD,HinbanCD) AS del1 on del1.ProjectCD = prj.ProjectCD and del1.HinbanCD = hin.HinbanCD and prj.ProjectCD = del1.ProjectCD
		left outer join M_Brand br on br.BrandCD = prj.BrandCD
		--FROM M_Project prj 
		--left outer join D_Delivery del on prj.ProjectCD = del.ProjectCD
		--left outer join M_Hinban hin on prj.ProjectCD = hin.ProjectCD AND del.HinbanCD = hin.HinbanCD
		--left outer join M_Brand br on br.BrandCD = prj.BrandCD
		--left outer JOIN (SELECT ProjectCD,HinbanCD,SUM(DeliveryAmount) AS DeliveryAmount  
		--			from D_Delivery 
		--			GROUP BY ProjectCD,HinbanCD) AS del1 on del1.ProjectCD = prj.ProjectCD and del1.HinbanCD = hin.HinbanCD
		WHERE (@ProjectCD IS NULL OR (del.ProjectCD = @ProjectCD))
		--AND del.DeliveryDate = @DeliveryDate
		ORDER BY hin.HinbanCD
	END
END
