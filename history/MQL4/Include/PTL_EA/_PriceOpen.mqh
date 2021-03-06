//+------------------------------------------------------------------+
//|                                                    PriceOpen.mqh |
//|                                                        Luan Pham |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Luan Pham"
#property link      ""
#property strict


string DrawPriceOpen = "DRAW PRICE OPEN";
int History_Days = 1;
int History_Weeks = 1;
int History_Months = 1;
color Color_CurrentPriceOpen = DodgerBlue;
color Color_LastPriceOpen = LightBlue;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PriceOpen(int timeFrame = 5, int periodTrend = 21)
  {
   int barNum = 34;//Số lượng bar để kiểm tra
   double price_d = iOpen(_Symbol,PERIOD_D1,0);
   double price_w = iOpen(_Symbol,PERIOD_W1,0);
   double price_mn = iOpen(_Symbol,PERIOD_MN1,0);
   double price_y = iOpen(_Symbol,PERIOD_MN1, Month()-1);

   double open = iOpen(_Symbol, timeFrame, 0);
   double high_prev = iHigh(_Symbol, timeFrame, 1);
   double low_prev = iLow(_Symbol, timeFrame, 1);
   double open_prev = iOpen(_Symbol, timeFrame, 1);
   double close_prev = iClose(_Symbol, timeFrame, 1);

   double point_compat = 1;
   if(Digits == 3 || Digits == 5)
      point_compat = 10;
   if(price_y /*+ (Point * point_compat)*/ >= low_prev && price_y /*- (Point * point_compat)*/ <= high_prev)//nến trước cắt yearly open
     {
      //RS_PriceTrend_Analysis(timeFrame, close_prev, price_y, "YEARLY OPEN");
     }
   else
      if(price_mn /*+ (Point * point_compat)*/ >= low_prev && price_mn /*- (Point * point_compat)*/ <= high_prev)//nến trước cắt monthly open
        {
         //RS_PriceTrend_Analysis(timeFrame, close_prev, price_mn, "MONTHLY OPEN");
        }
      else
         if(price_w /*+ (Point*point_compat)*/  > low_prev  && price_w /*- (Point*point_compat)*/ < high_prev) //nến trước cắt weekly open
           {
            //RS_PriceTrend_Analysis(timeFrame, close_prev, price_w, "WEEKLY OPEN");
           }
         else
            if(price_d /*+ (Point*point_compat)*/ > low_prev  && price_d /*- (Point*point_compat)*/ < high_prev) //nến trước cắt daily open
              {
               //RS_PriceTrend_Analysis(timeFrame, close_prev, price_d, "DAILY OPEN");
              }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MondayRange(int timeFrame)
  {
   double high_prev = iHigh(_Symbol, timeFrame, 1);
   double low_prev = iLow(_Symbol, timeFrame, 1);
   double open_prev = iOpen(_Symbol, timeFrame, 1);
   double close_prev = iClose(_Symbol, timeFrame, 1);

   for(int i=0; i<ObjectsTotal(); i++)
     {
      double trend_price;
      string name=ObjectName(i);

      if(StringFind(name, "Monday") != -1)
        {
         if(ObjectType(name)==OBJ_TREND)
           {
            trend_price = ObjectGetValueByShift(name, 0);
           }
         else
           {
            trend_price=ObjectGet(name, OBJPROP_PRICE1);
           }
         if(trend_price >= low_prev && trend_price <= high_prev)//nến trước đó cắt trendline
           {
            //RS_PriceTrend_Analysis(timeFrame, close_prev, trend_price, name);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void YesterdayRangeGraph()
  {
   //DeleteObjects("Yesterday Range");
   //return;
//
   /*if(DayOfWeek() == 2)//ngày thứ 3 thì yesterday trùng với monday high/low nên không cần vẽ
     {
      DeleteObjects("Yesterday Range");
      return;
     }*/
   datetime open_d = iTime(_Symbol,PERIOD_D1,1);
   string nextDay = (string)Year() + "." + (string)Month() + "." + (string)(Day()+1);
   datetime end_d = StringToTime(nextDay);
   double p_high = iHigh(_Symbol,PERIOD_D1,1);
   double p_low = iLow(_Symbol,PERIOD_D1,1);
   DrawRange("Yesterday Range", open_d, end_d, p_low, p_high, /*Sienna*/Black, STYLE_DOT);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MondayRangeGraph()
  {
//Lấy high của ngày thứ 2
//Lấy low của ngày thứ 2
//Lấy trung bình của high và low
//vẽ range dựa vào 3 điểm này
//
   if(DayOfWeek() == 1)// ngày đầu tuần nên chưa xác định dc high/low
     {
      DeleteObjects("Monday");
      return;
     }
   datetime open_w = iTime(_Symbol,PERIOD_W1,0);
   string nextWeek = (string)Year() + "." + (string)Month() + "." + (string)(Day() + 7 - DayOfWeek());
   datetime end_w = StringToTime(nextWeek);

   double m_high = iHigh(_Symbol,PERIOD_D1,DayOfWeek()-1);
   double m_low = iLow(_Symbol,PERIOD_D1,DayOfWeek()-1);
   DrawRange("MondayRange", open_w, end_w, m_low, m_high, LightGray, STYLE_SOLID);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PriceOpenGraph()
  {
//Vẽ trend line nến mở của ngày/tuần/tháng/năm
//Xóa trend cũ
//DeleteObjects("Open");
//MondayRangeGraph();
   //YesterdayRangeGraph();
   datetime open_d = iTime(_Symbol,PERIOD_D1,0);
   string nextDay = (string)Year() + "." + (string)Month() + "." + (string)(Day()+1);
   datetime end_d = StringToTime(nextDay);
   DrawTrendLine("Daily Open "/*+TimeToStr(open_d)*/,false, open_d,end_d,iOpen(_Symbol,PERIOD_D1,0),iOpen(_Symbol,PERIOD_D1,0),Color_CurrentPriceOpen,STYLE_SOLID);
   for(int i = 0; i < History_Days; i++)
     {
      DrawTrendLine("(Old) Daily Open "/*+ TimeToStr(iTime(_Symbol,PERIOD_D1,i+1))*/, false, iTime(_Symbol,PERIOD_D1,i+1),iTime(_Symbol,PERIOD_D1,i+0),iOpen(_Symbol,PERIOD_D1,i+1),iOpen(_Symbol,PERIOD_D1,i+1),Color_LastPriceOpen,STYLE_SOLID);
     }

   datetime open_w = iTime(_Symbol,PERIOD_W1,0);
   string nextWeek = (string)Year() + "." + (string)Month() + "." + (string)(Day() + 7 - DayOfWeek());
   datetime end_w = StringToTime(nextWeek);
   DrawTrendLine("Weekly Open "/*+TimeToStr(open_w)*/, false, open_w,end_w,iOpen(_Symbol,PERIOD_W1,0),iOpen(_Symbol,PERIOD_W1,0),LightSkyBlue,STYLE_SOLID);
   for(int i = 0; i < History_Weeks; i++)
     {
      //DrawTrendLine("(Old) Weekly Open "+ TimeToStr(iTime(_Symbol,PERIOD_W1,i+1)), false, iTime(_Symbol,PERIOD_W1,i+1),iTime(_Symbol,PERIOD_W1,i+0),iOpen(_Symbol,PERIOD_W1,i+1),iOpen(_Symbol,PERIOD_W1,i+1),Color_LastPriceOpen,STYLE_SOLID);
     }

   datetime open_m =  iTime(_Symbol,PERIOD_MN1,0);
   string nextMonth = (string)Year() + "." + (string)(Month()+1) + ".01";
   datetime end_m = StringToTime(nextMonth);
   DrawTrendLine("Monthly Open "/*+TimeToStr(open_m)*/, false, open_m,end_m,iOpen(_Symbol,PERIOD_MN1,0),iOpen(_Symbol,PERIOD_MN1,0),LightSkyBlue,STYLE_SOLID);

   for(int i = 0; i < History_Months; i++)
     {
      //DrawTrendLine("(Old) Monthly Open " + TimeToStr(iTime(_Symbol,PERIOD_MN1,i+1)), false, iTime(_Symbol,PERIOD_MN1,i+1),iTime(_Symbol,PERIOD_MN1,i+0),iOpen(_Symbol,PERIOD_MN1,i+1),iOpen(_Symbol,PERIOD_MN1,i+1),Color_LastPriceOpen,STYLE_SOLID);
     }

   datetime open_y =   iTime(_Symbol,PERIOD_MN1,Month()-1);//StringToTime((string)Year() + ".01.01");
   datetime end_y = StringToTime((string)(Year()+1) + ".01.01");
//datetime open_y = iTime(_Symbol,PERIOD_D1,0);
//DrawTrendLine("Yearly Open ", false, open_y, end_y, iOpen(_Symbol,PERIOD_MN1,Month()-1),iOpen(_Symbol,PERIOD_MN1,Month()-1),Red,STYLE_DASHDOTDOT, false, PERIOD_CURRENT,2);
  }
//+------------------------------------------------------------------+
