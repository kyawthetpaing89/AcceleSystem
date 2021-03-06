 BEGIN TRY 
 Drop Procedure dbo.[M_NouhinBS_Insert]
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
CREATE PROCEDURE [dbo].[M_NouhinBS_Insert]
	-- Add the parameters for the stored procedure here
		@DeliveryDate as date ,
		@Remarks as varchar(60),
		@jsondata as varchar(max)  

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	--Create temp table
	CREATE TABLE [dbo].[#temp](   
	[checkval] [varchar] (5) NULL,
	[DeliveryDate] date NULL,
	[ProjectCD] [varchar](15)  NULL,
	[HinbanCD] [varchar](6)  NULL,
	[DeliverAmount] int NULL,
	[Remarks] [varchar](60) NULL
	) ON [PRIMARY]

	--Insert JsonData into temp table
	INSERT INTO #temp(checkval,DeliveryDate,ProjectCD,HinbanCD, DeliverAmount,Remarks)
	SELECT checkval,@DeliveryDate, ProjectCD, HinbanCD,CONVERT(int, Replace(DeliverAmount,',','')), @Remarks
	FROM OPENJSON(@jsondata)
	     WITH (
				checkval varchar(5),
				DeliveryDate date,
				ProjectCD varchar(15) , 
				HinbanCD varchar(6) , 
				DeliverAmount varchar(10) ,
				Remarks varchar(60)
			  ) 

	--Insert data from Temp table into D_Delivery 
	INSERT INTO D_Delivery(DeliveryDate,ProjectCD,HinbanCD, DeliveryAmount,Remarks)
	SELECT DeliveryDate,ProjectCD,HinbanCD, ISNULL(DeliverAmount,0),Remarks 
	FROM #temp where checkval = 'true'

	UPDATE h
	SET Complete = ISNULL(h.Complete,0) + ISNULL(tmp.DeliverAmount,0),
	CompleteYM = Case When (h.Complete + tmp.DeliverAmount = h.Production) then CONVERT(int,SUBSTRING((REPLACE(@DeliveryDate,'-','')),1,6)) else 0 END 
	FROM #temp tmp
	inner join M_Hinban h on h.ProjectCD = tmp.ProjectCD and h.HinbanCD = tmp.HinbanCD
	and tmp.checkval ='true'

	drop table #temp

	SELECT 'success' as [status],* 
	FROM M_Message
	WHERE MessageID = 'I101'
END
