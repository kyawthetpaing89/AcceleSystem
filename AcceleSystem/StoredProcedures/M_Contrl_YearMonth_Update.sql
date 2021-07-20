 BEGIN TRY 
 Drop Procedure dbo.[M_Contrl_YearMonth_Update]
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
CREATE PROCEDURE [dbo].[M_Contrl_YearMonth_Update] 
	-- Add the parameters for the stored procedure here
	@Date as varchar(7)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Declare @datestring as int = (select REPLACE(@Date,'/',''))+'01'

	Declare @day as date = (select CONVERT (date,convert(char(8),@datestring)))

	Declare @newdate as date = (select DATEADD(month, 1, @day)) 

	Declare @year as int = (SELECT YEAR(@newdate) AS Year)

	Declare @YYYYMM as int = (SELECT FORMAT(@newdate, 'yyyyMM'))

	UPDATE M_Control
	Set FiscalYear = @year , FiscalYYYYMM = @YYYYMM
	Where MainKey = '1'

	select 'success' as [status],* from M_Message
			where MessageID = 'I002'

END
