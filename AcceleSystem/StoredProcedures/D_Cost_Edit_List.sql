 BEGIN TRY 
 Drop Procedure dbo.[D_Cost_Edit_List]
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
CREATE PROCEDURE [dbo].[D_Cost_Edit_List]
	-- Add the parameters for the stored procedure here
	@SEQ as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT dc.SEQ,
	mk.Accounting,
	dc.CostCD AS CostCD,
	mk.CostName,
	CONVERT(varchar(10),dc.CostDate,111) AS CostDate,
	Case when dc.[Year] IS NULL Then '' Else dc.[Year] End AS 'Year',
	Case when dc.BrandCD IS NULL OR dc.BrandCD = '@@@' Then '' ELse dc.BrandCD End AS 'BrandCD',
	mb.BrandName,
	Case when mk.Accounting = 1 or mk.Accounting = 3 then mp.Season	
		 when mk.Accounting = 2 then dc.Season
		 Else '' 
	End AS Season,
	Case When dc.ProjectCD IS NULL OR dc.ProjectCD = '@@@' THen '' Else dc.ProjectCD End AS 'ProjectCD',
	mp.ProjectName,
	Case When dc.HinbanCD IS NULL OR dc.HinbanCD = '@@@' Then '' Else  dc.HinbanCD End As 'HinbanCD' ,
	mh.HinbanName,
	Case When dc.CastingCD IS NULL OR dc.CastingCD = '@@@' Then '' Else dc.CastingCD End AS 'CastingCD',
	mc.CastingName,
	Case When dc.FreeItem1 IS NULL OR dc.FreeItem1 = '@@@' THen '' Else dc.FreeItem1 End AS 'FreeItem1', 
	dc.ZeikomiKBN,
	FORMAT((Convert(int,dc.CostAmount)),'#,##') AS CostAmount,
	FORMAT((Convert(int,dc.InputAmount)),'#,##') AS InputAmount,
	dc.Remarks
	From D_Cost dc 
	left outer join M_Keihi mk on mk.CostCD = dc.CostCD 
	left outer join M_Brand mb on mb.BrandCD = dc.BrandCD
	left outer join M_Project mp on mp.ProjectCD = dc.ProjectCD
	left outer join M_Hinban mh on mh.ProjectCD = dc.ProjectCD and mh.HinbanCD = dc.HinbanCD 
	left outer join M_Casting mc on mc.CastingCD = dc.CastingCD
	Where dc.SEQ = @SEQ
END
