
enum ScalpingPeriod
  {
   M1 = 1,
   M5 = 5,
   M15 = 15
  };
ScalpingPeriod ScalpingByTimeFrame = M5;

void ScalpingByEMA()
  {
   /*if(isNewBar(ScalpingByTimeFrame) && ScalpingByTimeFrame != 15)
     {
      PriceVsEMAAnalysis(PERIOD_M5,false,false);
     }*/
 /*  if(isNewBar(PERIOD_M15))
     {
      PriceVsEMAAnalysis(PERIOD_M15,false,true);
     }
   if(isNewBar(PERIOD_H1))
     {
      PriceVsEMAAnalysis(PERIOD_H1,false,true);
     }
   if(isNewBar(PERIOD_H4))
     {
      PriceVsEMAAnalysis(PERIOD_H4,true,true);
     }*/
  }
