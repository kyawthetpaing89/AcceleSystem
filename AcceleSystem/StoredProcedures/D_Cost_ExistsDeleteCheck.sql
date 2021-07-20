 BEGIN TRY 
 Drop Procedure dbo.[D_Cost_ExistsDeleteCheck]
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
CREATE PROCEDURE [dbo].[D_Cost_ExistsDeleteCheck]
	-- Add the parameters for the stored procedure here
	@HinbanCD as varchar(6),
	@ProjectCD as varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(select 1 from D_Cost
				where (@HinbanCD IS NULL OR (HinbanCD = @HinbanCD))
				And ProjectCD=@ProjectCD)
		BEGIN
			select mm.* from M_Message mm, D_Cost dc
				where MessageID = 'E119' 
				AND (@HinbanCD IS NULL OR(dc.HinbanCD = @HinbanCD))
				AND dc.ProjectCD =@ProjectCD
	   END 
	   else
		begin
			select * from M_Message
			where MessageID = 'E101'	
		end
END
