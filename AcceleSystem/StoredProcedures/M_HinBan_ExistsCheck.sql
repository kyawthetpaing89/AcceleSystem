 BEGIN TRY 
 Drop Procedure dbo.[M_HinBan_ExistsCheck]
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
CREATE PROCEDURE [dbo].[M_HinBan_ExistsCheck]
	-- Add the parameters for the stored procedure here
	@HinbanCD as varchar(6) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(select 1 from M_Hinban
				where HinbanCD = @HinbanCD)
		begin
			select mm.*,mh.* from M_Message mm ,M_Hinban mh
			where MessageID = 'E107'
			and HinbanCD = @HinbanCD			
		end
	else
		begin
			select * from M_Message
			where MessageID = 'E101'	
		end
END
