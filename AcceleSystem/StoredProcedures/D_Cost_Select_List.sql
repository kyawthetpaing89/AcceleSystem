 BEGIN TRY 
 Drop Procedure dbo.[D_Cost_Select_List]
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
CREATE PROCEDURE [dbo].[D_Cost_Select_List]
	-- Add the parameters for the stored procedure here
	@CostCD as int,
	@CostName as varchar(40),
	@CostDateFrom as date,
	@CostDateTo as date,
	@BrandCD as varchar(6),
	@BrandName as varchar(40),
	@Season as varchar(5),
	@Year as int,
	@ProjectCD as varchar(15),
	@ProjectName as varchar(60),
	@HinbanCD as varchar(6),
	@HinbanName as varchar(60)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	dc.SEQ,
	ISNULL(CONVERT(Varchar,dc.CostCD),'')  AS CostCD,
	Case When mk.CostName IS NULL Then '' Else mk.CostName End AS CostName,
	Case When dc.CostDate IS NULL Then '' Else CONVERT(varchar(10),dc.CostDate,111) End AS CostDate,
	Case When dc.BrandCD IS NULL OR dc.BrandCD = '@@@' Then '' Else dc.BrandCD End AS BrandCD,
	Case When mb.BrandName IS NULL Then '' Else mb.BrandName End AS BrandName,
	Case when mk.Accounting = 1 or mk.Accounting = 3 then
		Case 
			when mp.Season = 1 then '通年'
			when mp.Season = 2 then 'SS'
			When mp.Season = 3 then 'FW' 
			Else '' End 
		when mk.Accounting = 2 then
		Case 
			when dc.Season = 1 then '通年'
			when dc.Season = 2 then 'SS'
			When dc.Season = 3 then 'FW' 
			Else '' End
	ELSE ''
	END AS  'Season',
	--Case 
	--	when dc.Season = 1 then '通年'
	--	when dc.Season = 2 then 'SS'
	--	When dc.Season = 3 then 'FW' 
	--	Else '' End As 'Season',
	--Case When dc.[Year] = 0 OR dc.[Year] IS NULL Then '' Else CAST(dc.[Year] AS varchar(4)) End AS [Year],
	CAST(dc.[Year] AS varchar(4)) AS [Year],
	Case When dc.ProjectCD IS NULL OR dc.ProjectCD = '@@@' Then '' Else dc.ProjectCD End AS ProjectCD,
	Case When mp.ProjectName IS NULL Then '' Else mp.ProjectName End AS ProjectName,
	Case When dc.HinbanCD IS NULL OR dc.HinbanCD = '@@@' Then '' Else dc.HinbanCD End AS HinbanCD,
	Case When mh.HinbanName IS NULL Then '' Else mh.HinbanName End AS HinbanName
	From D_Cost dc 
	left outer join M_Keihi mk on mk.CostCD = dc.CostCD 
	left outer join M_Brand mb on mb.BrandCD = dc.BrandCD
	left outer join M_Project mp on mp.ProjectCD = dc.ProjectCD
	left outer join M_Hinban mh on mh.HinbanCD = dc.HinbanCD and mh.ProjectCD = dc.ProjectCD
	Where (@CostCD is null or dc.CostCD = @CostCD) 
	and (@CostName is null or mk.CostName  Like '%'+  @CostName + '%') 
	and (@CostDateFrom is null or dc.CostDate >= @CostDateFrom) 
	and (@CostDateTo is null or dc.CostDate <= @CostDateTo)
	and (@Year is null or dc.[Year] = @Year or mp.[Year] = @Year) 
	and (@BrandCD is null or dc.BrandCD = @BrandCD or mp.BrandCD = @BrandCD)
	and (@BrandName is null or mb.BrandName Like '%'+ @BrandName + '%')
	--and (@Season is null or (dc.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1)) or dc.Season IS NULL or dc.Season = 9))
	and (((mk.Accounting =1 or mk.Accounting =3) and (@Season is null or mp.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1) ) OR  mp.Season IS NULL OR  dc.Season = 9))
	OR ((mk.Accounting =2) and (@Season is null or  dc.Season IN (SUBSTRING(@Season,1,1),SUBSTRING(@Season,3,1),SUBSTRING(@Season,5,1))OR dc.Season IS NULL OR dc.Season = 9) )
	OR (mk.Accounting =4 or mk.Accounting =5))
	and (@ProjectCD is null or dc.ProjectCD = @ProjectCD)
	and (@ProjectName is null or mp.ProjectName Like '%' + @ProjectName + '%')
	and (@HinbanCD is null or dc.HinbanCD = @HinbanCD) 
	and (@HinbanName is null or mh.HinbanName Like '%' + @HinbanName + '%')
	Order by dc.CostCD,dc.CostDate,dc.BrandCD,dc.Season,dc.ProjectCD,dc.HinbanCD


END


