 BEGIN TRY 
 Drop Procedure dbo.[M_Hinban_ProjectExistCheck]
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
CREATE PROCEDURE [dbo].[M_Hinban_ProjectExistCheck]
	-- Add the parameters for the stored procedure here
	@ProjectCD varchar(15),
	@HinbanCD varchar(6)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	if exists(select 1 from M_Hinban 
	where (@ProjectCD IS NULL OR( ProjectCD = @ProjectCD)) and HinbanCD = @HinbanCD )
		begin
			select mm.*,mh.* from M_Message mm ,M_Hinban mh
			where mm.MessageID = 'E107'
			and (@ProjectCD IS NULL OR(mh.ProjectCD = @ProjectCD)) and mh.HinbanCD = @HinbanCD 


		
		end
		else
		begin
			select * from M_Message
			where MessageID = 'E101'	
		end
	
END



