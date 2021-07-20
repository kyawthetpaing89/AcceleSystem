 BEGIN TRY 
 Drop Procedure dbo.[M_Control_FiscalCheck]
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
CREATE PROCEDURE [dbo].[M_Control_FiscalCheck] 
	-- Add the parameters for the stored procedure here
	@CastDate as date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Declare @YYYYMM as int = (SELECT FORMAT(@CastDate, 'yyyyMM'))

	--Declare @YearMon as int =(select FiscalYYYYMM from M_Control
	--			where MainKey = 1)

		--Select 1 as a From M_Control Where (select FiscalYYYYMM from M_Control
		--		where MainKey = 1) > @YYYYMM
	Declare @YYYYMM as int = (SELECT REPLACE(convert(varchar(7),@CastDate, 126),'-','') )
	
	if exists(Select 1 as a From M_Control Where (select FiscalYYYYMM from M_Control
				where MainKey = 1) > @YYYYMM)
		begin
			select mm.*,mc.* from M_Message mm ,M_Control mc
			where MessageID = 'E115'			
		end
	else 
		begin
			select 1
		end

END
