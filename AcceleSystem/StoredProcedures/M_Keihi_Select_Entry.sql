 BEGIN TRY 
 Drop Procedure dbo.[M_Keihi_Select_Entry]
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
CREATE PROCEDURE [dbo].[M_Keihi_Select_Entry] 
	-- Add the parameters for the stored procedure here
	@CostCD as varchar(6) = null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * 
	FROM M_Keihi ke 
	LEFT OUTER JOIN M_Kanjo ka on ke.KanjoCD = ka.KanjoCD
	LEFT OUTER JOIN M_Hojo ho on ho.KanjoCD= ke.KanjoCD and ho.HojoCD = ke.HojoCD
	WHERE CostCD = CASE WHEN @CostCD is null THEN CostCD ELSE @CostCD END
	ORDER BY CostCD 
		
END
