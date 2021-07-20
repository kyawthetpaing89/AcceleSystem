 BEGIN TRY 
 Drop Procedure dbo.[M_Hojo_ExistsCheck]
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
CREATE PROCEDURE [dbo].[M_Hojo_ExistsCheck] 
	-- Add the parameters for the stored procedure here
	@HojoCD as varchar(6),
	@KanjoCD as varchar(6)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(select 1 from M_Hojo
				where (@HojoCD IS NULL OR( HojoCD = @HojoCD)) and KanjoCD = @KanjoCD)
		begin
			select mm.*,mh.* from M_Message mm ,M_Hojo mh
			where MessageID = 'E107'
			and KanjoCD = @KanjoCD
			and HojoCD = @HojoCD
			
		end
	else
		begin
			select * from M_Message
			where MessageID = 'E101'
		end
END
