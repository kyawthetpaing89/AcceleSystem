 BEGIN TRY 
 Drop Procedure dbo.[M_Contrl_YearMonth_Genka_Update_nns]
END try
BEGIN CATCH END CATCH 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 -- =============================================
 --Author:		<Author,,Name>
 --Create date: <Create Date,,>
 --Description:	<Description,,>
 --=============================================
CREATE PROCEDURE [dbo].[M_Contrl_YearMonth_Genka_Update_nns] 
	 --Add the parameters for the stored procedure here
	--@Date as varchar(7)
AS
BEGIN
	 --SET NOCOUNT ON added to prevent extra result sets from
	 --interfering with SELECT statements.
	SET NOCOUNT ON;

   --Declare @year as int = (SELECT top 1 YEAR(CostDate) AS Year From D_Cost)
   Declare @YearMonth as int = (select FiscalYYYYMM From M_Control Where MainKey = 1);
  
	---テーブル転送仕様Ａ
	Delete From D_DirectCost 
	where YYYYMM = @YearMonth
    INSERT INTO D_DirectCost(YYYYMM,CostCD,ProjectCD,HinbanCD,Cost) 
    SELECT con.FiscalYYYYMM as [FiscalYYYYMM],
	cost.CostCD as [CostCD],
	cost.ProjectCD as [ProjectCD],
	cost.HinbanCD as [HinbanCD],
	SUM(cost.InputAmount) as [InputAmount]
    From M_Control con, D_Cost cost
    LEFT OUTER JOIN M_Keihi keihi on keihi.CostCD = cost.CostCD    
     Where con.MainKey = 1 AND
     (keihi.Accounting = 1 OR keihi.Accounting = 3) AND
	 CONVERT(int,REPLACE(CONVERT(varchar(7),cost.CostDate),'-',''))= con.FiscalYYYYMM
     Group by con.FiscalYYYYMM, CONVERT(int,REPLACE(CONVERT(varchar(7),cost.CostDate),'-','')), cost.CostCD, cost.ProjectCD, cost.HinbanCD
   
   --テーブル転送仕様B
   Delete From D_TotalDirectCost
   Where YYYY =  CONVERT(int,LEFT(CONVERT(varchar,@YearMonth),4))
   INSERT INTO D_TotalDirectCost(YYYY,CostCD,ProjectCD,HinbanCD,Cost)
   SELECT con.FiscalYear  as [FiscalYear],
   cost.CostCD as [CostCD],
   cost.ProjectCD as [ProjectCD],
   cost.HinbanCD as [HinbanCD],
   SUM(ISNULL(cost.InputAmount,0)) as [Cost]     --SYPK ENo.195
   From M_Control con, D_Cost cost
   LEFT OUTER JOIN M_Keihi keihi on keihi.CostCD = cost.CostCD
   Where con.MainKey = 1 AND
   keihi.Accounting = 1 AND
    CONVERT(int,REPLACE(CONVERT(varchar(7),cost.CostDate),'-','')) >= con.FiscalYear + con.StartMonth AND
	CONVERT(int,REPLACE(CONVERT(varchar(7),cost.CostDate),'-','')) <= con.FiscalYYYYMM
   --Group by con.FiscalYear, CONVERT(int,REPLACE(CONVERT(varchar(7),cost.CostDate),'-','')), cost.CostCD, cost.ProjectCD, cost.HinbanCD  SYPK2021-04-20
   Group by con.FiscalYear, cost.CostCD, cost.ProjectCD, cost.HinbanCD	--SYPK2021-04-20

   --テーブル転送仕様C
   Delete From D_IndirectCost
   Where YYYYMM = @YearMonth
   Insert into D_IndirectCost(YYYYMM,CostCD,Accounting,ProjectCD,HinbanCD,BrandCD,Season,Year,CastingCD,FreeItem1,Cost)
   Select con.FiscalYYYYMM as [FiscalYYYYMM],
   cost.CostCD as [CostCD],
   keihi.Accounting as [Accounting],
   cost.ProjectCD as [ProjectCD],
   cost.HinbanCD as [HinbanCD],
   cost.BrandCD as [BrandCD],
   cost.Season as [Season],
   cost.Year as [Year],
   cost.CastingCD as [CastingCD],
   cost.FreeItem1 as [FreeItem1],
   SUM(cost.InputAmount) as [CostAmount]    --SYPK ENo.195
   From M_Control con, D_Cost cost
   LEFT OUTER JOIN M_Keihi keihi on keihi.CostCD = cost.CostCD
   Where con.MainKey = 1 AND
   keihi.Accounting <> 1 AND 
   CONVERT(int,REPLACE(CONVERT(varchar(7),cost.CostDate),'-','')) = con.FiscalYYYYMM
   Group by con.FiscalYYYYMM, keihi.Accounting, CONVERT(int,REPLACE(CONVERT(varchar(7),cost.CostDate),'-','')), 
   cost.CostCD, cost.ProjectCD, cost.HinbanCD, cost.BrandCD, cost.Season, cost.Year, cost.CastingCD, cost.FreeItem1

   --テーブル転送仕様D
   Delete From D_TotalIndirectCost
   Where YYYYMM = @YearMonth
   Insert into D_TotalIndirectCost(YYYYMM,CostCD,Accounting,ProjectCD,HinbanCD,BrandCD,Season,Year,CastingCD,FreeItem1,Cost)
   select 
	con.FiscalYYYYMM,
	d.CostCD,
	keihi.Accounting,
	d.ProjectCD,
	d.HinbanCD,
	d.BrandCD,
	d.Season,
	d.Year,
	d.CastingCD,
	d.FreeItem1,
	SUM(d.InputAmount) as [Cost]
  From M_COntrol con, D_Cost d
  LEFT OUTER JOIN M_Keihi keihi on keihi.CostCD = d.CostCD
  Where con.MainKey = 1 AND
  keihi.Accounting <> 1 AND
  CONVERT(int,REPLACE(CONVERT(varchar(7),d.CostDate),'-','')) >= con.FiscalYear + con.StartMonth AND
  CONVERT(int,REPLACE(CONVERT(varchar(7),d.CostDate),'-','')) <= con.FiscalYYYYMM 
  Group by LEFT(d.CostDate,4),d.CostCD,d.ProjectCD,d.HinbanCD,d.BrandCD,d.Season,d.Year,d.CastingCD,d.FreeItem1,con.FiscalYYYYMM,keihi.Accounting

   --テーブル転送仕様E1
   Delete From D_Proportion_Value
   Where YYYYMM = @YearMonth
   create table #temp
   (
   YYYYMM int,
   ProjectCD Varchar(10),
   HinbanCD Varchar(6),
   [Value] int,
   TotalValue int,
   [percentage] decimal(4, 3),
   tmpcol decimal(4,3)
   );
   insert into #temp
   Select con.FiscalYYYYMM,
   hin.ProjectCD as [ProjectCD],
   hin.HinbanCD as [HinbanCD],
   (hin.Production * hin.SalesPrice) AS [Value],
   hinn.TotalValue,
   Round((CONVERT(decimal,(hin.Production * hin.SalesPrice)) / CONVERT(decimal,hinn.TotalValue)),4) as [percentage], --SYPK ENo.191
   0
   From M_Control con, M_Hinban hin
   left outer join (select ProjectCD,
   SUM(Production * SalesPrice) as [TotalValue]
   from M_Hinban group by ProjectCD
   ) hinn on hinn.ProjectCD = hin.ProjectCD
   Where con.MainKey = 1 AND
   hin.CompleteYM = 0
   Group By con.FiscalYYYYMM,[HinbanCD],(hin.Production * hin.SalesPrice),hinn.TotalValue,hin.ProjectCD
   
   --Update #temp set tmpcol = per
   --from #temp
   --inner join(select ProjectCD,SUM([percentage]) AS per from #temp group by #temp.ProjectCD) as t1 on t1.ProjectCD = #temp.ProjectCD
   
   --;with cte
   --AS(
   --select ProjectCD, (1 - SUM(tmpcol)) AS result from #temp
   --Where tmpcol < 1
   --Group By ProjectCD
   --)
   
   --Update T set [percentage] = cte.result
   --From #temp T
   --inner join cte on cte.ProjectCD = T.ProjectCD
   --inner join (select ProjectCD,MAX([percentage]) AS maxvalue from #temp Group By ProjectCD) AS t1 on t1.ProjectCD = T.ProjectCD

	Insert into D_Proportion_Value(YYYYMM,ProjectCD,HinbanCD,Value,TotalValue,percentage)
	select tem.YYYYMM, tem.ProjectCD,tem.HinbanCD, tem.Value, tem.TotalValue,tem.percentage
	From #temp tem

Begin
Drop Table #temp
End																																				
	
	--テーブル転送仕様E2
   Delete From D_PV_BS
   Where YYYYMM = @YearMonth
   INSERT INTO D_PV_BS(YYYYMM,CostCD,ProjectCD,HinbanCD,BrandCD,Season,Year,Cost)
   Select con.FiscalYYYYMM,
   indirect.CostCD,
   proportion.ProjectCD,
   proportion.HinbanCD,
   indirect.BrandCD,
   indirect.Season,
   indirect.Year,
   (ISNULL(indirect.Cost,0) * ISNULL(proportion.Percentage,0)) as [Cost]
   From M_Control con, D_Proportion_Value proportion
   LEFT OUTER JOIN  D_TotalIndirectCost indirect
   on proportion.YYYYMM = indirect.YYYYMM AND
   proportion.ProjectCD = indirect.ProjectCD AND
   proportion.HinbanCD = indirect.HinbanCD
   Where con.MainKey = 1 AND
   indirect.YYYYMM = con.FiscalYYYYMM AND
   indirect.Accounting = 2 AND
   proportion.YYYYMM = con.FiscalYYYYMM

   --テーブル転送仕様E3
   Delete From D_PV_PJ
   Where YYYYMM = @YearMonth
   INSERT INTO D_PV_PJ(YYYYMM,CostCD,ProjectCD,HinbanCD,Cost)
   Select con.FiscalYYYYMM,
   indirect.CostCD,
   proportion.ProjectCD,
   proportion.HinbanCD,
   (ISNULL(indirect.Cost,0) * ISNULL(proportion.Percentage,0)) as [Cost]
   From M_Control con,D_TotalIndirectCost indirect 
   LEFT OUTER JOIN D_Proportion_Value proportion 
   on proportion.YYYYMM = indirect.YYYYMM AND
   proportion.ProjectCD = indirect.ProjectCD
   Where con.MainKey = 1 AND
   indirect.YYYYMM = con.FiscalYYYYMM AND
   indirect.Accounting = 3 AND
   proportion.YYYYMM = con.FiscalYYYYMM

   --テーブル転送仕様E4
   Delete From D_PV_Cast
   Where YYYYMM = @YearMonth
   INSERT INTO D_PV_Cast(YYYYMM,CostCD,ProjectCD,HinbanCD,CastingCD,Cost)
   Select con.FiscalYYYYMM,
   indirect.CostCD,
   proportion.ProjectCD,
   proportion.HinbanCD,
   indirect.CastingCD,
   (ISNULL(indirect.Cost,0) * ISNULL(proportion.Percentage,0)) as [Cost]
   From M_Control con,D_TotalIndirectCost indirect 
   LEFT OUTER JOIN D_Proportion_Value proportion 
   on proportion.YYYYMM = indirect.YYYYMM AND
   proportion.ProjectCD = indirect.ProjectCD AND
   proportion.HinbanCD = indirect.HinbanCD
   Where con.MainKey = 1 AND
   indirect.YYYYMM = con.FiscalYYYYMM AND
   indirect.Accounting = 4 AND
   proportion.YYYYMM = con.FiscalYYYYMM


   --テーブル転送仕様E5
   Delete From D_PV_FreeItem1
   Where YYYYMM = @YearMonth
   INSERT INTO D_PV_FreeItem1(YYYYMM,CostCD,ProjectCD,HinbanCD,FreeItem1,Cost)
   Select con.FiscalYYYYMM,
   indirect.CostCD,
   proportion.ProjectCD,
   proportion.HinbanCD,
   indirect.FreeItem1,
   (ISNULL(indirect.Cost,0) * ISNULL(proportion.Percentage,0)) as [Cost]
   From M_Control con,D_TotalIndirectCost indirect 
   LEFT OUTER JOIN D_Proportion_Value proportion 
   on proportion.YYYYMM = indirect.YYYYMM AND
   proportion.ProjectCD = indirect.ProjectCD AND
   proportion.HinbanCD = indirect.HinbanCD
   Where con.MainKey = 1 AND
   indirect.YYYYMM = con.FiscalYYYYMM AND
   indirect.Accounting = 5 AND
   proportion.YYYYMM = con.FiscalYYYYMM


   Delete From D_Proportion_Production
   Where YYYYMM = @YearMonth
   Insert INTO D_Proportion_Production(YYYYMM,ProjectCD,HinbanCD,Production,TotalProduction,percentage)
   Select con.FiscalYYYYMM,
   hin.ProjectCD,
   hin.HinbanCD,
   hin.Production,
   hinn.[TotalP] as [TotalProduction],
   Cast(ROUND((CONVERT(decimal,hin.Production) /  SUM(hinn.[TotalP])),4) as numeric(36,3)) as [percentage]
   From M_Control con,M_Hinban hin
   left outer join (select ProjectCD,
					SUM(Production) as [TotalP]
					from M_Hinban group by ProjectCD) hinn on hinn.ProjectCD = hin.ProjectCD
   Where con.MainKey = 1 
   AND hin.CompleteYM = 0      --SYPK ENo.195
   Group by con.FiscalYYYYMM, hin.ProjectCD, hin.HinbanCD, hin.Production,hinn.[TotalP]
   --Select con.FiscalYYYYMM,
   --hinban.ProjectCD,
   --hinban.HinbanCD,
   --hinban.Production,
   --SUM(hinban.Production) as [TotalProduction],
   --(hinban.Production /  SUM(hinban.Production)) as [percentage]
   --From M_Control con,M_Hinban hinban
   --Where con.MainKey = 1 AND
   --hinban.CompleteYM <> 0
   --Group by con.FiscalYYYYMM, hinban.ProjectCD, hinban.HinbanCD, hinban.Production

   --テーブル転送仕様F2
   Delete From D_PP_BS
   Where YYYYMM = @YearMonth
   INSERT INTO D_PP_BS (YYYYMM,CostCD,ProjectCD,HinbanCD,BrandCD,Season,Year,Cost)
  Select con.FiscalYYYYMM,
   indirect.CostCD,
   production.ProjectCD,
   production.HinbanCD,
   indirect.BrandCD,
   indirect.Season,
   indirect.Year,
   (ISNULL(indirect.Cost,0) * ISNULL(production.percentage,0)) as [Cost]
   From M_Control con, D_Proportion_Production production
   LEFT OUTER JOIN D_TotalIndirectCost indirect 
   on production.YYYYMM = indirect.YYYYMM AND
   production.ProjectCD = indirect.ProjectCD AND
   production.HinbanCD = indirect.HinbanCD
   Where con.MainKey = 1 AND
   indirect.YYYYMM = con.FiscalYYYYMM AND
   indirect.Accounting = 2 AND
   production.YYYYMM = con.FiscalYYYYMM

   --テーブル転送仕様F3
   Delete From D_PP_PJ
   Where YYYYMM = @YearMonth
   INSERT INTO D_PP_PJ (YYYYMM,CostCD,ProjectCD,HinbanCD,Cost)
   Select con.FiscalYYYYMM,
   indirect.CostCD,
   proportion.ProjectCD,
   proportion.HinbanCD,   
   (ISNULL(indirect.Cost,0) * ISNULL(proportion.percentage,0)) as [Cost]
   From M_Control con,D_Proportion_Production proportion
   LEFT OUTER JOIN D_TotalIndirectCost indirect 
   on proportion.YYYYMM = indirect.YYYYMM AND
   proportion.ProjectCD = indirect.ProjectCD 
   Where con.MainKey = 1 AND
   indirect.YYYYMM = con.FiscalYYYYMM AND
   indirect.Accounting = 3 AND
   proportion.YYYYMM = con.FiscalYYYYMM

   --テーブル転送仕様F4
   Delete From D_PP_Cast
   Where YYYYMM = @YearMonth
   INSERT INTO D_PP_Cast (YYYYMM,CostCD,ProjectCD,HinbanCD,CastingCD,Cost)
   Select con.FiscalYYYYMM,
   indirect.CostCD,
   proportion.ProjectCD,
   proportion.HinbanCD,
   indirect.CastingCD,
   (ISNULL(indirect.Cost,0) * ISNULL(proportion.percentage,0)) as [Cost]
   From M_Control con,D_Proportion_Production proportion
   LEFT OUTER JOIN D_TotalIndirectCost indirect 
   on proportion.YYYYMM = indirect.YYYYMM AND
   proportion.ProjectCD = indirect.ProjectCD AND
   proportion.HinbanCD = indirect.HinbanCD
   Where con.MainKey = 1 AND
   indirect.YYYYMM = con.FiscalYYYYMM AND
   indirect.Accounting = 4 AND
   proportion.YYYYMM = con.FiscalYYYYMM

   --テーブル転送仕様F5
   Delete From D_PP_FreeItem1
   Where YYYYMM = @YearMonth
   INSERT INTO D_PP_FreeItem1(YYYYMM,CostCD,ProjectCD,HinbanCD,FreeItem1,Cost)
   Select con.FiscalYYYYMM,
   indirect.CostCD,
   proportion.ProjectCD,
   proportion.HinbanCD,
   indirect.FreeItem1,
   (ISNULL(indirect.Cost,0) * ISNULL(proportion.percentage,0)) as [Cost]
   From M_Control con,D_Proportion_Production proportion
   LEFT OUTER JOIN D_TotalIndirectCost indirect 
   on proportion.YYYYMM = indirect.YYYYMM AND
   proportion.ProjectCD = indirect.ProjectCD AND
   proportion.HinbanCD = indirect.HinbanCD
   Where con.MainKey = 1 AND
   indirect.YYYYMM = con.FiscalYYYYMM AND
   indirect.Accounting = 5 AND
   proportion.YYYYMM = con.FiscalYYYYMM 

   --テーブル転送仕様G1
   Delete From D_Proportion_Fix
   Where YYYYMM = @YearMonth
   create table #temp1
(
YYYYMM int,
ProjectCD Varchar(10),
HinbanCD Varchar(6),
Fix int,
TotalFix int,
[percentage] decimal(4, 3),
tmpcol decimal(4,3)
);

insert into #temp1
Select con.FiscalYYYYMM,
hin.ProjectCD as [ProjectCD],
hin.HinbanCD as [HinbanCD],
hin.FreeItem2,
SUM(ISNULL(hinn.TotalFreeItem2,0)) as [TotalFix],
 case when SUM(ISNULL(hin.FreeItem2,0)) = 0 then 0 else CAST(Round((CONVERT(decimal,ISNULL(hin.FreeItem2,0))) / SUM(CONVERT(decimal,ISNULL(hinn.TotalFreeItem2,0))),4)as numeric(36,3)) end as [percentage],
0
From M_Control con, M_Hinban hin
left outer join (select ProjectCD,
SUM(FreeItem2) as [TotalFreeItem2]
from M_Hinban group by ProjectCD
) hinn on hinn.ProjectCD = hin.ProjectCD
Where con.MainKey = 1 AND
hin.CompleteYM = 0       --SYPK ENo.195
Group By con.FiscalYYYYMM,[HinbanCD],hin.FreeItem2,(hin.Production * hin.SalesPrice),hinn.TotalFreeItem2,hin.ProjectCD

--Update #temp1 set tmpcol = per
--from #temp1
--inner join(select ProjectCD,SUM([percentage]) AS per from #temp1 group by #temp1.ProjectCD) as t1 on t1.ProjectCD = #temp1.ProjectCD

--;with cte
--AS(
--select ProjectCD, (1 - SUM(tmpcol)) AS result from #temp1
--Where tmpcol < 1
--Group By ProjectCD
--)

--Update T set [percentage] = cte.result
--From #temp1 T
--inner join cte on cte.ProjectCD = T.ProjectCD
--inner join (select ProjectCD,MAX([percentage]) AS maxvalue from #temp1 Group By ProjectCD) AS t1 on t1.ProjectCD = T.ProjectCD

 INSERT INTO D_Proportion_Fix(YYYYMM,ProjectCD,HinbanCD,Fix,TotalFix,percentage)
 select tem1.YYYYMM, tem1.ProjectCD, tem1.HinbanCD, tem1.Fix, tem1.TotalFix, tem1.percentage
 from #temp1 tem1

Begin
Drop Table #temp1
End	
 
	--テーブル転送仕様G2
   Delete From D_PF_BS
   Where YYYYMM = @YearMonth
   Insert INTO D_PF_BS(YYYYMM,CostCD,ProjectCD,HinbanCD,BrandCD,Season,Year,Cost)
   Select con.FiscalYYYYMM,
   indirect.CostCD,
   proportionfix.ProjectCD,
   proportionfix.HinbanCD,
   indirect.BrandCD,
   indirect.Season,
   indirect.Year,
   (ISNULL(indirect.Cost,0) * ISNULL(proportionfix.percentage,0)) as [Cost]
   From M_Control con, D_Proportion_Fix proportionfix
   LEFT OUTER JOIN D_TotalIndirectCost indirect
   on proportionfix.YYYYMM = indirect.YYYYMM AND
   proportionfix.ProjectCD = indirect.ProjectCD AND
   proportionfix.HinbanCD = indirect.HinbanCD
   Where con.MainKey = 1 AND
   indirect.YYYYMM = con.FiscalYYYYMM AND
   indirect.Accounting = 2 AND
   proportionfix.YYYYMM = con.FiscalYYYYMM

   --テーブル転送仕様G3
   Delete From D_PF_PJ
   Where YYYYMM = @YearMonth
   Insert INTO D_PF_PJ(YYYYMM,CostCD,ProjectCD,HinbanCD,Cost)
   Select con.FiscalYYYYMM,
   indirect.CostCD,
   proportionfix.ProjectCD,
   proportionfix.HinbanCD,
   (ISNULL(indirect.Cost,0) * ISNULL(proportionfix.percentage,0)) as [Cost]
   From M_Control con, D_Proportion_Fix proportionfix
   LEFT OUTER JOIN D_TotalIndirectCost indirect
   on proportionfix.YYYYMM = indirect.YYYYMM AND
   proportionfix.ProjectCD = indirect.ProjectCD 
   Where con.MainKey = 1 AND
   indirect.YYYYMM = con.FiscalYYYYMM AND
   indirect.Accounting = 3 AND
   proportionfix.YYYYMM = con.FiscalYYYYMM

   --テーブル転送仕様G4
   Delete From D_PF_Cast
   Where YYYYMM = @YearMonth
   Insert INTO D_PF_Cast(YYYYMM,CostCD,ProjectCD,HinbanCD,CastingCD,Cost)
   Select con.FiscalYYYYMM,
   indirect.CostCD,
   proportionfix.ProjectCD,
   proportionfix.HinbanCD,
   indirect.CastingCD,
   (ISNULL(indirect.Cost,0) * ISNULL(proportionfix.percentage,0)) as [Cost]
   From M_Control con, D_Proportion_Fix proportionfix
   LEFT OUTER JOIN D_TotalIndirectCost indirect
   on proportionfix.YYYYMM = indirect.YYYYMM AND
   proportionfix.ProjectCD = indirect.ProjectCD AND
   proportionfix.HinbanCD = indirect.HinbanCD
   Where con.MainKey = 1 AND
   indirect.YYYYMM = con.FiscalYYYYMM AND
   indirect.Accounting = 4 AND
   proportionfix.YYYYMM = con.FiscalYYYYMM

   --テーブル転送仕様G5
   Delete From D_PF_FreeItem1
   Where YYYYMM = @YearMonth
   Insert INTO D_PF_FreeItem1(YYYYMM,CostCD,ProjectCD,HinbanCD,FreeItem1,Cost)
   Select con.FiscalYYYYMM,
   indirect.CostCD,
   proportionfix.ProjectCD,
   proportionfix.HinbanCD,
   indirect.FreeItem1,
   (ISNULL(indirect.Cost,0) * ISNULL(proportionfix.percentage,0)) as [Cost]
   From M_Control con, D_Proportion_Fix proportionfix
   LEFT OUTER JOIN D_TotalIndirectCost indirect
   on proportionfix.YYYYMM = indirect.YYYYMM AND
   proportionfix.ProjectCD = indirect.ProjectCD AND
   proportionfix.HinbanCD = indirect.HinbanCD
   Where con.MainKey = 1 AND
   indirect.YYYYMM = con.FiscalYYYYMM AND
   indirect.Accounting = 5 AND
   proportionfix.YYYYMM = con.FiscalYYYYMM

   select 'success' as [status],* from M_Message
			where MessageID = 'I002'

   END
   
