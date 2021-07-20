 BEGIN TRY 
 Drop Procedure dbo.[M_Casting_Select]
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
CREATE PROCEDURE [dbo].[M_Casting_Select]
	-- Add the parameters for the stored procedure here
	@CastingCD as varchar(10),
	@CastingName as varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select mc.CastingCD,mc.CastingName,mc.BrandCD,convert(varchar, mc.UseLimit, 111) as UseLimit,mb.BrandName From M_Casting mc 
	Left Outer Join M_Brand mb on mb.BrandCD = mc.BrandCD
	Where (@CastingCD is null or(CastingCD= @CastingCD))
	And (@CastingName is null or(CastingName LIKE '%' + @CastingName + '%'))
END
