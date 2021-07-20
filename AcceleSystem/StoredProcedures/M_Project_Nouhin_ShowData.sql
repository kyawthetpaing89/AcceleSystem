 BEGIN TRY 
 Drop Procedure dbo.[M_Project_Nouhin_ShowData]
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
CREATE PROCEDURE [dbo].[M_Project_Nouhin_ShowData]
	-- Add the parameters for the stored procedure here
	@ProjectCD as varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		prj.ProjectCD,
		prj.ProjectName,
		prj.BrandCD,
		br.BrandName,
		prj.[Year],
		prj.Season
	From M_Project prj 
	LEFT OUTER JOIN M_Brand br on br.BrandCD = prj.BrandCD
	WHERE prj.ProjectCD = @ProjectCD
END
