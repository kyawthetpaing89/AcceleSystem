 BEGIN TRY 
 Drop Procedure dbo.[M_Brand_Insert]
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
CREATE PROCEDURE [dbo].[M_Brand_Insert] 
	-- Add the parameters for the stored procedure here
	@BrandCD as varchar(20),
	@BrandName as varchar(40)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	if exists(select 1 from M_Brand
				where BrandCD = @BrandCD)
		begin
			select 'error' as [status],* from M_Message
			where MessageID = 'E107'
		end
	else
		begin
		    -- Insert statements for procedure here
			INSERT INTO [M_Brand](BrandCD,BrandName)
			VALUES(@BrandCD,@BrandName)

			select 'success' as [status],* from M_Message
			where MessageID = 'I101'
		end
END
