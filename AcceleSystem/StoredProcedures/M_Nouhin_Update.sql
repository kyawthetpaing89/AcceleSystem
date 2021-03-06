 BEGIN TRY 
 Drop Procedure dbo.[M_Nouhin_Update]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	-- =============================================
	-- Author: <Author,,Name>
	-- Create date: <Create Date,,>
	-- Description: <Description,,>
	-- =============================================
	CREATE PROCEDURE [dbo].[M_Nouhin_Update]
	-- Add the parameters for the stored procedure here
			
			@DeliveryDate as date ,
			@ProjectCD as varchar(15),
			@Remarks as varchar(60),
			@jsondata as varchar(max)

	AS
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
	SET NOCOUNT ON;

		-- Insert statements for procedure here
		CREATE TABLE [dbo].[#temp](
		[checkval] [varchar] (5) NULL,
		[SEQ] int NOT NULL,
		[DeliveryDate] date NULL,
		[ProjectCD] [varchar](15) NULL,
		[HinbanCD] [varchar](6) NULL,
		[DeliverAmount] int NULL,
		[Remarks] [varchar](60) NULL
		) ON [PRIMARY]

		INSERT INTO #temp(checkval,SEQ,DeliveryDate,ProjectCD,HinbanCD, DeliverAmount,Remarks)
		SELECT checkval,SEQ,@DeliveryDate, @ProjectCD, HinbanCD, CONVERT(int, Replace(DeliverAmount,',','')), @Remarks
		FROM OPENJSON(@jsondata)
		WITH (
				checkval varchar(5),
				SEQ int,
				DeliveryDate date,
				ProjectCD varchar(15) ,
				HinbanCD varchar(6) ,
				DeliverAmount varchar(10) ,
				Remarks varchar(60)
				)
		
		UPDATE d
		SET 
		DeliveryDate = tmp.DeliveryDate,
		ProjectCD = tmp.ProjectCD,
		HinbanCD = tmp.HinbanCD,
		DeliveryAmount = ISNULL(tmp.DeliverAmount,0),
		Remarks = tmp.Remarks
		From #temp tmp
		inner join D_Delivery d on d.SEQ = tmp.SEQ and tmp.checkval ='true'

		UPDATE h
		SET Complete = ISNULL(h.Complete,0) + ISNULL(tmp.DeliverAmount,0) ,
		CompleteYM = Case When (h.Complete + tmp.DeliverAmount = h.Production) then CONVERT(int,SUBSTRING((REPLACE(@DeliveryDate,'-','')),5,4)) ELSE 0  END 
		FROM #temp tmp
		inner join M_Hinban h on h.ProjectCD = tmp.ProjectCD and h.HinbanCD = tmp.HinbanCD
		and tmp.checkval ='true'

		--INSERT INTO M_Hinban(Complete,CompleteYM)
		--SELECT 
		--h.Complete + t.DeliveryAmount,								
		--Case When h.Complete + t.DeliveryAmount = h.Production then SUBSTRING('@DeliveryDate', 4, 4) END AS CompleteYM
		--FROM #temp t 
		--inner join M_Hinban h on h.ProjectCD =t.ProjectCD and h.HinbanCD =  t.HinbanCD

	--select * from #temp
	drop table #temp

	SELECT 'success' as [status],*
	FROM M_Message
	WHERE MessageID = 'I101'
END