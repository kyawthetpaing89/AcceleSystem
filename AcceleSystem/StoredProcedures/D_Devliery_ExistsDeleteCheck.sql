 BEGIN TRY 
 Drop Procedure dbo.[D_Devliery_ExistsDeleteCheck]
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
CREATE PROCEDURE [dbo].[D_Devliery_ExistsDeleteCheck]
	-- Add the parameters for the stored procedure here
	@HinbanCD as varchar(6),
	@ProjectCD as varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(select 1 from D_Delivery
				where (@HinbanCD IS NULL OR (HinbanCD = @HinbanCD))
				and ProjectCD=@ProjectCD)
		BEGIN
			select mm.* from M_Message mm, D_Delivery dd
				where MessageID = 'E126' 
				AND (@HinbanCD IS NULL OR(dd.HinbanCD = @HinbanCD))
				AND dd.ProjectCD =@ProjectCD
	   END 
	   
	   else
		begin
			select * from M_Message
			where MessageID = 'E101'	
		end
	
END
