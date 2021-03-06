//+------------------------------------------------------------------+
//|                                                     _Timming.mqh |
//|                                                        Luan Pham |
//|                                               Thông báo mở phiên |
//|                 Xác định nến cùng thời gian của 3 phiên trước đó |
//|                                     Xu thế các cây nến tiếp theo |
//+------------------------------------------------------------------+
#property copyright "Luan Pham"
#property link      ""
#property strict
//+------------------------------------------------------------------+
//Giá trị khởi tạo là mùa hè - thu, mùa đông - xuân thì cập nhật lại
//Giờ này là theo giờ server của broker trong MT4
string SydneyBegin = "0:00";
string SydneyEnd = "8:59";
string TokyoBegin = "02:00";
string TokyoEnd = "10:59";
string LondonBegin = "10:00";
string LondonEnd = "18:59";
string NewYorkBegin = "15:00";
string NewYorkEnd = "23:59";

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SessionNoitification(int timFrame)
  {

   return "";
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetTimming(int timeFrame)
  {
   string str_result = "";
   if(Period() < 60)
     {
      /*if(S_SpringSummer)
        {
         SydneyBegin = "0:00";
         SydneyEnd = "8:59";
         TokyoBegin = "02:00";
         TokyoEnd   = "10:59";
         LondonBegin  = "10:00";
         LondonEnd    = "18:59";
         NewYorkBegin  = "15:00";
         NewYorkEnd    = "23:59";
        }
      else
        {
         // Tới mùa đông xuân thì update code giờ chỗ này nếu chạy sai
        }*/
      datetime dt=CurTime();
      dt=decDateTradeDay(dt);// bỏ thời gian hiện tại
      while(TimeDayOfWeek(dt) > 5 || TimeDayOfWeek(dt) < 1)
         dt=decDateTradeDay(dt);
         
         
      int timming_1 = 0;
      int timming_2 = 0;
      int timming_3 = 0;
      for(int i=0; i<3; i++)
        {
         /*if(i==0)//Bỏ qua thời điểm hiện tại
           {
            dt=decDateTradeDay(dt);
            while(TimeDayOfWeek(dt) > 5 || TimeDayOfWeek(dt) < 1)
               dt=decDateTradeDay(dt);
            continue;
           }*/

         int bar_0 = iBarShift(_Symbol, timeFrame, dt);
         //Check nến này tăng hay giảm, độ lớn của nến
         double high_0 = iHigh(_Symbol, timeFrame, bar_0);
         double low_0 = iLow(_Symbol, timeFrame, bar_0);
         double open_0 = iOpen(_Symbol, timeFrame, bar_0);
         double close_0 = iClose(_Symbol, timeFrame, bar_0);
         bool is_bar_up_0 = open_0 < close_0 ? true : false;
         double pips_0 = TinhSoPips(low_0, high_0);
         //Check 2 cây nến phía trước và phía sau xem vùng giá xung quanh như thế nào

         dt=decDateTradeDay(dt);
         while(TimeDayOfWeek(dt)>5 || TimeDayOfWeek(dt)<1)
            dt=decDateTradeDay(dt);
        }
     }
   return str_result;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
datetime decDateTradeDay(datetime dt)
  {
   int ty=TimeYear(dt);
   int tm=TimeMonth(dt);
   int td=TimeDay(dt);
   int th=TimeHour(dt);
   int ti=TimeMinute(dt);

   td--;
   if(td==0)
     {
      tm--;
      if(tm==0)
        {
         ty--;
         tm=12;
        }
      if(tm==1 || tm==3 || tm==5 || tm==7 || tm==8 || tm==10 || tm==12)
         td=31;
      if(tm==2)
         if(MathMod(ty, 4)==0)
            td=29;
         else
            td=28;
      if(tm==4 || tm==6 || tm==9 || tm==11)
         td=30;
     }
   return(StrToTime((string)ty+"."+(string)tm+"."+(string)td+" "+(string)th+":"+(string)ti));
  }
//+------------------------------------------------------------------+
