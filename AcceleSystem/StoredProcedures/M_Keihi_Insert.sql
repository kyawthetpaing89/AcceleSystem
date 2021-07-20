 BEGIN TRY 
 Drop Procedure dbo.[M_Keihi_Insert]
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
CREATE PROCEDURE [dbo].[M_Keihi_Insert]
	-- Add the parameters for the stored procedure here
	@CostCD as varchar(6),
	@CostName as varchar(40),
	@KanjoCD as varchar(6),
	@HojoCD as varchar(4),
	@Accounting as tinyint,
	@Allocation as tinyint
	AS
	BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--if exists(select 1 from M_Keihi
	--			where CostCD = @CostCD)
	--	begin
	--		select 'error' as [status],* from M_Message
	--		where MessageID = 'E107'
	--	end
	--else if Not Exists(SELECT 1 FROM M_Kanjo WHERE KanjoCD = @KanjoCD)
	--	begin
	--		select 'error' as [status],* from M_Message
	--		where MessageID = 'E101'
	--	end
	--else if Not Exists(SELECT 1 FROM M_Hojo WHERE KanjoCD = @KanjoCD AND HojoCD = @HojoCD)
	--	begin
	--		select 'error' as [status],* from M_Message
	--		where MessageID = 'E101'
	--	end
	--else
	--	begin
			-- Insert statements for procedure here
			INSERT INTO [M_Keihi](CostCD,CostName,KanjoCD,HojoCD,Accounting,Allocation)
			VALUES(@CostCD,@CostName,@KanjoCD,@HojoCD,@Accounting,@Allocation)
			select 'success' as [status],* from M_Message
			where MessageID = 'I101'
		--end

	END
