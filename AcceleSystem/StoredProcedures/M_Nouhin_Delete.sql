 BEGIN TRY 
 Drop Procedure dbo.[M_Nouhin_Delete]
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
	CREATE PROCEDURE [dbo].[M_Nouhin_Delete]
	-- Add the parameters for the stored procedure here
	@ProjectCD as varchar(15)	,	
	@jsondata as varchar(max)

	AS
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
	SET NOCOUNT ON;

		-- Insert statements for procedure here
		CREATE TABLE [dbo].[#temp](
		[checkval] [varchar] (5) NULL,
		[SEQ] [int] NOT NULL,
		[ProjectCD] [varchar](15) NULL,
		[HinbanCD] [varchar](6) NULL,
		[DeliverAmount] int NULL
		) ON [PRIMARY]

		INSERT INTO #temp(checkval,SEQ,ProjectCD,HinbanCD,DeliverAmount)
		SELECT checkval,SEQ,@ProjectCD,HinbanCD,CONVERT(int, Replace(DeliverAmount,',',''))
		FROM OPENJSON(@jsondata)
		WITH (
				checkval varchar(5),
				SEQ int,
				projectCD varchar(15),
				HinbanCD varchar(6),
				DeliverAmount varchar(10)
				)
		
		delete dd  From D_Delivery dd
				where exists(SELECT *
                FROM #temp 
                WHERE dd.SEQ = #temp.SEQ and #temp.checkval = 'true')

		UPDATE h
			SET Complete = h.Complete - tmp.DeliverAmount,
			CompleteYM = 0
		FROM #temp tmp
		inner join M_Hinban h on h.ProjectCD = tmp.ProjectCD and h.HinbanCD = tmp.HinbanCD
		and tmp.checkval ='true'

		--INSERT INTO M_Hinban(Complete,CompleteYM)
		--SELECT 
		--h.Complete - t.DeliveryAmount,								
		--0
		--FROM #temp t 
		--inner join M_Hinban h on h.ProjectCD =t.ProjectCD and h.HinbanCD =  t.HinbanCD
	
	--select * from #temp
	drop table #temp

	SELECT 'success' as [status],*
	FROM M_Message
	WHERE MessageID = 'I102'
	END


	