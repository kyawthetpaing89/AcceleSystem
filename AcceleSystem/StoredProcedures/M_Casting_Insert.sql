 BEGIN TRY 
 Drop Procedure dbo.[M_Casting_Insert]
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
CREATE PROCEDURE [dbo].[M_Casting_Insert]
	-- Add the parameters for the stored procedure here
	@CastingCD as varchar(10),
	@CastingName as varchar(20),	
	@BrandCD as varchar(20),
	@BrandName as varchar(40),	
	@UseLimit as varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(select 1 from M_Casting
				where CastingCD = @CastingCD)
		begin
			select 'error' as [status],* from M_Message
			where MessageID = 'E107'
		end
	else if Not Exists(select 1 from M_Brand
				where BrandCD = @BrandCD)
		begin
			select 'error' as [status],* from M_Message
			where MessageID = 'E101'
		end
	else
		begin
		    -- Insert statements for procedure here
			INSERT INTO [M_Casting](CastingCD,CastingName,BrandCD,UseLimit)
			VALUES(@CastingCD,@CastingName,@BrandCD,CAST(@UseLimit AS DATE))

			select 'success' as [status],* from M_Message
			where MessageID = 'I101'
		end
END

