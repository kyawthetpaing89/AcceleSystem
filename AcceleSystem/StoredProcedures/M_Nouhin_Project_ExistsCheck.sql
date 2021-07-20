 BEGIN TRY 
 Drop Procedure dbo.[M_Nouhin_Project_ExistsCheck]
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
CREATE PROCEDURE [dbo].[M_Nouhin_Project_ExistsCheck]
	-- Add the parameters for the stored procedure here
	@ProjectCD as varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(select 1 from M_Hinban H left outer join M_Project P on P.ProjectCD = H.ProjectCD
				where P.ProjectCD  = @ProjectCD )
		begin
			select mm.*,mc.* from M_Message mm ,M_Project  mc
			where MessageID = 'E107'
			and ProjectCD  = @ProjectCD
			
		end
	else
		begin
			select * from M_Message
			where MessageID = 'E101'
		end
END
