 BEGIN TRY 
 Drop Procedure dbo.[M_User_Select]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<ThawThaw>
-- Create date: <8.7.2020>
-- Description:	<M_User_Select>
-- =============================================
CREATE PROCEDURE [dbo].[M_User_Select] 
	-- Add the parameters for the stored procedure here
	@ID as varchar(20) = null,
	@UserName as varchar(40) = null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * 
	FROM M_User
	WHERE ID = CASE WHEN @ID is null THEN ID ELSE @ID END
	AND (@UserName IS NULL OR (UserName LIKE '%' + @UserName + '%'))
	ORDER BY ID
		
END
