 BEGIN TRY 
 Drop Procedure dbo.[M_HinBan_Select_List]
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
CREATE PROCEDURE [dbo].[M_HinBan_Select_List]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	  Case when mp.ProjectCD IS NULL Then '' Else mp.ProjectCD End AS ProjectCD
	 ,Case when mh.HinbanCD IS NULL THen '' Else mh.HinbanCD End AS HinbanCD
	 ,Case when mh.HinbanName IS NULL Then '' Else mh.HinbanName End AS HinbanName
	 ,Case When mh.Casting IS NULL Then '' Else mh.Casting End AS Casting
	
	 ,Case When mh.Production IS NULL Then '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, mh.Production), 1), '.00', '') End as Production
	 ,Case When mh.SalesPrice IS NULL THen '0' Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, mh.SalesPrice), 1), '.00', '') End as SalesPrice
	 ,Case When sum(CONVERT(bigint,mh.Production) * CONVERT(money,mh.SalesPrice)) IS NULL THen '0' 
	 Else REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, sum(CONVERT(bigint,mh.Production) * CONVERT(money,mh.SalesPrice))), 1), '.00', '') End as TotalSalesPrice
	
	FROM M_Hinban mh
	--Left outer join M_Project mp 
	inner join M_Project mp 
	on mp.ProjectCD = mh.ProjectCD 
	group by  mp.ProjectCD , mh.HinbanCD,mh.HinbanName,mh.Casting,mh.Production,mh.SalesPrice
END

