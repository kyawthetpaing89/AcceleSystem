 BEGIN TRY 
 Drop Procedure dbo.[M_Contrl_YearMonth_ExitCheck]
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
CREATE PROCEDURE [dbo].[M_Contrl_YearMonth_ExitCheck]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	--if not exists(select 1 from M_Control
	--			where MainKey = 1)
	--	begin
	--		select * from M_Message
	--		where MessageID = 'E101'
	--	end
	if exists(select 1 from M_Control
				where MainKey = 1)
		begin
			select mm.*,mc.* ,
			CONVERT(varchar(7),Replace(CONVERT(date, (CONVERT(varchar(10), mc.FiscalYYYYMM)) + '01', 101),'-','/')) AS FYearMonth
			from M_Message mm ,M_Control mc
			where MessageID = 'E107'
			and MainKey = 1			
		end
	else
		begin
			select * from M_Message
			where MessageID = 'E101'	
		end
END


