 BEGIN TRY 
 Drop Procedure dbo.[M_Brand_Select]
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
CREATE PROCEDURE [dbo].[M_Brand_Select] 
	-- Add the parameters for the stored procedure here
		@BrandCD as varchar(20) = null,
		@BrandName as varchar(40) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Insert statements for procedure here
	SELECT * from M_Brand
	where BrandCD = case when @BrandCD is null then BrandCD else @BrandCD end
	and (@BrandName is null or(BrandName LIKE '%' + @BrandName + '%'))
	ORDER BY BrandCD	
END

